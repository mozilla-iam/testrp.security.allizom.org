# Nginx lua-resty-openidc module

This module adds OpenID Connect (OIDC) support for Nginx.
It let you easily front any Location with an OIDC login page.

Sources and package releases for most recent versions of lua-resty-openidc module can be found at https://github.com/pingidentity/lua-resty-openidc

## Install

### Install OpenResty and the modules

First, install OpenResty (which is Nginx with Lua support) by following the documentation at https://openresty.org/en/linux-packages.html

Then, you'll want to install the lua-resty-openidc module. The easiest is to use luarocks.

#### Install with luarocks (lua-resty-openidc 1.3.2 and above to have session refresh support)

```
# For CentOS
$ sudo yum install epel-release
$ sudo yum install luarocks
$ sudo luarocks install lua-resty-openidc

# For Ubuntu
$ sudo apt-get install luarocks
$ sudo luarocks install lua-resty-openidc
```

### Configure HTTPS (you may skip this step if you have already done so yourself)

Ensure that your webserver uses HTTPS and a [valid certificate] (https://letsencrypt.org/ "Let's Encrypt").
It's also a good time to follow the [Web Security Guidelines] (https://wiki.mozilla.org/Security/Guidelines/Web_Security) and the [Service Side TLS Guidelines] (https://wiki.mozilla.org/Security/Server_Side_TLS) if you haven't.

**Note**: we're using letsencrypt in this setup, which uses a centralized well-known directory. This allows to renew all domains with a set of similar commands per domain or group of domains:

```
$ certbot certonly --webroot -w /var/www/well-known -d "testrp.security.allizom.org"
$ certbot certonly --webroot -w /var/www/well-known -d "social-ldap-pwless.testrp.security.allizom.org"
...
```

You can then auto-renew with a crontab such as (every sunday, it checks and renew if needed):
```
0 0 * * 0    certbot renew --quiet --no-self-upgrade
```

### Configure Nginx (OpenResty)

By default, your configuration will live in `/usr/local/openresty/nginx/conf/`
Full real-world examples are available at https://github.com/mozilla-iam/testrp.security.allizom.org/tree/master/webserver_configurations/OpenID_Connect/Nginx to configure Nginx and the Lua module.
In particular, the Lua module configuration ensure that you follow the [OpenID Connect Guidelines] (https://wiki.mozilla.org/Security/Guidelines/OpenID_Connect) regarding session handling and expiration.

#### Setup
If you would to quickly copy-paste the setup instead of reading through above complete examples, fill in your configurations with the following:

**OpenIDC Layer**
This is your `openidc_layer.lua` - a shim that adds functionality to the openidc library.
Put it where you want it, but usually in the nginx configuration directory, such as `/etc/nginx/openidc_layer.lua` or `/usr/local/openresty/nginx/conf/openidc_layer.lua` for example
You can and perhaps should customize this file to pass the headers you want instead of the default.
You can also do some access control in there if you wish.

Since it's a big file that you don't need to copy-paste, just get it from GitHub.

```
$ wget https://github.com/mozilla-iam/testrp.security.allizom.org/blob/master/webserver_configurations/OpenID_Connect/Nginx/conf.d/openidc_layer.lua
$ sudo mv openidc_layer.lua /usr/local/openresty/nginx/conf/
```

You can now setup the rest of Nginx:

```
# This goes in your main nginx configuration
http {
    # The Lua package path is important, and must match your installation/setup.
    # If you get any issue with packages not found in your error logs ("require" failures), add the missing path here.
    lua_package_path '~/lua/?.lua;/usr/share/lua/5.1/?.lua;;';
    lua_package_cpath '/usr/share/lua/5.1/?.so;/usr/lib64/lua/5.1/?.so;;';

    lua_ssl_trusted_certificate "/etc/ssl/certs/ca-bundle.crt";
    lua_ssl_verify_depth 5;
    lua_shared_dict discovery 1m;
    lua_shared_dict introspection 15m;
    lua_shared_dict sessions 10m;
}
```

```
# This goes in your server / vhost for nginx, which may be a separate file depending on your setup
server {
  # "cookie" session storage won't work as cookies will be >4k, which then will be truncated and fail decoding
  set $session_storage shm;
  set $session_cookie_persistent on;
  set $session_cookie_path "/";
  # SSI check must be off or Nginx will kill our sessions when using lua-resty-session (which we do use)
  set $session_check_ssi off;
  set $session_secret "YOUR SESSION SECRET TGOES HERE"; #Output of openssl rand -hex 32 for example (must be 32 characters)

  # Where your OIDC config is
  set $config_loader "YOUR CONFIGURATION GOES HERE.lua";

  # Loads our shim/layer for openidc
  location / {
    # ENSURE THIS IS WHERE YOUR openidc_layer.lua IS STORED
    access_by_lua_file 'conf/openidc_layer.lua';
  }
}

```

#### Headers sample

Available headers for your web application will look like:

```
HTTP_REMOTE_USER:ad|Mozilla-LDAP-Dev|testuser
HTTP_OIDC_CLAIM_ACCESS_TOKEN:<redacted>
HTTP_OIDC_CLAIM_ID_TOKEN:<redacted>
HTTP_OIDC_CLAIM_ID_TOKEN_UPDATED_AT:2016-11-12T04:01:19.960Z
HTTP_OIDC_CLAIM_ID_TOKEN_NICKNAME:Testuser User
HTTP_OIDC_CLAIM_ID_TOKEN_GROUPS:["IntranetWiki", ...]
HTTP_OIDC_CLAIM_ID_TOKEN_IDENTITIES:[{"user_id":"Mozilla-LDAP-Dev|testuser","isSocial":false,"provider":"ad","connection":"Mozilla-LDAP-Dev"}]
HTTP_OIDC_CLAIM_ID_TOKEN_PICTURE:<redacted>
HTTP_OIDC_CLAIM_ID_TOKEN_SUB:ad|Mozilla-LDAP-Dev|testuser
HTTP_OIDC_CLAIM_ID_TOKEN_USER_ID:ad|Mozilla-LDAP-Dev|testuser
HTTP_OIDC_CLAIM_ID_TOKEN_DN:mail=testuser@mozilla.com,o=com,dc=mozilla
HTTP_OIDC_CLAIM_ID_TOKEN_ORGANIZATIONUNITS:mail=testuser@mozilla.com,o=com,dc=mozilla
HTTP_OIDC_CLAIM_ID_TOKEN_CLIENTID:<redacted>
HTTP_OIDC_CLAIM_ID_TOKEN_IAT:1478923280
HTTP_OIDC_CLAIM_ID_TOKEN_EMAILS:["testuser@mozilla.com"]
HTTP_OIDC_CLAIM_ID_TOKEN_NONCE:<redacted>
HTTP_OIDC_CLAIM_ID_TOKEN_CREATED_AT:2016-11-07T19:18:23.403Z
HTTP_OIDC_CLAIM_ID_TOKEN_MULTIFACTOR:["duo"]
HTTP_OIDC_CLAIM_ID_TOKEN_GIVEN_NAME:Testuser
HTTP_OIDC_CLAIM_ID_TOKEN_BLOCKED:false
HTTP_OIDC_CLAIM_ID_TOKEN_FAMILY_NAME:User
HTTP_OIDC_CLAIM_ID_TOKEN_EXP:1479528080
HTTP_OIDC_CLAIM_ID_TOKEN_AUD:<redacted>
HTTP_OIDC_CLAIM_ID_TOKEN_ISS:https://auth-dev.mozilla.auth0.com/
HTTP_OIDC_CLAIM_ID_TOKEN_NAME:testuser@mozilla.com
HTTP_OIDC_CLAIM_ID_TOKEN_EMAIL:testuser@mozilla.com
HTTP_OIDC_CLAIM_USER_PROFILE_UPDATED_AT:2016-11-12T04:01:19.960Z
HTTP_OIDC_CLAIM_USER_PROFILE_NICKNAME:Testuser User
HTTP_OIDC_CLAIM_USER_PROFILE_GROUPS:["IntranetWiki", ,,,]
HTTP_OIDC_CLAIM_USER_PROFILE_IDENTITIES:[{"user_id":"Mozilla-LDAP-Dev|testuser","isSocial":false,"provider":"ad","connection":"Mozilla-LDAP-Dev"}]
HTTP_OIDC_CLAIM_USER_PROFILE_PICTURE:<redacted>
HTTP_OIDC_CLAIM_USER_PROFILE_SUB:ad|Mozilla-LDAP-Dev|testuser
HTTP_OIDC_CLAIM_USER_PROFILE_USER_ID:ad|Mozilla-LDAP-Dev|testuser
HTTP_OIDC_CLAIM_USER_PROFILE_DN:mail=testuser@mozilla.com,o=com,dc=mozilla
HTTP_OIDC_CLAIM_USER_PROFILE_ORGANIZATIONUNITS:mail=testuser@mozilla.com,o=com,dc=mozilla
HTTP_OIDC_CLAIM_USER_PROFILE_CLIENTID:<redacted>
HTTP_OIDC_CLAIM_USER_PROFILE_EMAIL:testuser@mozilla.com
HTTP_OIDC_CLAIM_USER_PROFILE_CREATED_AT:2016-11-07T19:18:23.403Z
HTTP_OIDC_CLAIM_USER_PROFILE_GIVEN_NAME:Testuser
HTTP_OIDC_CLAIM_USER_PROFILE_FAMILY_NAME:User
HTTP_OIDC_CLAIM_USER_PROFILE_EMAILS:["testuser@mozilla.com"]
HTTP_OIDC_CLAIM_USER_PROFILE_MULTIFACTOR:["duo"]
HTTP_OIDC_CLAIM_USER_PROFILE_NAME:testuser@mozilla.com
HTTP_OIDC_CLAIM_USER_PROFILE_BLOCKED:false
```

NOTE: Depending on your setup, you may not have headers prepended by 'HTTP_' - in this case, 'HTTP_OIDC_CLAIM_ID_TOKEN' would look like 'OIDC_CLAIM_ID_TOKEN' instead.
