# Jenkins and the access-proxy ("reverse-proxy")

# Access proxy installation

Follow the documentation at https://github.com/mozilla-iam/testrp.security.allizom.org/tree/master/webserver_configurations/OpenID_Connect/Nginx in order the setup the access-proxy. Nginx is recommended in this case, though you could create your own setup with Apache if required.

It is important to to ensure that the HTTP headers `X-Forwarded-Groups` and `X-Forwarded-User` are set so that Jenkins can understand them. By default, our configuration will send these correctly so no additional configuration is required.

# Jenkins Reverse Proxy Auth plugin installation
In order to run behind the access-proxy Jenkins requires a specific plugin that will use the HTTP headers from the access-proxy to set the username and utilize the groups of the authenticated user.


Follow directions at https://wiki.jenkins-ci.org/display/JENKINS/Reverse+Proxy+Auth+Plugin in order to install the plugin.
Ignore the Apache specific configuration from that page, and use the access-proxy configuration itself instead (it works by default).
