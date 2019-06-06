You must pass at least the following flags (using Litecoin as an example)

```
--litecoin.active
--litecoin.mainnet
--litecoin.node=litecoind
```

In order to speak to the chain daemon, you must either set the directory where LND can find the config and chain data

```
--litecoind.dir=/home/lnd/.litecoin (.ltcd)
```

or pass in the RPC credentials

```
--litecoind.rpcuser=
--litecoind.rpcpass=
--litecoind.zmqpubrawblock
--litecoind.zmqpubrawtx
```

```
Usage:
  lnd [OPTIONS]

Application Options:
  -V, --version                                               Display version information and exit
      --lnddir=                                               The base directory that contains lnd's data, logs, configuration file, etc. (default: /root/.lnd)
      --configfile=                                           Path to configuration file (default: /root/.lnd/lnd.conf)
  -b, --datadir=                                              The directory to store lnd's data within (default: /root/.lnd/data)
      --tlscertpath=                                          Path to write the TLS certificate for lnd's RPC and REST services (default: /root/.lnd/tls.cert)
      --tlskeypath=                                           Path to write the TLS private key for lnd's RPC and REST services (default: /root/.lnd/tls.key)
      --tlsextraip=                                           Adds an extra ip to the generated certificate
      --tlsextradomain=                                       Adds an extra domain to the generated certificate
      --no-macaroons                                          Disable macaroon authentication
      --adminmacaroonpath=                                    Path to write the admin macaroon for lnd's RPC and REST services if it doesn't exist
      --readonlymacaroonpath=                                 Path to write the read-only macaroon for lnd's RPC and REST services if it doesn't exist
      --invoicemacaroonpath=                                  Path to the invoice-only macaroon for lnd's RPC and REST services if it doesn't exist
      --logdir=                                               Directory to log output. (default: /root/.lnd/logs)
      --maxlogfiles=                                          Maximum logfiles to keep (0 for no rotation) (default: 3)
      --maxlogfilesize=                                       Maximum logfile size in MB (default: 10)
      --rpclisten=                                            Add an interface/port/socket to listen for RPC connections
      --restlisten=                                           Add an interface/port/socket to listen for REST connections
      --listen=                                               Add an interface/port to listen for peer connections
      --externalip=                                           Add an ip:port to the list of local addresses we claim to listen on to peers. If a port is not specified,
                                                              the default (9735) will be used regardless of other parameters
      --nolisten                                              Disable listening for incoming peer connections
      --nat                                                   Toggle NAT traversal support (using either UPnP or NAT-PMP) to automatically advertise your external IP
                                                              address to the network -- NOTE this does not support devices behind multiple NATs
      --minbackoff=                                           Shortest backoff when reconnecting to persistent peers. Valid time units are {s, m, h}. (default: 1s)
      --maxbackoff=                                           Longest backoff when reconnecting to persistent peers. Valid time units are {s, m, h}. (default: 1h0m0s)
  -d, --debuglevel=                                           Logging level for all subsystems {trace, debug, info, warn, error, critical} -- You may also specify
                                                              <subsystem>=<level>,<subsystem2>=<level>,... to set the log level for individual subsystems -- Use show to
                                                              list available subsystems (default: info)
      --cpuprofile=                                           Write CPU profile to the specified file
      --profile=                                              Enable HTTP profiling on given port -- NOTE port must be between 1024 and 65535
      --debughtlc                                             Activate the debug htlc mode. With the debug HTLC mode, all payments sent use a pre-determined R-Hash.
                                                              Additionally, all HTLCs sent to a node with the debug HTLC R-Hash are immediately settled in the next
                                                              available state transition.
      --unsafe-disconnect                                     Allows the rpcserver to intentionally disconnect from peers with open channels. USED FOR TESTING ONLY.
      --unsafe-replay                                         Causes a link to replay the adds on its commitment txn after starting up, this enables testing of the
                                                              sphinx replay logic.
      --maxpendingchannels=                                   The maximum number of incoming pending channels permitted per peer. (default: 1)
      --backupfilepath=                                       The target location of the channel backup file
      --nobootstrap                                           If true, then automatic network bootstrapping will not be attempted.
      --noseedbackup                                          If true, NO SEED WILL BE EXPOSED AND THE WALLET WILL BE ENCRYPTED USING THE DEFAULT PASSPHRASE -- EVER.
                                                              THIS FLAG IS ONLY FOR TESTING AND IS BEING DEPRECATED.
      --trickledelay=                                         Time in milliseconds between each release of announcements to the network (default: 90000)
      --chan-enable-timeout=                                  The duration that a peer connection must be stable before attempting to send a channel update to reenable
                                                              or cancel a pending disables of the peer's channels on the network (default: 19m). (default: 19m0s)
      --chan-disable-timeout=                                 The duration that must elapse after first detecting that an already active channel is actually inactive and
                                                              sending channel update disabling it to the network. The pending disable can be canceled if the peer
                                                              reconnects and becomes stable for chan-enable-timeout before the disable update is sent. (default: 20m)
                                                              (default: 20m0s)
      --chan-status-sample-interval=                          The polling interval between attempts to detect if an active channel has become inactive due to its peer
                                                              going offline. (default: 1m) (default: 1m0s)
      --alias=                                                The node alias. Used as a moniker by peers and intelligence services
      --color=                                                The color of the node in hex format (i.e. '#3399FF'). Used to customize node appearance in intelligence
                                                              services (default: #3399FF)
      --minchansize=                                          The smallest channel size (in satoshis) that we should accept. Incoming channels smaller than this will be
                                                              rejected (default: 20000)
      --numgraphsyncpeers=                                    The number of peers that we should receive new graph updates from. This option can be tuned to save
                                                              bandwidth for light clients or routing nodes. (default: 3)
      --historicalsyncinterval=                               The polling interval between historical graph sync attempts. Each historical graph sync attempt ensures we
                                                              reconcile with the remote peer's graph from the genesis block. (default: 1h0m0s)
      --rejectpush                                            If true, lnd will not accept channel opening requests with non-zero push amounts. This should prevent
                                                              accidental pushes to merchant nodes.
      --stagger-initial-reconnect                             If true, will apply a randomized staggering between 0s and 30s when reconnecting to persistent peers on
                                                              startup. The first 10 reconnections will be attempted instantly, regardless of the flag's value

Bitcoin:
      --bitcoin.active                                        If the chain should be active or not.
      --bitcoin.chaindir=                                     The directory to store the chain's data within.
      --bitcoin.node=[btcd|bitcoind|neutrino|ltcd|litecoind]  The blockchain interface to use. (default: btcd)
      --bitcoin.mainnet                                       Use the main network
      --bitcoin.testnet                                       Use the test network
      --bitcoin.simnet                                        Use the simulation test network
      --bitcoin.regtest                                       Use the regression test network
      --bitcoin.defaultchanconfs=                             The default number of confirmations a channel must have before it's considered open. If this is not set, we
                                                              will scale the value according to the channel size.
      --bitcoin.defaultremotedelay=                           The default number of blocks we will require our channel counterparty to wait before accessing its funds in
                                                              case of unilateral close. If this is not set, we will scale the value according to the channel size.
      --bitcoin.minhtlc=                                      The smallest HTLC we are willing to forward on our channels, in millisatoshi (default: 1000)
      --bitcoin.basefee=                                      The base fee in millisatoshi we will charge for forwarding payments on our channels (default: 1000)
      --bitcoin.feerate=                                      The fee rate used when forwarding payments on our channels. The total fee charged is basefee + (amount *
                                                              feerate / 1000000), where amount is the forwarded amount. (default: 1)
      --bitcoin.timelockdelta=                                The CLTV delta we will subtract from a forwarded HTLC's timelock value (default: 40)

btcd:
      --btcd.dir=                                             The base directory that contains the node's data, logs, configuration file, etc. (default: /root/.btcd)
      --btcd.rpchost=                                         The daemon's rpc listening address. If a port is omitted, then the default port for the selected chain
                                                              parameters will be used. (default: localhost)
      --btcd.rpcuser=                                         Username for RPC connections
      --btcd.rpcpass=                                         Password for RPC connections
      --btcd.rpccert=                                         File containing the daemon's certificate file (default: /root/.btcd/rpc.cert)
      --btcd.rawrpccert=                                      The raw bytes of the daemon's PEM-encoded certificate chain which will be used to authenticate the RPC
                                                              connection.

bitcoind:
      --bitcoind.dir=                                         The base directory that contains the node's data, logs, configuration file, etc. (default: /root/.bitcoin)
      --bitcoind.rpchost=                                     The daemon's rpc listening address. If a port is omitted, then the default port for the selected chain
                                                              parameters will be used. (default: localhost)
      --bitcoind.rpcuser=                                     Username for RPC connections
      --bitcoind.rpcpass=                                     Password for RPC connections
      --bitcoind.zmqpubrawblock=                              The address listening for ZMQ connections to deliver raw block notifications
      --bitcoind.zmqpubrawtx=                                 The address listening for ZMQ connections to deliver raw transaction notifications

neutrino:
  -a, --neutrino.addpeer=                                     Add a peer to connect with at startup
      --neutrino.connect=                                     Connect only to the specified peers at startup
      --neutrino.maxpeers=                                    Max number of inbound and outbound peers
      --neutrino.banduration=                                 How long to ban misbehaving peers.  Valid time units are {s, m, h}.  Minimum 1 second
      --neutrino.banthreshold=                                Maximum allowed ban score before disconnecting and banning misbehaving peers.
      --neutrino.feeurl=                                      Optional URL for fee estimation. If a URL is not specified, static fees will be used for estimation.

Litecoin:
      --litecoin.active                                       If the chain should be active or not.
      --litecoin.chaindir=                                    The directory to store the chain's data within.
      --litecoin.node=[btcd|bitcoind|neutrino|ltcd|litecoind] The blockchain interface to use. (default: ltcd)
      --litecoin.mainnet                                      Use the main network
      --litecoin.testnet                                      Use the test network
      --litecoin.simnet                                       Use the simulation test network
      --litecoin.regtest                                      Use the regression test network
      --litecoin.defaultchanconfs=                            The default number of confirmations a channel must have before it's considered open. If this is not set, we
                                                              will scale the value according to the channel size.
      --litecoin.defaultremotedelay=                          The default number of blocks we will require our channel counterparty to wait before accessing its funds in
                                                              case of unilateral close. If this is not set, we will scale the value according to the channel size.
      --litecoin.minhtlc=                                     The smallest HTLC we are willing to forward on our channels, in millisatoshi (default: 1000)
      --litecoin.basefee=                                     The base fee in millisatoshi we will charge for forwarding payments on our channels (default: 1000)
      --litecoin.feerate=                                     The fee rate used when forwarding payments on our channels. The total fee charged is basefee + (amount *
                                                              feerate / 1000000), where amount is the forwarded amount. (default: 1)
      --litecoin.timelockdelta=                               The CLTV delta we will subtract from a forwarded HTLC's timelock value (default: 576)

ltcd:
      --ltcd.dir=                                             The base directory that contains the node's data, logs, configuration file, etc. (default: /root/.ltcd)
      --ltcd.rpchost=                                         The daemon's rpc listening address. If a port is omitted, then the default port for the selected chain
                                                              parameters will be used. (default: localhost)
      --ltcd.rpcuser=                                         Username for RPC connections
      --ltcd.rpcpass=                                         Password for RPC connections
      --ltcd.rpccert=                                         File containing the daemon's certificate file (default: /root/.ltcd/rpc.cert)
      --ltcd.rawrpccert=                                      The raw bytes of the daemon's PEM-encoded certificate chain which will be used to authenticate the RPC
                                                              connection.

litecoind:
      --litecoind.dir=                                        The base directory that contains the node's data, logs, configuration file, etc. (default: /root/.litecoin)
      --litecoind.rpchost=                                    The daemon's rpc listening address. If a port is omitted, then the default port for the selected chain
                                                              parameters will be used. (default: localhost)
      --litecoind.rpcuser=                                    Username for RPC connections
      --litecoind.rpcpass=                                    Password for RPC connections
      --litecoind.zmqpubrawblock=                             The address listening for ZMQ connections to deliver raw block notifications
      --litecoind.zmqpubrawtx=                                The address listening for ZMQ connections to deliver raw transaction notifications

Autopilot:
      --autopilot.active                                      If the autopilot agent should be active or not.
      --autopilot.heuristic=                                  Heuristic to activate, and the weight to give it during scoring. (default: {preferential:1})
      --autopilot.maxchannels=                                The maximum number of channels that should be created (default: 5)
      --autopilot.allocation=                                 The percentage of total funds that should be committed to automatic channel establishment (default: 0.6)
      --autopilot.minchansize=                                The smallest channel that the autopilot agent should create (default: 20000)
      --autopilot.maxchansize=                                The largest channel that the autopilot agent should create (default: 16777215)
      --autopilot.private                                     Whether the channels created by the autopilot agent should be private or not. Private channels won't be
                                                              announced to the network.
      --autopilot.minconfs=                                   The minimum number of confirmations each of your inputs in funding transactions created by the autopilot
                                                              agent must have.

Tor:
      --tor.active                                            Allow outbound and inbound connections to be routed through Tor
      --tor.socks=                                            The host:port that Tor's exposed SOCKS5 proxy is listening on (default: localhost:9050)
      --tor.dns=                                              The DNS server as host:port that Tor will use for SRV queries - NOTE must have TCP resolution enabled
                                                              (default: soa.nodes.lightning.directory:53)
      --tor.streamisolation                                   Enable Tor stream isolation by randomizing user credentials for each connection.
      --tor.control=                                          The host:port that Tor is listening on for Tor control connections (default: localhost:9051)
      --tor.v2                                                Automatically set up a v2 onion service to listen for inbound connections
      --tor.v3                                                Automatically set up a v3 onion service to listen for inbound connections
      --tor.privatekeypath=                                   The path to the private key of the onion service being created

signrpc:
      --signrpc.signermacaroonpath=                           Path to the signer macaroon

walletrpc:
      --walletrpc.walletkitmacaroonpath=                      Path to the wallet kit macaroon

chainrpc:
      --chainrpc.notifiermacaroonpath=                        Path to the chain notifier macaroon

workers:
      --workers.read=                                         Maximum number of concurrent read pool workers. This number should be proportional to the number of peers.
                                                              (default: 100)
      --workers.write=                                        Maximum number of concurrent write pool workers. This number should be proportional to the number of CPUs
                                                              on the host.  (default: 8)
      --workers.sig=                                          Maximum number of concurrent sig pool workers. This number should be proportional to the number of CPUs on
                                                              the host. (default: 8)

caches:
      --caches.reject-cache-size=                             Maximum number of entries contained in the reject cache, which is used to speed up filtering of new channel
                                                              announcements and channel updates from peers. Each entry requires 25 bytes. (default: 50000)
      --caches.channel-cache-size=                            Maximum number of entries contained in the channel cache, which is used to reduce memory allocations from
                                                              gossip queries from peers. Each entry requires roughly 2Kb. (default: 20000)

Help Options:
  -h, --help                                                  Show this help message
```
