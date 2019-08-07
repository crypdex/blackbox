#!/usr/bin/env bash

# Get the location of this script
__dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. ${__dir}/colors.sh
. ${__dir}/network.sh


version=$(${blackboxcmd} version -q)
# get uptime & load
load=$(w | head -n 1 | cut -d 'v' -f2 | cut -d ':' -f2 | awk '{$1=$1};1')

platform=$(uname -s)
if [[ platform -eq "Darwin" ]]; then
  up=$(uptime -p)
else
  up=$(uptime -p)
fi


cpu_temp_current=$(print_full_info=1 ${__dir}/cpu_temp.sh)
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

if [[ ${ram_avail} -lt 50 ]]; then
  color_ram="${color_red}\e[7m"
else
  color_ram=${color_green}
fi

# get free HDD ratio
hdd_free_ratio=$(printf "%d" "$(df -h / | mawk 'NR==2 { print $4/$2*100 }')" 2>/dev/null)
hdd=$(printf "%s (%s)" "$(df -h / | awk 'NR==2 { print $4 }')" "${hdd_free_ratio}%%")

if [[ ${hdd_free_ratio} -lt 10 ]]; then
  color_hdd="${color_red}\e[7m"
else
  color_hdd=${color_green}
fi

# get network traffic
# isArmbian=$(cat /etc/os-release 2>/dev/null | grep -c 'Debian')
#if [[ ${isArmbian} -gt 0 ]] || [[ ! -d "/sys/class/thermal/thermal_zone0/" ]]; then
#  network_rx=$(ifconfig | grep -m1 'RX packets' | awk '{ print $6$7 }' | sed 's/[()]//g')
#  network_tx=$(ifconfig | grep -m1 'TX packets' | awk '{ print $6$7 }' | sed 's/[()]//g')
#else
  network_rx=$(ifconfig eth0 | grep 'RX packets' | awk '{ print $6$7 }' | sed 's/[()]//g')
  network_tx=$(ifconfig eth0 | grep 'TX packets' | awk '{ print $6$7 }' | sed 's/[()]//g')
#fi


printf "
  ${color_amber}BlackboxOS v${version}
  ${color_gray}crypdex.io
  ${color_yellow}─────────────────────────────────────────────────────
  ${color_boldcyan}${ACTIVE_IP}
  ${color_clear}$(date)
  Load avg: ${load}
  CPU temp: ${cpu_temp_current}
  ${up}
  Free Mem ${color_ram}${ram} ${color_gray} Free HDD ${color_hdd}${hdd}${color_clear}
  ${color_amber}▼ ${network_rx} RX ${color_purple}▲ ${network_tx} TX
  ${color_clear}
"