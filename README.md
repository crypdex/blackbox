<img src="http://crypdex.io/img/full-logo.svg" width=300 style="margin-bottom:20px;"/>

This repository contains code and instructions for the deployment of Crypdex local systems. It may likely also be used for hosted deployments as well.

<hr />
<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Common Setup](#common-setup)
  - [1. SSH Identity](#1-ssh-identity)
    - [2. Clone this Repo](#2-clone-this-repo)
- [Little Black Box](#little-black-box)
- [Big Black Box (x86)](#big-black-box-x86)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

<hr />

# Common Setup

Regardless of the deployent environment, the following setup should be followed to assure that the box can get this repository and update itself.

The update strategy is a simple `git pull`, but to do so on a private repository (like this one), requires that this repository has a common "deploy key" set, which it does.

**If you remove the deploy key or rename the repo then remote updates will break.** There currently is no strategy for rotating the deploy keys on remote machines.

## 1. SSH Identity

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

# Little Black Box

arm64

# Big Black Box (x86)

x86
