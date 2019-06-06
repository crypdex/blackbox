#!/usr/bin/env bash

# Get the location of this script
__dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "${__dir}/helpers.sh"
# Let's change the context to the services directory
cd "${__dir}/../services"



check-all() {
  check-service ${1}
  check-docker-dir ${1}
  check-build-script ${1}
}

check-service() {
  if [[ ! -d ${1} ]]; then
    echo -e "${YELLOW}service '${1}' does not exist ${NC}"
    return 1
  fi
}


check-docker-dir() {
  if [[ ! -d ${1}/docker ]]; then
    echo -e "${YELLOW}no docker dir for '${1}'${NC}"
    return 1
  fi
}

check-build-script() {
  if [[ ! -f ${1}/docker/buildvars.sh ]]; then
    echo -e "no buildvars.sh defined for '${1}'"
    return 1
  fi
}


if [[ $# -eq 1 ]] ; then
  check-all $1
  if [[ $? -eq 1 ]]; then
    exit 1
  fi

  echo -e "${GREEN}Building and releasing ${SERVICE} ...${NC}"

  cmd="SERVICE=${1} bash ${__dir}/docker-release.sh"
  eval ${cmd}

  exit 0
fi

for SERVICE in *; do
    if [[ -d ${SERVICE} ]]; then
      check-all ${SERVICE}
      if [[ $? -eq 1 ]]; then
        continue
      fi

      echo -e "${GREEN}Building and releasing ${SERVICE} ...${NC}"

      cmd="SERVICE=${SERVICE} bash ${__dir}/docker-release.sh"
      eval ${cmd}
    fi

    echo "${SERVICE}"
done