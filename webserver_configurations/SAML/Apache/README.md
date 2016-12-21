# Apache mod_auth_mellon module

This module adds Security Assertion Markup Language (SAML) support for Apache.
It let you easily front any VirtualHost with a SAML login page.

Sources and package releases for most recent versions of mod_auth_mellon module can be found at:
https://github.com/UNINETT/mod_auth_mellon

## Install

### Install Apache httpd and the module

First, install Apache httpd and mod_auth_mellon for your distribution.

Example:

```
# On CentOS
$ sudo yum install mod_auth_mellon

# On Ubuntu
$ sudo apt-get install libapache2-mod-auth-mellon
```

Ensure the module is loaded in [Apache configuration] (https://httpd.apache.org/).

### Configure HTTPS

Ensure that your webserver uses HTTPS and a [valid certificate] (https://letsencrypt.org/ "Let's Encrypt").
It's also a good time to follow the [Web Security Guidelines] (https://wiki.mozilla.org/Security/Guidelines/Web_Security) and the [Service Side TLS Guidelines] (https://wiki.mozilla.org/Security/Server_Side_TLS) if you haven't.

### Configure Apache httpd and mod_auth_mellon

By default, your configuration will live in `/etc/httpd/conf.d/your-vhost.conf`.

Follow the examples at https://github.com/mozilla-iam/testrp.security.allizom.org/tree/master/webserver_configurations/SAML/Apache to configure Apache and the mod_auth_mellon module.

You will also need to create metadata and other files as documented in the above configuration, by running this command:

```
$ /usr/libexec/mod_auth_mellon/mellon_create_metadata.sh https://rp.example.net https://rp.example.net/mellon 
```

Additionally, the metadata and certificate files from your SAML Provider will also be needed and also refereed to in the above configuration.

In particular, this configuration ensure that you follow the [SAML Guidelines] (https://wiki.mozilla.org/Security/Guidelines/SAML) regarding session handling and expiration.

Available headers for your web application will look like:

```
MELLON_NAME_ID:ad|Mozilla-LDAP-Dev|gdestuynder
MELLON_http://schemas_xmlsoap_org/ws/2005/05/identity/claims/nameidentifier:ad|Mozilla-LDAP-Dev|gdestuynder
MELLON_http://schemas_xmlsoap_org/ws/2005/05/identity/claims/emailaddress:gdestuynder@mozilla.com
MELLON_http://schemas_xmlsoap_org/ws/2005/05/identity/claims/name:gdestuynder@mozilla.com
MELLON_http://schemas_xmlsoap_org/ws/2005/05/identity/claims/givenname:Guillaume
MELLON_http://schemas_xmlsoap_org/ws/2005/05/identity/claims/surname:Destuynder
MELLON_http://schemas_xmlsoap_org/claims/Group:IntranetWiki:...
MELLON_http://schemas_xmlsoap_org/ws/2005/05/identity/claims/upn:gdestuynder@mozilla.com
MELLON_http://schemas_auth0_com/identities/default/provider:ad
MELLON_http://schemas_auth0_com/identities/default/connection:Mozilla-LDAP-Dev
MELLON_http://schemas_auth0_com/identities/default/isSocial:false
MELLON_http://schemas_auth0_com/nickname:Guillaume Destuynder
MELLON_http://schemas_auth0_com/emails:gdestuynder@mozilla.com
MELLON_http://schemas_auth0_com/dn:mail=gdestuynder@mozilla.com,o=com,dc=mozilla
MELLON_http://schemas_auth0_com/organizationUnits:mail=gdestuynder@mozilla.com,o=com,dc=mozilla
MELLON_http://schemas_auth0_com/given_username:gdestuynder@mozilla.com
MELLON_http://schemas_auth0_com/picture:https://s.gravatar.com/avatar/2a206335017e99ed8b868d931b802f95?s=480&r=pg&d=https%3A%2F%2Fcdn.auth0.com%2Favatars%2Fgd.png
MELLON_http://schemas_auth0_com/email_verified:true
MELLON_http://schemas_auth0_com/clientID:<redacted>
MELLON_http://schemas_auth0_com/updated_at:Wed Dec 21 2016 01:14:23 GMT+0000 (UTC)
MELLON_http://schemas_auth0_com/identities:[object Object]:[object Object]
MELLON_http://schemas_auth0_com/created_at:Fri Dec 02 2016 23:51:33 GMT+0000 (UTC)
MELLON_http://schemas_auth0_com/multifactor:duo
MELLON_Auth0:urn:auth-dev.mozilla.auth0.com
```
