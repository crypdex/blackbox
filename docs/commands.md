---
title: Commands
sidebar_label: Commands
---

A complete list of commands with descriptions is available if you type `blackboxd help` .

```shell
$ blackboxd help

A pluggable platform for multi-chain deployments

Usage:
  blackboxd [command]

Available Commands:
  bin         Commands for binary wrappers
  cleanup     Removes dead containers
  help        Help about any command
  info        Displays the current configuration
  logs        Show the logs of all running containers
  ps          Show Docker processes
  reset       Reset sensitive data
  start       Start your Blackbox app
  stop        Stop your Blackbox and all related services
  version     Displays the current version

Flags:
  -c, --config string   config file (default is $HOME/.blackbox/blackbox.yml)
  -d, --debug           debug is off by default
  -h, --help            help for blackboxd
  -t, --toggle          Help message for toggle

Use "blackboxd [command] --help" for more information about a command.
```

## Start
