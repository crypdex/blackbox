#!/usr/bin/env bash

# Get the location of this script
__dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. ${__dir}/colors.sh
. ${__dir}/network.sh
. ${__dir}/cpu_temp.sh

cpu_temp_current=$(G_OBTAIN_CPU_TEMP)

version=$(${blackboxcmd} version -q)
# get uptime & load
load=$(w | head -n 1 | cut -d 'v' -f2 | cut -d ':' -f2 | awk '{$1=$1};1')

platform=$(uname -s)
if [[ platform -eq "Darwin" ]]; then
uptime=$(uptime)
  else
uptime=$(uptime -p)
fi




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
  color_ram="${RED}\e[7m"
else
  color_ram=${GREEN}
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
# ifconfig does not show eth0 on Armbian or in a VM - get first traffic info
isArmbian=$(cat /etc/os-release 2>/dev/null | grep -c 'Debian')
if [[ ${isArmbian} -gt 0 ]] || [[ ! -d "/sys/class/thermal/thermal_zone0/" ]]; then
  network_rx=$(ifconfig | grep -m1 'RX packets' | awk '{ print $6$7 }' | sed 's/[()]//g')
  network_tx=$(ifconfig | grep -m1 'TX packets' | awk '{ print $6$7 }' | sed 's/[()]//g')
else
  network_rx=$(ifconfig eth0 | grep 'RX packets' | awk '{ print $6$7 }' | sed 's/[()]//g')
  network_tx=$(ifconfig eth0 | grep 'TX packets' | awk '{ print $6$7 }' | sed 's/[()]//g')
fi


printf "
  ${color_amber}BlackboxOS v${version}
  ${color_gray}Developed by CRYPDEX [https://crypdex.io]
  ${color_yellow}─────────────────────────────────────────────────────
  $(date)
  ${color_gray}Load avg: ${load}, CPU temp: ${cpu_temp_current}
  ${color_gray}${uptime}
  ${color_gray}Free Mem ${color_ram}${ram} ${color_gray} Free HDD ${color_hdd}${hdd}${CLEAR}
  ${color_gray}${color_green}${ACTIVE_IP}${color_gray} ${color_amber}▼ ${network_rx} RX ${color_purple}▲ ${network_tx} TX
  ${color_clear}
"