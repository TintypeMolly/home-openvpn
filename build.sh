#!/bin/bash

TAG_NAME="home-ovpn:latest"
OVPN_SERVER_NAME="home-ovpn-server"
CA_PASSPHRASE=""

help()
{
  echo "Build docker image of OpenVPN server for small home server."
  echo
  echo "Usage: ./build.sh [-h] [-t TAG_NAME] [-s OVPN_SERVER_NAME] [-p CA_PASSPHRASE]"
  echo "Options:"
  echo "-h     Print this help message."
  echo "-t     Modify resulting docker image tag name. (default: home-ovpn:latest)"
  echo "-s     Modify OpenVPN server name. (default: home-ovpn-server)"
  echo "-p     Set CA Certificate passphrase."
  echo
}

get_passphrase() {
  read -s -p "Enter CA Certificate passphrase: " CA_PASSPHRASE
  echo
}

while getopts "ht:s:p:" o
do
  case "${o}" in
    h)
      help
      exit 0
      ;;
    t)
      TAG_NAME=${OPTARG}
      ;;
    s)
      OVPN_SERVER_NAME=${OPTARG}
      ;;
    p)
      CA_PASSPHRASE=${OPTARG}
      ;;
    *)
      help
      exit 1
      ;;
  esac
done

if [ -z "$CA_PASSPHRASE" ]; then
  get_passphrase
  if [ -z "$CA_PASSPHRASE" ]; then
    echo "Error: Empty CA_PASSPHRASE"
    exit 1
  fi
fi

docker build \
  -t ${TAG_NAME} \
  --build-arg="OVPN_SERVERNAME=${OVPN_SERVER_NAME}" \
  --build-arg="CA_PASSPHRASE=${CA_PASSPHRASE}" \
  .