<img src="http://crypdex.io/img/full-logo.svg" width=300 style="margin-bottom:20px;"/>

# Black Box

## Deployment

There some preparations necessary to get the box bootstrapped.

### 1. Common SSH Identity

On the Black Box, add following to `~/.ssh/config`

```bash
# ~/.ssh/config
Host blackbox.github.com
HostName github.com
PreferredAuthentications publickey
IdentityFile ~/.ssh/id_rsa_blackbox
```

Set the correct file permissions for the keys

```shell
$ chmod 600 ~/.ssh/id_rsa_blackbox; chmod 600 ~/.ssh/id_rsa_blackbox.pub
```

### 2. Clone this Repo

```shell
$ cd; git clone git@blackbox.github.com:crypdex/blackbox.git
```
