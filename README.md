# testrp.security.allizom.org
Mozilla IAM demo reference architectures, configurations, etc. to implement OIDC, SAML in different ways

You can see this in action at https://testrp.security.allizom.org/

# What can I do with this?

- Test (https://testrp.security.allizom.org/), see how the login and implementation look like.
- Copy examples, to implement your own easily.

## Supported protocols

- OpenID Connect (OIDC)
- SAML

## Easy "get a login page in front of my site"

- Run an Apache reverse-proxy in front of your web-site that requires login and specific group membership to access the site. Session, Login, etc. will be cared for automatically.
- Run the equivalent Nginx reverse-proxy.
- All attributes are also passed in HTTP headers to your site.

## Future
### More advanced login integrations

- Run Python code that allows you to integrate the login experience better (for example through a sign-in button)
- Run equivalent NodeJS, etc. code.

### Integrate an authorization flow (via OAuth2)

- Run an Nginx reverse-proxy that passes access tokens to access data on behalf of users/machines.
- Allow other applications to request tokens from you.
