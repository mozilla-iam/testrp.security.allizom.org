-- lua-resty-openidc options
primary = {  -- Table containing options for the primary OIDC OP
  opts = {   -- resty.openidc options
    redirect_uri_path = "/redirect_uri",
    discovery = "https://auth-dev.mozilla.auth0.com/.well-known/openid-configuration",
    client_id = "CLIENT ID GOES HERE",
    client_secret = "CLIENT SECRET GOES HERE",
    scope = "openid email profile",
    iat_slack = 600,
    redirect_uri_scheme = "https",
    logout_path = "/logout",
    redirect_after_logout_uri = "https://testrp.security.allizom.org/?uri=https://ldap-second-opinion.testrp.security.allizom.org/",
    refresh_session_interval = 900
  },
  session_opts = {  -- resty.session options
    name = "primary"
  }
}
secondary = {  -- Table containing options for the secondary OIDC OP
  opts = {   -- resty.openidc options
    redirect_uri_path = "/second-opinion/redirect_uri",
    discovery = "https://second-opinion.security.mozilla.org/.well-known/openid-configuration",
    client_id = "CLIENT ID GOES HERE",
    client_secret = "CLIENT SECRET GOES HERE",
    scope = "openid email profile",
    iat_slack = 600,
    redirect_uri_scheme = "https",
    logout_path = "/logout",
    redirect_after_logout_uri = "https://testrp.security.allizom.org/?uri=https://ldap-second-opinion.testrp.security.allizom.org/",
    refresh_session_interval = 900
  },
  session_opts = {  -- resty.session options
    name = "secondary"
  }
}