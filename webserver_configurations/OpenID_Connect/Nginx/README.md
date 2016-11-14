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
