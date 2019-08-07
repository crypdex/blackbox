#!/usr/bin/env bash
# Get the location of this script
__dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

while :
  do
  clear
  ${__dir}/info.sh
	sleep 1
done
