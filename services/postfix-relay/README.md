# Postfix Mail Relay for arm64

Simple SMTP relay, originally based on [alterrebe/docker-mail-relay](https://github.com/alterrebe/docker-mail-relay), but has been rewritten since.

This fork by Crypdex only changes the base image to support arm64 targets.

```
docker run crypdex/postfix-relay:latest
```

## Description

The container provides a simple SMTP relay for environments like Amazon VPC where you may have private servers with no Internet connection
and therefore with no access to external mail relays (e.g. Amazon SES, SendGrid and others). You need to supply the container with your
external mail relay address and credentials. The image is tested with `Amazon SES`, `Sendgrid`, `Gmail` and `Mandrill`

## Changes from `alterrebe/docker-mail-relay`

- Uses `alpine` image instead of `ubuntu`.
- Uses `envsubst` for templating instead of `j2cli`.
- All output goes to `stdout` and `stderr` including `maillog`.
- Included `superviserd` event watcher which will exit the `supervisord` process if one of the monitored processes dies unexpectedly.
- Doesn't use TLS on `smtpd` side.
- And other changes to make the image as **KISS** as possible

## Environment variables

| ENV. Variable            | Description                                                                                                                      |
| ------------------------ | -------------------------------------------------------------------------------------------------------------------------------- |
| `ACCEPTED_NETWORKS`      | Space delimited list of networks to accept mail from. <br/> Default: `192.168.0.0/16 172.16.0.0/12 10.0.0.0/8`                   |
| `RECIPIENT_RESTRICTIONS` | Space delimited list of allowed `RCPT TO` addresses. <br/> Default: **unrestricted**                                             |
| `SMTP_HOST`              | External relay DNS name. <br/> Default: `email-smtp.us-east-1.amazonaws.com`                                                     |
| `SMTP_PORT`              | External relay TCP port. <br/> Default: `25`                                                                                     |
| `SMTP_LOGIN`             | Login to connect to the external relay. <br/> **Required**                                                                       |
| `SMTP_PASSWORD`          | Password to connect to the external relay. <br/> **Required**                                                                    |
| `USE_TLS`                | Remote require tls. Must be `yes` or `no`. <br/> Default: `no`                                                                   |
| `TLS_VERIFY`             | Trust level for checking remote side cert. <br/> Default: `may` (http://www.postfix.org/postconf.5.html#smtp_tls_security_level) |

## Exposed port(s)

Postfix on port `25`

## Example

Launch Postfix container:

    docker run -d -h relay.example.com --name="mailrelay" \
        -e RECIPIENT_RESTRICTIONS="gmail.com test@example.com" \
        -e SMTP_LOGIN=myLogin \
        -e SMTP_PASSWORD=myPassword \
        -p 25:25 \
        simenduev/postfix-relay
