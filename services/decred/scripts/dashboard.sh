#!/usr/bin/env bash

printf "
  ${color_yellow}Decred
  ─────────────────────────────────────────────────────${color_clear}"

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
syncheight=$(echo "${blockchaininfo}" | jq -r '.syncheight')


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
  ${color_white}[chain]
  ${color_boldgreen}${chain}${color_boldwhite} ${progress}${color_clear} ${blocks}/${syncheight}
  ${color_gray}${bestblockhash}
  ${color_gray}${peercount} peers

  ${color_white}[tickets]
  ${color_gray}live: ${live}, voted: ${voted}, immature: ${immature}
  ${color_gray}missed: ${missed}, expired: ${expired}, revoked: ${revoked}

  ${color_white}[account]
  ${color_gray}${total} DCR
  ${color_gray}${lockedbytickets} locked, ${spendable} spendable, ${unconfirmed} unconfirmed
"