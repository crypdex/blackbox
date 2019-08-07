
blockchaininfo="$(dcrctl getblockchaininfo 2>/dev/null)"

if [[ ${#blockchaininfo} -gt 0 ]]; then
  btc_title="${btc_title} (${chain}net)"

  # get sync status
  block_chain="$(dcrctl getblockcount 2>/dev/null)"
  block_verified="$(echo "${blockchaininfo}" | jq -r '.blocks')"
  block_diff=$(expr ${block_chain} - ${block_verified})

  progress="$(echo "${blockchaininfo}" | jq -r '.verificationprogress')"
  sync_percentage=$(echo ${progress} | awk '{printf( "%.2f%%", 100 * $1)}')

  progress="$(echo "${blockchaininfo}" | jq -r '.bestblockhash')"

  if [ ${block_diff} -eq 0 ]; then    # fully synced
    sync="OK"
    sync_color="${color_green}"
    sync_behind=" "
  elif [ ${block_diff} -eq 1 ]; then   # fully synced
    sync="OK"
    sync_color="${color_green}"
    sync_behind="-1 block"
  elif [ ${block_diff} -le 10 ]; then   # <= 2 blocks behind
    sync=""
    sync_color="${color_red}"
    sync_behind="-${block_diff} blocks"
  else
    sync=""
    sync_color="${color_red}"
    sync_behind="${sync_percentage}"
  fi
fi