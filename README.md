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

# Deployment

This is deployed in the `mozilla-iam` AWS account in the `us-west-2` region. It
is deployed with the CloudFormation template in this repo which creates
* The EC2 instance
* The security group
* An empty IAM role in case one's needed
* The elastic IP

The instance can be accessed with the `websre-20210715` EIS shared SSH key in the password store.

The CloudFormation template provisions the instance using a custom AMI based on
CentOS 7. This AMI was created from the live running instance previously in
the `infosec-dev` account and as a result it has some non public data in the AMI
(letsencrypt private keys, logs)

To deploy the CloudFormation template, either upload it to the AWS web console
or deploy with the awscli, providing the SSH key name that the instance should
be provisioned with as the one parameter that the template takes.

```bash
    aws cloudformation create-stack \
        --stack-name testrp \
        --template-body file://cloudformation/testrp.yaml \
        --capabilities CAPABILITY_IAM \
        --parameters \
            ParameterKey=SSHKeyName,ParameterValue='websre-20210715'
 ```

To update the template use the following command:

```bash
    aws cloudformation update-stack \
        --stack-name testrp \
        --template-body file://cloudformation/testrp.yaml \
        --capabilities CAPABILITY_IAM \
        --parameters \
            ParameterKey=SSHKeyName,ParameterValue='websre-20210715'
 ```

## Accessing the server

`ssh -i ~/.ssh/websre-20210715 centos@testrp.security.allizom.org`

The Route53 records for `testrp.security.allizom.org` and `*.testrp.security.allizom.org`
are A records which resolve to an Elastic IP (EIP). As a result, the EC2 instance
will retain it's IP if stopped and started again and the DNS names will continue
to resolve correctly.

The Route53 zone `security.allizom.org` is hosted in the `infosec-dev` AWS account.
It would be good if the testrp service was transitioned to something in a zone
in the `mozilla-iam` AWS account

## Logs

Logs for the webserver are located in

`/usr/local/openresty/nginx/logs/error.log`
`/usr/local/openresty/nginx/logs/access.log`

These logs are rotated with a manually provisioned `/etc/logrotate.d/openresty`
configuration file to prevent them from filling the 8GB disk.

## Restarting the web server

You can restart the webserver by running `systemctl restart openresty.service`
