-- lua-resty-openidc options
opts = {
  redirect_uri_path = "/redirect_uri",
  discovery = "https://auth-dev.mozilla.auth0.com/.well-known/openid-configuration",
  client_id = "YOUR CLIENT ID HERE",
  client_secret = "YOUR CLIENT SECRET HERE",
  scope = "openid email profile",
  iat_slack = 600,
  redirect_uri_scheme = "https",
  logout_path = "/logout"
}
-- Auth0 delegation endpoint
delegation_endpoint = "https://auth-dev.mozilla.auth0.com/delegation"
-- How often to renew the id_token in seconds (i.e. when disabled, blocked users will be logged out)
id_token_renew_delay = 900
