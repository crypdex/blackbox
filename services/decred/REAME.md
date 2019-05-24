# Decred

The `decred` service is composed of 2 individual services: `dcrd` and `dcrwallet`. These sub-services are not currently separable from the main `decred` service since they function together.

To use the recipe, configure you `blackbox.yml` file as follows:

```yaml
version: '3.7'

x-blackbox:
  data_dir: /Volumes/T5/data
  recipe: decred
```

## Create your wallet

You must manually create your DCR wallet.

```bash
# First specify where you want this generated
$ export DECRED_DATA_DIR=

# Then, if you are working in this repo
$ ./services/decred/bin/dcrwallet-create

# or if you have blackboxd installed
$ /var/lib/blackbox/services/decred/bin/dcrwallet-create
```

When you first run the application it will generate the RPC certs and then as

## TLS Certs

Decred is pretty serious about security and verification in its communications. As such, it uses TLS certs for its RPC connections. The daemons generate their own certs if left alone, but the daemon generated certs are not compatible with this Docker network. This is due to the way that the domains are registered in the cert.

This project generates certs that can be used to get Decred working in its default case. This happens at service boot (see the prestart script). If you would like to heighten your own security, you may generate new certs manually.
