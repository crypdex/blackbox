#!/bin/bash



## get basic info
source /home/admin/raspiblitz.info 2>/dev/null
source /mnt/hdd/raspiblitz.conf 2>/dev/null

#codeVersion=$(blackbox version)
codeVersion=0.2.10
if [[ ${#codeVersion} -eq 0 ]]; then codeVersion="0"; fi

# check hostname
if [ ${#hostname} -eq 0 ]; then hostname="raspiblitz"; fi

# get uptime & load
load=$(w | head -n 1 | cut -d 'v' -f2 | cut -d ':' -f2)

# get CPU temp - no measurement in a VM
cpu=0
if [[ -d "/sys/class/thermal/thermal_zone0/" ]]; then
  cpu=$(cat /sys/class/thermal/thermal_zone0/temp)
fi
tempC=$(mawk '{print $1/1000}' <<< $cpu | xargs printf "%0.0f")
tempF=$(( $tempC * 9/5 + 32 ))

# get memory
ram_avail=$(free -m | grep Mem | awk '{ print $7 }')
ram=$(printf "%sM / %sM" "${ram_avail}" "$(free -m | grep Mem | awk '{ print $2 }')")

if [ ${ram_avail} -lt 50 ]; then
  color_ram="${color_red}\e[7m"
else
  color_ram=${color_green}
fi

# get free HDD ratio
hdd_free_ratio=$(printf "%d" "$(df -h / | mawk 'NR==2 { print $4/$2*100 }')" 2>/dev/null)
hdd=$(printf "%s (%s)" "$(df -h / | awk 'NR==2 { print $4 }')" "${hdd_free_ratio}%%")

if [ ${hdd_free_ratio} -lt 10 ]; then
  color_hdd="${color_red}\e[7m"
else
  color_hdd=${color_green}
fi

# get network traffic
# ifconfig does not show eth0 on Armbian or in a VM - get first traffic info
isArmbian=$(cat /etc/os-release 2>/dev/null | grep -c 'Debian')
if [ ${isArmbian} -gt 0 ] || [ ! -d "/sys/class/thermal/thermal_zone0/" ]; then
  network_rx=$(ifconfig | grep -m1 'RX packets' | awk '{ print $6$7 }' | sed 's/[()]//g')
  network_tx=$(ifconfig | grep -m1 'TX packets' | awk '{ print $6$7 }' | sed 's/[()]//g')
else
  network_rx=$(ifconfig eth0 | grep 'RX packets' | awk '{ print $6$7 }' | sed 's/[()]//g')
  network_tx=$(ifconfig eth0 | grep 'TX packets' | awk '{ print $6$7 }' | sed 's/[()]//g')
fi


# Get the location of this script
__dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


. ${__dir}/cpu_temp.sh

########
# UPTIME
#######
uptime=$(uptime -p 2>&1)

# - Re-obtain network details if missing and LAN IP chosen
. ${__dir}/network.sh




blockchaininfo=$(dcrctl getblockchaininfo 2>/dev/null)

if [[ ${#blockchaininfo} -gt 0 ]]; then
  btc_title="${btc_title} (${chain}net)"

  # get sync status
  block_chain=$(dcrctl getblockcount 2>/dev/null)
  block_verified=$(echo "${blockchaininfo}" | jq -r '.blocks')
  # block_diff=$(expr ${block_chain} - ${block_verified})

  progress="$(echo "${blockchaininfo}" | jq -r '.verificationprogress')"
  sync_percentage=$(echo ${progress} | awk '{printf( "%.2f%%", 100 * $1)}')

  bestblockhash="$(echo "${blockchaininfo}" | jq -r '.bestblockhash')"

  if [ ${progress} -eq 0 ]; then    # fully synced
    sync="OK"
    sync_color="${color_green}"
    sync_behind=" "
  elif [ ${progress} -eq 1 ]; then   # fully synced
    sync="OK"
    sync_color="${color_green}"
    sync_behind="-1 block"
  elif [ ${progress} -le 10 ]; then   # <= 2 blocks behind
    sync=""
    sync_color="${color_red}"
    sync_behind="-${block_diff} blocks"
  else
    sync=""
    sync_color="${color_red}"
    sync_behind="${sync_percentage}"
  fi
fi


printf "

    ${color_amber}BlackboxOS v${codeVersion}
    ${color_gray}Developed by CRYPDEX [https://crypdex.io]
    ${color_yellow}─────────────────────────────────────────────────────
    ${color_gray}$(date)
    ${color_gray}Load avg: ${load}, CPU temp: ${tempC}°C/${tempF}°F
    ${color_gray}${uptime}
    ${color_gray}Free Mem ${color_ram}${ram} ${color_gray} Free HDD ${color_hdd}${hdd}${color_gray}
    ${color_gray}${color_green}${ACTIVE_IP}${color_gray} ${color_amber}▼ ${network_rx} RX ${color_purple}▲ ${network_tx} TX
    ${color_clear}


    ${color_amber}Decred
    ${color_gray}Chain: ${color_purple}testnet3
    ${color_gray}Best block: ${block_verified}
    ${color_gray}Sync progress: %s
    Latest hash: ${bestblockhash}
    ${color_clear}
" "${sync_percentage}"