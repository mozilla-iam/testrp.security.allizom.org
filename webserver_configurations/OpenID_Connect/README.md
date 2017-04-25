# Example configurations

## Basic recommendations

* Use a reverse-proxy where possible instead of a native OpenID Connect implementation:
 * Ensures separation between the application layer and authentication.
 * Easier to manage sessions, users, etc. It's already taken care of.
 * Simpler code-base.
* Enforce some level of access at the reverse-proxy:
 * Enforces access control seperately from the application.
 * It's still possible and often wanted to do more fine grained access control at the application level as well.


**NOTE**: The reverse-proxy is also often called an access-proxy as it enforces authentication and authorization separately from the web application.

## Apache and Nginx

These are standard reverse proxy configuration with OpenID Connect.
They can front any web-server and provide authenticated users with metadata (group membership, etc.) that are provided via HTTP Headers.

The communication to these proxies must be encrypted (TLS), and the communication between the proxy and the web application must also be protected (e.g. run on the same machine, or use TLS).

* **Apache**: https://github.com/mozilla-iam/testrp.security.allizom.org/tree/master/webserver_configurations/OpenID_Connect/Apache
* **Nginx**: https://github.com/mozilla-iam/testrp.security.allizom.org/tree/master/webserver_configurations/OpenID_Connect/Nginx

## Jenkins

This is a specific setup that use the above proxy, but with more details on how to setup Jenkins behind the reverse-proxy.

* **Jenkins**: https://github.com/mozilla-iam/testrp.security.allizom.org/tree/master/webserver_configurations/OpenID_Connect/Jenkins
