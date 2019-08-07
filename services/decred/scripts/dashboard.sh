#!/usr/bin/env bash

printf "${GREEN}Decred${CLEAR}
─────────────────────────────────────────────────────"

# Get the location of this script
__dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

blockchaininfo=$(${blackboxcmd} exec dcrctl getblockchaininfo 2>/dev/null)

if [[ $? -ne 0 ]]; then
  echo "Not running"
  return
fi

blocks=$(echo "${blockchaininfo}" | jq -r '.blocks')
verificationprogress=$(echo "${blockchaininfo}" | jq -r '.verificationprogress')
progress="$(echo ${verificationprogress} | awk '{printf( "%.2f", 100 * $1)}')%%"
#blockchaininfo=$(${blackboxcmd} exec dcrctl getblockchaininfo 2>/dev/null)
bestblockhash=$(echo "${blockchaininfo}" | jq -r '.bestblockhash')
chain=$(echo "${blockchaininfo}" | jq -r '.chain')



stakeinfo=$(${blackboxcmd} exec dcrctl -- --wallet getstakeinfo 2>/dev/null)
voted=$(echo "${stakeinfo}" | jq -r '.voted')
immature=$(echo "${stakeinfo}" | jq -r '.immature // 0')
revoked=$(echo "${stakeinfo}" | jq -r '.revoked // 0')
expired=$(echo "${stakeinfo}" | jq -r '.expired // 0')
missed=$(echo "${stakeinfo}" | jq -r '.missed // 0')
live=$(echo "${stakeinfo}" | jq -r '.live // 0')

balances=$(${blackboxcmd} exec dcrctl -- --wallet getbalance 2>/dev/null)

total=$(echo "${balances}" | jq -r '.balances[0].total')
lockedbytickets=$(echo "${balances}" | jq -r '.balances[0].lockedbytickets')
spendable=$(echo "${balances}" | jq -r '.balances[0].spendable')
unconfirmed=$(echo "${balances}" | jq -r '.balances[0].unconfirmed')
balance=$(echo "${balances}" | jq -r '.balances[0]')

peerinfo=$(${blackboxcmd} exec dcrctl getpeerinfo 2>/dev/null)
peercount=$(echo "${peerinfo}" | jq '. | length')

printf "
  ${GREEN}${chain}${CLEAR} ${progress}
  ${blocks} ${bestblockhash}
  ${peercount} peers

  [tickets]
  live: ${live}, voted: ${voted}, immature: ${immature}
  missed: ${missed}, expired: ${expired}, revoked: ${revoked}

  [account]
  ${total} DCR
  ${lockedbytickets} locked, ${spendable} spendable, ${unconfirmed} unconfirmed
"