# Nginx lua-resty-openidc module

This module adds OpenID Connect (OIDC) support for Nginx.
It let you easily front any Location with an OIDC login page.

Sources and package releases for most recent versions of lua-resty-openidc module can be found at:
https://github.com/pingidentity/mod_auth_openidc and https://github.com/mozilla-iam/lua-resty-openidc

## Install

### Install OpenResty and the modules

First, install OpenResty (which is Nginx with Lua support) by following the documentation at https://openresty.org/en/linux-packages.html

Then, you'll want to install the lua-resty-openidc module. The easiest is to use luarocks:

```
# For CentOS
$ sudo yum install epel-release
$ sudo yum install luarocks
$ sudo luarocks install lua-resty-openidc

# For Ubuntu
$ sudo apt-get install luarocks
$ sudo luarocks install lua-resty-openidc
```

### Configure HTTPS

Ensure that your webserver uses HTTPS and a [valid certificate] (https://letsencrypt.org/ "Let's Encrypt").
It's also a good time to follow the [Web Security Guidelines] (https://wiki.mozilla.org/Security/Guidelines/Web_Security) and the [Service Side TLS Guidelines] (https://wiki.mozilla.org/Security/Server_Side_TLS) if you haven't.

### Configure Nginx (OpenResty)

By default, your configuration will live in `/usr/local/openresty/nginx/conf/`
Follow the examples at https://github.com/mozilla-iam/testrp.security.allizom.org/tree/master/webserver_configurations/OpenID_Connect/Nginx to configure Nginx and the Lua module.
In particular, the Lua module configuration ensure that you follow the [OpenID Connect Guidelines] (https://wiki.mozilla.org/Security/Guidelines/OpenID_Connect) regarding session handling and expiration.

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
