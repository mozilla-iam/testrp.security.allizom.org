# Apache mod_auth_openidc module

This module adds OpenID Connect (OIDC) support for Apache.
It let you easily front any VirtualHost with an OIDC login page.

Sources and package releases for most recent versions of mod_auth_openidc module can be found at:
https://github.com/pingidentity/mod_auth_openidc

**NOTE**: mod-auth-openidc does not currently support querying the /delegate endpoint to re-new the id_token. While the id_token is introspected in our configuration, it also means the session will timeout when the id_token expire regardless (as it cannot be automatically renewed). This is not a security concern, but it is a UX concern.

## Install

### Install Apache httpd and the module

First, install Apache httpd and mod-auth-openidc for your distribution.

Example:

```
# On CentOS
$ sudo yum install epel-release
$ sudo yum install mod_auth_openid

# On Ubuntu
$ sudo apt-get install libapache2-mod-auth-openidc
```

Ensure the module is loaded in [Apache configuration] (https://httpd.apache.org/).

### Configure HTTPS

Ensure that your webserver uses HTTPS and a [valid certificate] (https://letsencrypt.org/ "Let's Encrypt").
It's also a good time to follow the [Web Security Guidelines] (https://wiki.mozilla.org/Security/Guidelines/Web_Security) and the [Service Side TLS Guidelines] (https://wiki.mozilla.org/Security/Server_Side_TLS) if you haven't.

### Configure Apache httpd and mod-auth-openidc

By default, your configuration will live in `/etc/httpd/conf.d/your-vhost.conf`.

Follow the examples at https://github.com/mozilla-iam/testrp.security.allizom.org/tree/master/webserver_configurations/OpenID_Connect/Apache to configure Apache and the mod-auth-openidc module.

In particular, the Lua module configuration ensure that you follow the [OpenID Connect Guidelines] (https://wiki.mozilla.org/Security/Guidelines/OpenID_Connect) regarding session handling and expiration.

Available headers for your web application will look like:

```
REMOTE_USER: ad|auth0ldap-dev1|gdestuynder@auth-dev.mozilla.auth0.com/ 
HTTP_COOKIE: mod_auth_openidc_session=<redacted>
OIDC_CLAIM_organizationUnits: mail=gdestuynder@mozilla.com,o=com,dc=mozilla
OIDC_CLAIM_updated_at: 2016-10-28T23:30:14.138Z
OIDC_CLAIM_family_name: Destuynder
OIDC_CLAIM_name: gdestuynder@mozilla.com
OIDC_CLAIM_nickname: Guillaume Destuynder
OIDC_CLAIM_given_name: Guillaume
OIDC_CLAIM_dn: mail=gdestuynder@mozilla.com,o=com,dc=mozilla
OIDC_CLAIM_groups: SecurityWiki, ...
OIDC_CLAIM_created_at: 2016-10-28T23:12:58.291Z
OIDC_CLAIM_email: gdestuynder@mozilla.com
OIDC_CLAIM_emails: gdestuynder@mozilla.com
OIDC_CLAIM_user_id: ad|auth0ldap-dev1|gdestuynder
OIDC_CLAIM_multifactor: duo
OIDC_CLAIM_exp: 1477698314
OIDC_CLAIM_iat: 1477697414
OIDC_CLAIM_aud: <redacted>
OIDC_access_token: <redacted>
```
