#!/usr/bin/env bash
# This script will run "make build" inside a Docker container
# Note: setting BUILD_OS to get build for specific platform
set -e
script_file="${BASH_SOURCE[0]##*/}"
script_path="$( cd "$( echo "${BASH_SOURCE[0]%/*}" )" && pwd )"

# main function
function main() {
  getOS

  PROJECT="shuati"
  GITHUB_USER="dockerian"
  SOURCE_PATH="src/github.com/${GITHUB_USER}/${PROJECT}"
  BUILD_OS=${BUILD_OS:-${OS}}

  if [[ "${BUILD_OS}" == "" ]]; then
    echo -e "\nFailed: Unset/unknown BUILD_OS in environment variables"
    exit 1
  fi

  cd -P "${script_path}"

  echo -e "\nBuilding docker container '${PROJECT}' ..."
  docker build -t ${PROJECT} .

  echo -e "\nBuilding '${PROJECT}' for '${BUILD_OS}' in docker container ..."
  docker run --rm \
    --hostname ${PROJECT} \
    --name ${PROJECT} \
    -e BUILD_OS=${BUILD_OS} \
    -e BUILD_MASTER_VERSION \
    -e BUILD_VERSION \
    -e BINARY \
    -e TEST_VERBOSE \
    -e TEST_DIR \
    -e TEST_MATCH \
    -e TEST_TAGS \
    -e GITHUB_USERNAME \
    -e GITHUB_PASSWORD \
    -v "${PWD}":/go/${SOURCE_PATH} \
    -w /go/${SOURCE_PATH} \
    ${PROJECT} bash -c "make build"
}

# getOS function sets OS environment variable in runtime
function getOS() {
  # Detect the platform (similar to $OSTYPE)
  UNAME="$(uname)"
  case "${UNAME}" in
    'Darwin')
      OS="darwin"
      ;;
    'FreeBSD')
      OS="bsd"
      alias ls='ls -G'
      ;;
    'Linux')
      OS="linux"
      alias ls='ls --color=auto'
      ;;
    'SunOS')
      OS="solaris"
      ;;
    'WindowsNT')
      OS="windows"
      ;;
    'AIX') ;;
    *) ;;
  esac

  if [[ "${OS}" != "" ]]; then return; fi

  case "${OSTYPE}" in
    bsd*)     OS="bsd" ;;
    darwin*)  OS="darwin" ;;
    linux*)   OS="linux" ;;
    solaris*) OS="soloris" ;;
    *)        OS="" ;;
  esac
}

[[ $0 != "${BASH_SOURCE}" ]] || main "$@"
