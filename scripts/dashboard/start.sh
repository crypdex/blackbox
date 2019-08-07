#!/usr/bin/env bash

# Get the location of this script
__dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


blackboxcmd="blackbox"

. ${__dir}/colors.sh


services=$(${blackboxcmd} info -q | jq -r 'to_entries | map(.key) | join(" ")')

# Get the dirs as an array
dirs=$(${blackboxcmd} info -q | jq -r 'to_entries | map(.value.dir) | join(" ")')
dirsarray=(${dirs})


. ${__dir}/os.sh

i=0
for service in ${services}; do
  file="${dirsarray[i]}/scripts/dashboard.sh"
  if [[ -f ${file} ]]; then
    . ${file}
  fi


 ((i = i + 1))
done