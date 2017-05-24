-- Lua reference for nginx: https://github.com/openresty/lua-nginx-module
-- Lua reference for openidc: https://github.com/pingidentity/lua-resty-openidc
local oidc = require("resty.openidc")
local cjson = require( "cjson" )

Set = {}

function Set.new (t)
  local set = {}
  for _, l in ipairs(t) do set[l] = true end
  return set
end

function Set.union (a,b)
  local res = Set.new{}
  for k in pairs(a) do res[k] = true end
  for k in pairs(b) do res[k] = true end
  return res
end

function Set.intersection (a,b)
  local res = Set.new{}
  for k in pairs(a) do
    res[k] = b[k]
  end
  return res
end

function Set.a_not_in_b (a,b)
  local res = Set.new{}
  for k in pairs(a) do
    if b[k] == nil then
      res[k] = a[k]
    end
  end
  return res
end

function Set.tostring (set)
  local s = "{"
  local sep = ""
  for e in pairs(set) do
    s = s .. sep .. e
    sep = ", "
  end
  return s .. "}"
end

function Set.print (s)
  print(Set.tostring(s))
end

function Set.totable(set)
  local res={}
  local n=0

  for k,_ in pairs(set) do
    n=n+1
    res[n]=k
  end
  return res
end

local function table_to_string(table)
  local s = ""
  for _,v in pairs(table) do
    s = s and s.."|"..v or v
  end
  return s
end

local function compare_sessions(s1, s2)
  -- check that both OPs authenticated the same user
  local res = s1.data.user.email == s2.data.user.email
  if res == false then
    ngx.log(ngx.ERR, "User authenticated as different identities in primary and secondary auth")
  end
  return res
end

local function get_group_intersection(s1, s2)
  -- given two sessions return the OIDC claimed groups present in both sessions
  return Set.totable(Set.intersection(Set.new(s1.data.user.groups and s1.data.user.groups or {}), Set.new(s2.data.user.groups and s2.data.user.groups or {})))
end

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

-- Load config
primary = {}
secondary = {}
local f, e = loadfile(ngx.var.config_loader)
if f == nil then
  ngx.log(ngx.ERR, "can't initialize loadfile: "..e)
end
ok, e = pcall(f)
if not ok then
  ngx.log(ngx.ERR, "can't load configuration: "..e)
end

-- Authenticate with the primary OP if necessary
local res, err, url, session = oidc.authenticate(primary.opts)
primary.session = session

-- Check if authentication succeeded, otherwise kick the user out
if err then
  if primary.session ~= nil then
    primary.session:destroy()
  end
  ngx.redirect(primary.opts.logout_path)
end

ngx.log(ngx.DEBUG, "Primary authentication completed")

-- Pass the user identity from the primary OP to the secondary OP
secondary.opts.authorization_params = secondary.opts.authorization_params and secondary.opts.authorization_params or {}
secondary.opts.authorization_params.login_hint = primary.session.data.id_token.email

-- Authenticate with the secondary OP if necessary
local res, err, url, session = oidc.authenticate(secondary.opts, nil, secondary.session_opts)
secondary.session = session

-- Check if authentication succeeded, otherwise kick the user out
if err then
  ngx.log(ngx.ERR, "Error during secondary authentication")
  if secondary.session ~= nil then
    secondary.session:destroy()
  end
  ngx.redirect(secondary.opts.logout_path)
end

ngx.log(ngx.DEBUG, "Secondary authentication completed")

-- Compare the results of both authentication attempts
if not compare_sessions(primary.session, secondary.session) then
  primary.session:destroy()
  secondary.session:destroy()
  ngx.redirect(primary.opts.logout_path)
end

-- Replace the group list with the intersection of the group lists returned from each OP
local groups = get_group_intersection(primary.session, secondary.session)
primary.session.data.user.groups = groups
primary.session.data.id_token.groups = groups

-- Access control: only allow specific users in (this is optional, without it all authenticated users are allowed in)
-- (TODO: add example)

-- Set headers with user info and OIDC claims for the underlaying web application to use (this is optional)
-- These header names are voluntarily similar to Apaches mod_auth_openidc, but may of course be modified
ngx.req.set_header("REMOTE_USER", primary.session.data.id_token.email)
ngx.req.set_header("X-Forwarded-User", primary.session.data.id_token.email)
ngx.req.set_header("PRIMARY_OIDC_CLAIM_ACCESS_TOKEN", primary.session.data.access_token)
ngx.req.set_header("PRIMARY_OIDC_CLAIM_ID_TOKEN", primary.session.data.enc_id_token)
ngx.req.set_header("SECONDARY_OIDC_CLAIM_ACCESS_TOKEN", secondary.session.data.access_token)
ngx.req.set_header("SECONDARY_OIDC_CLAIM_ID_TOKEN", secondary.session.data.enc_id_token)
ngx.req.set_header("UNCORROBORATED_GROUPS", Set.totable(Set.a_not_in_b(Set.new(primary.session), Set.new(secondary.session))))
ngx.req.set_header("via",primary.session.data.id_token.email)


build_headers(primary.session.data.id_token, "ID_TOKEN_")
build_headers(primary.session.data.user, "USER_PROFILE_")
build_headers(secondary.session.data.id_token, "ID_TOKEN_SECONDARY_")
build_headers(secondary.session.data.user, "USER_PROFILE_SECONDARY_")

-- Flat groups, useful for some RP's that won't read JSON
ngx.req.set_header("X-Forwarded-Groups", table_to_string(groups))
