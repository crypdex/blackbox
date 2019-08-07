#!/bin/bash
{
  #////////////////////////////////////
  # DietPi Function:
  # - obtain_network_details
  #
  #////////////////////////////////////
  # Created by Daniel Knight / daniel.knight@dietpi.com / dietpi.com
  #
  #////////////////////////////////////
  #
  # Info:
  # - Location: /{DietPi,boot}/dietpi/func/obtain_network_details
  # - Attempts to find the 1st available index numbers for eth[0-9] and wlan[0-9] devices
  # - Obtains the active network adapter (eth, then wlan).
  # - Saves the above data to $FP_NETFILE for use system-wide
  #
  # line1: eth index
  # line2: wlan index
  # line3: Active adapter name (eg: eth0)
  # line4: Active IP address
  # line5: ETH_IP=<eth ip>
  # line6: WLAN_IP=<wlan ip>
  #////////////////////////////////////


  #/////////////////////////////////////////////////////////////////////////////////////
  # Global
  #/////////////////////////////////////////////////////////////////////////////////////

  FP_NETFILE="${HOME}/.network"

  ETH_INDEX=''
  WLAN_INDEX=''
  ACTIVE_DEVICE=''
  ACTIVE_IP=''
  ETH_IP=''
  WLAN_IP=''

  Scan(){

    # ETH
    local eth_dev eth_index eth_out eth_ip
    for i in /sys/class/net/eth*
    do

      # Check if any eth dev exists
      [[ -e $i ]] || break

      # Get dev name and index, assign not yet if lower index found
      eth_dev=${i#*net/}
      eth_index=${eth_dev#eth}
      [[ $ETH_INDEX ]] || ETH_INDEX=$eth_index

      # Get and check IP, assign not yet if lower index IP found
      eth_out=$(ip a s $eth_dev 2>/dev/null) || continue
      # - Detect IPv4 and, if no available, IPv6
      [[ $eth_out =~ [[:blank:]]inet6?[[:blank:]] ]] || continue
      eth_ip=${eth_out#* inet* }
      eth_ip=${eth_ip%%/*}
      [[ $eth_ip ]] || continue
      [[ $ETH_IP ]] || { ETH_IP=$eth_ip; ETH_INDEX=$eth_index; }

      # Check connection state
      [[ $eth_out =~ [[:blank:]]UP[[:blank:]] ]] || continue

      # Assign active dev info
      ETH_INDEX=$eth_index
      ETH_IP=$eth_ip
      ACTIVE_DEVICE=$eth_dev
      ACTIVE_IP=$ETH_IP
      break

    done

    # WLAN
    local wlan_dev wlan_index wlan_out wlan_ip
    for i in /sys/class/net/wlan*
    do

      # Check if any wlan dev exists
      [[ -e $i ]] || break

      # Get dev name and index, assign not yet if lower index found
      wlan_dev=${i#*net/}
      wlan_index=${wlan_dev#wlan}
      [[ $WLAN_INDEX ]] || WLAN_INDEX=$wlan_index

      # Get and check IP, assign not yet if lower index IP found
      wlan_out=$(ip a s $wlan_dev 2>/dev/null) || continue
      # - Detect IPv4 and, if no available, IPv6
      [[ $wlan_out =~ [[:blank:]]inet6?[[:blank:]] ]] || continue
      wlan_ip=${wlan_out#* inet* }
      wlan_ip=${wlan_ip%%/*}
      [[ $wlan_ip ]] || continue
      [[ $WLAN_IP ]] || { WLAN_IP=$wlan_ip; WLAN_INDEX=$wlan_index; }

      # Check connection state
      [[ $wlan_out =~ [[:blank:]]UP[[:blank:]] ]] || continue

      # Assign active dev info if none (eth) assigned yet
      WLAN_INDEX=$wlan_index
      WLAN_IP=$wlan_ip
      [[ $ACTIVE_DEVICE ]] || { ACTIVE_DEVICE=$wlan_dev; ACTIVE_IP=$WLAN_IP; }
      break

    done

  }

  #/////////////////////////////////////////////////////////////////////////////////////
  # Main Loop
  #/////////////////////////////////////////////////////////////////////////////////////
  Scan

}