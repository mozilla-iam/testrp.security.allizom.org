-- Lua reference for nginx: https://github.com/openresty/lua-nginx-module
-- Lua reference for openidc: https://github.com/pingidentity/lua-resty-openidc
local oidc = require("resty.openidc")
local os = require("os")
local cjson = require( "cjson" )
local http = require("resty.http")

-- Load config
local f, e = loadfile(ngx.var.config_loader)
if f == nil then
  ngx.log(ngx.ERR, "can't initialize loadfile: "..e)
end
ok, e = pcall(f)
if not ok then
  ngx.log(ngx.ERR, "can't load configuration: "..e)
end

-- From openidc.lua
local function my_openidc_base64_url_decode(input)
  local reminder = #input % 4
  if reminder > 0 then
    local padlen = 4 - reminder
    input = input .. string.rep('=', padlen)
  end
  input = input:gsub('-','+'):gsub('_','/')
  return ngx.decode_base64(input)
end

-- Authenticate with lua-resty-openidc if necessary (this will return quickly if no authentication is necessary)
local res, err, url, session = oidc.authenticate(opts)

-- Check if authentication succeeded, otherwise kick the user out
if err then
  if session ~= nil then
    session:destroy()
  end
  ngx.redirect(opts.logout_path)
end

-- We only support method: client_secret_post
if session.data.last_id_token == nil or ((session.data.last_id_token+id_token_renew_delay) < os.time()) then
-- Renew id_token with the delegation endpoint
-- This is survivable if the call fails, though if it keeps failing the user will eventually be logged out when the id_token expires (thats our fail-safe)
  local body = { client_id = opts.client_id,
    api_type = "app",
    grant_type = "urn:ietf:params:oauth:grant-type:jwt-bearer",
    id_token = session.data.enc_id_token
  }
  local httpc = http.new()
  local res1, err = httpc:request_uri(delegation_endpoint, {
      method = "POST",
      body = ngx.encode_args(body),
      headers = {["Content-Type"] = "application/x-www-form-urlencoded"},
      ssl_verify = true
      }
      )
  if not res1 or err ~=nil or res1.status ~= 200 then
    ngx.log(ngx.ERR, "accessing id_token delegation endpoint failed.")
    ngx.status(res1.status)
    ngx.say(err)
    ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
  end

  ngx.log(ngx.DEBUG, "delegation endpoint response: ", res1.body)
  delegation_json = cjson.decode(res1.body)

  local enc_hdr, enc_pay, enc_sign = string.match(delegation_json.id_token, '^(.+)%.(.+)%.(.+)$')
  local jwt = my_openidc_base64_url_decode(enc_pay)
  local new_id_token = cjson.decode(jwt)

  -- New id_token will be validated at next call
  -- (TODO: handle this in current call)

  -- Authentication succeded and we got a new id_token
  -- Also set session life-time. Lua also stores and enforces this server-side.
  for k,v in pairs(new_id_token) do session.data.id_token[k] = v end
  session.data.enc_id_token = delegation_json.id_token          
  session.data.last_id_token = os.time()
  session.cookie.lifetime = tonumber(new_id_token.exp) - os.time()
  session:save()
end
-- Access control: only allow specific users in (this is optional, without it all authenticated users are allowed in)
-- (TODO: add example)

-- Set headers with user info and OIDC claims for the underlaying web application to use (this is optional)
-- These header names are voluntarily similar to Apaches mod_auth_openidc, but may of course be modified
ngx.req.set_header("REMOTE_USER", session.data.id_token.user_id)
ngx.req.set_header("OIDC_CLAIM_ACCESS_TOKEN", session.data.access_token)
ngx.req.set_header("OIDC_CLAIM_ID_TOKEN", session.data.enc_id_token)

local function build_headers(t, name)
  for k,v in pairs(t) do
    -- unpack tables
    if type(v) == "table" then
      local j = cjson.encode(v)
      ngx.req.set_header("OIDC_CLAIM_"..name..k, j)
    else
      ngx.req.set_header("OIDC_CLAIM_"..name..k, tostring(v))
    end
  end
end

build_headers(session.data.id_token, "ID_TOKEN_")
build_headers(session.data.user, "USER_PROFILE_")
