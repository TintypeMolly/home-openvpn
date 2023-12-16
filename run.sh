#!/bin/bash

TAG_NAME="home-ovpn:latest"
OVPN_SERVER_NAME="home-ovpn-server"

help()
{
  echo "Run OpenVPN docker image built by build.sh."
  echo
  echo "Usage: ./run.sh [-h] [-t TAG_NAME] [-s OVPN_SERVER_NAME]"
  echo "Options:"
  echo "-h     Print this help message."
  echo "-t     Modify resulting docker image tag name. (default: home-ovpn:latest)"
  echo "-s     Modify OpenVPN server name. (default: home-ovpn-server)"
  echo
}

while getopts "ht:s:" o
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
    *)
      help
      exit 1
      ;;
  esac
done

docker run \
  -d \
  --name ${OVPN_SERVER_NAME} \
  --network=host \
  --cap-add=NET_ADMIN \
  --device=/dev/net/tun \
  --restart=always \
  ${TAG_NAME}
