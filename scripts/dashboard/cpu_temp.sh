#!/usr/bin/env bash

G_HW_MODEL=${G_HW_MODEL:--1}
# G_CHECK_VALIDINT | Simple test to verify if a variable is a valid integer.
# $1=input
# $2=Optional Min value range
# $3=Optional Max value range
#	disable_error=1 to disable notify/whiptail invalid value when recieved
# 1=no | scripts killed automatically
# 0=yes
# Usage = if G_CHECK_VALIDINT input; then
G_CHECK_VALIDINT(){
  local return_value=1
  local input=$1
  local min=$2
  local max=$3
  [[ $disable_error == 1 ]] || local disable_error=0
  if [[ $input =~ ^-?[0-9]+$ ]]; then
    if [[ $min =~ ^-?[0-9]+$ ]]; then
      if (( $input >= $min )); then
        if [[ $max =~ ^-?[0-9]+$ ]]; then
          if (( $input <= $max )); then
            return_value=0
          elif (( ! $disable_error )); then
            G_WHIP_MSG "Input value \"$input\" is higher than allowed \"$max\". No changes applied."
          fi
        else
          return_value=0
        fi
      elif (( ! $disable_error )); then
        G_WHIP_MSG "Input value \"$input\" is lower than allowed \"$min\". No changes applied."
      fi
    else
      return_value=0
    fi
  elif (( ! $disable_error )); then
    G_WHIP_MSG "Invalid input value \"$input\". No changes applied."
  fi
  unset disable_error
  return $return_value
}

# Returns current CPU temp 'C
#	print_full_info=1 # optional input to print full colour text output and temp warnings.
G_OBTAIN_CPU_TEMP(){
  local cpu_temp_current='N/A' # We must always return a value, due to VM lacking this feature + benchmark online
  [[ $print_full_info == [01] ]] || local print_full_info=0

  # Read CPU temp from file
  # - Sparky/Asus: Requires special case as in others array this would break other SBC temp readouts with 2 zones
  if (( $G_HW_MODEL == 70 || $G_HW_MODEL == 52 )); then
    cpu_temp_current=$(</sys/class/thermal/thermal_zone1/temp)
  # - Others
  else
    # - Array to store possible locations for temp read.
    local afp_temperature=(
      '/sys/class/thermal/thermal_zone0/temp'
      '/sys/devices/platform/sunxi-i2c.0/i2c-0/0-0034/temp1_input'
      '/sys/class/hwmon/hwmon0/device/temp_label'
      '/sys/class/hwmon/hwmon0/temp2_input'
    )

    for i in ${afp_temperature[@]}
    do
      [[ -f $i ]] && { cpu_temp_current=$(<$i); break; }
    done
  fi

  # Format output
  # - Check for valid value
  if ! disable_error=1 G_CHECK_VALIDINT "$cpu_temp_current" 1; then
    cpu_temp_current='N/A'
  else
    # - 2/5 digit output?
    (( $cpu_temp_current >= 150 )) && cpu_temp_current=$(mawk '{print $1/1000}' <<< $cpu_temp_current | xargs printf "%0.0f")

    if (( $print_full_info )); then
      local cpu_temp_current_f=$(( $cpu_temp_current * 9/5 + 32 ))
      if (( $cpu_temp_current >= 70 )); then
        cpu_temp_current="\e[1;31mWARNING: $cpu_temp_current'C : $cpu_temp_current_f'F (Reducing the life of your device)\e[0m"
      elif (( $cpu_temp_current >= 60 )); then
        cpu_temp_current="\e[38;5;202m$cpu_temp_current'C : $cpu_temp_current_f'F\e[90m (Running hot, not recommended)\e[0m"
      elif (( $cpu_temp_current >= 50 )); then
        cpu_temp_current="\e[1;33m$cpu_temp_current'C : $cpu_temp_current_f'F\e[90m (Running warm, but safe)\e[0m"
      elif (( $cpu_temp_current >= 40 )); then
        cpu_temp_current="\e[1;32m$cpu_temp_current'C : $cpu_temp_current_f'F\e[90m (Optimal temperature)\e[0m"
      elif (( $cpu_temp_current >= 30 )); then
        cpu_temp_current="\e[1;36m$cpu_temp_current'C : $cpu_temp_current_f'F\e[90m (Cool runnings)\e[0m"
      else
        cpu_temp_current="\e[1;36m$cpu_temp_current'C : $cpu_temp_current_f'F\e[90m (Who put me in the freezer!)\e[0m"
      fi
    fi
  fi

  echo -e "$cpu_temp_current"

}

