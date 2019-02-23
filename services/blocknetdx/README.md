# Blocknet

Blocknet is a Bitcoin fork. It was forked from PIVX, which was forked from DASH, which was forked from Bitcoin. Thus a great deal of how it operates is based on Bitcoin.

All pre-compiled releases can be found at https://github.com/BlocknetDX/BlockDX/releases

```
wget https://github.com/BlocknetDX/BlockDX/releases/download/3.10.5/blocknetdx-3.10.5-aarch64-linux-gnu.tar.gz
tar -xvf blocknetdx-3.10.5-aarch64-linux-gnu.tar.gz
```

Example .conf file can be found [here](https://github.com/BlocknetDX/BlockDX/blob/master/contrib/debian/examples/blocknetdx.conf).

```
touch /home/crypdex/.blocknetdx/blocknetdx.conf
chmod 600 /home/crypdex/.blocknetdx/blocknetdx.conf
```

## Help
```

￼
== Blockchain ==
getbestblockhash
getblock "hash" ( verbose )
getblockchaininfo
getblockcount
getblockhash index
getblockheader "hash" ( verbose )
getchaintips
getdifficulty
getmempoolinfo
getrawmempool ( verbose )
gettxout "txid" n ( includemempool )
gettxoutsetinfo
verifychain ( checklevel numblocks )

== Blocknetdx ==
mnbudget "command"... ( "passphrase" )
mnbudgetvoteraw <servicenode-tx-hash> <servicenode-tx-index> <proposal-hash> <yes|no> <time> <vote-sig>
mnfinalbudget "command"... ( "passphrase" )
mnsync [status|reset]
obfuscation <blocknetdxaddress> <amount>
servicenode "command"... ( "passphrase" )
servicenodelist ( "filter" )
spork <name> [<value>]

== Control ==
getinfo
help ( "command" )
stop

== Generating ==
getgenerate
gethashespersec
setgenerate generate ( genproclimit )

== Mining ==
getblocktemplate ( "jsonrequestobject" )
getmininginfo
getnetworkhashps ( blocks height )
prioritisetransaction <txid> <priority delta> <fee delta>
reservebalance [<reserve> [amount]]
submitblock "hexdata" ( "jsonparametersobject" )

== Network ==
addnode "node" "add|remove|onetry"
getaddednodeinfo dns ( "node" )
getconnectioncount
getnettotals
getnetworkinfo
getpeerinfo
ping

== Rawtransactions ==
createrawtransaction [{"txid":"id","vout":n},...] {"data":"<Message>","address":amount,...}
decoderawtransaction "hexstring"
decodescript "hex"
fundrawtransaction "hexstring" ( options )
getrawtransaction "txid" ( verbose )
sendrawtransaction "hexstring" ( allowhighfees )
signrawtransaction "hexstring" ( [{"txid":"id","vout":n,"scriptPubKey":"hex","redeemScript":"hex"},...] ["privatekey1",...] sighashtype )

== Util ==
createmultisig nrequired ["key",...]
estimatefee nblocks
estimatepriority nblocks
validateaddress "blocknetdxaddress"
verifymessage "blocknetdxaddress" "signature" "message"

== Wallet ==
addmultisigaddress nrequired ["key",...] ( "account" )
autocombinerewards <true/false> threshold
backupwallet "destination"
bip38decrypt "blocknetdxaddress"
bip38encrypt "blocknetdxaddress"
dumpprivkey "blocknetdxaddress"
dumpwallet "filename"
encryptwallet "passphrase"
getaccount "blocknetdxaddress"
getaccountaddress "account"
getaddressesbyaccount "account"
getbalance ( "account" minconf includeWatchonly )
getnewaddress ( "account" )
getrawchangeaddress
getreceivedbyaccount "account" ( minconf )
getreceivedbyaddress "blocknetdxaddress" ( minconf )
getstakesplitthreshold
getstakingstatus
gettransaction "txid" ( includeWatchonly )
getunconfirmedbalance
getwalletinfo
importaddress "address" ( "label" rescan )
importprivkey "blocknetdxprivkey" ( "label" rescan )
importwallet "filename"
keypoolrefill ( newsize )
listaccounts ( minconf includeWatchonly)
listaddressgroupings
listlockunspent
listreceivedbyaccount ( minconf includeempty includeWatchonly)
listreceivedbyaddress ( minconf includeempty includeWatchonly)
listsinceblock ( "blockhash" target-confirmations includeWatchonly)
listtransactions ( "account" count from includeWatchonly)
listunspent ( minconf maxconf  ["address",...] )
lockunspent unlock [{"txid":"txid","vout":n},...]
move "fromaccount" "toaccount" amount ( minconf "comment" )
multisend <command>
sendfrom "fromaccount" "toblocknetdxaddress" amount ( minconf "comment" "comment-to" )
sendmany "fromaccount" {"address":amount,...} ( minconf "comment" )
sendtoaddress "blocknetdxaddress" amount ( "comment" "comment-to" )
sendtoaddressix "blocknetdxaddress" amount ( "comment" "comment-to" )
setaccount "blocknetdxaddress" "account"
setstakesplitthreshold <1 - 999,999>
settxfee amount
signmessage "blocknetdxaddress" "message"

== Xbridge ==
dxCancelOrder (id)
dxGetLocalTokens
dxGetLockedUtxos (id)
dxGetMyOrders
dxGetNetworkTokens
dxGetOrder (id)
dxGetOrderBook (detail level, 1-4) (maker) (taker) (max orders, default=50)[optional]
dxGetOrderFills (maker) (taker) (combined, default=true)[optional]
dxGetOrderHistory (maker) (taker) (start time) (end time) (granularity) (order_ids, default=false)[optional]
dxGetOrders
dxGetTokenBalances
dxMakeOrder (maker) (maker size) (maker address) (taker) (taker size) (taker address) (type) (dryrun)[optional]
dxTakeOrder (id) (address from) (address to) [optional](dryrun)

```
