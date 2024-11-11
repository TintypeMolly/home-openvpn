#!/bin/bash

set -e

OVPN_SERVER_NAME="home-ovpn-server"

help()
{
  echo "Create client *.ovpn config file."
  echo
  echo "Usage: ./run.sh [-h] [-s OVPN_SERVER_NAME] -c OVPN_CLIENT_NAME -r OVPN_REMOTE_ADDRESS"
  echo "Options:"
  echo "-h     Print this help message."
  echo "-s     Modify OpenVPN server name. (default: home-ovpn-server)"
  echo "-c     Set OpenVPN client name."
  echo "-r     Set OpenVPN remote address. (Hostname or IP Address)"
  echo
}

while getopts "hs:c:r:" o
do
  case "${o}" in
    h)
      help
      exit 0
      ;;
    s)
      OVPN_SERVER_NAME=${OPTARG}
      ;;
    c)
      OVPN_CLIENT_NAME=${OPTARG}
      ;;
    r)
      OVPN_REMOTE_ADDRESS=${OPTARG}
      ;;
    *)
      help
      exit 1
      ;;
  esac
done

if [ -z "$OVPN_CLIENT_NAME" ]; then
  help
  exit 1
fi
if [ -z "$OVPN_REMOTE_ADDRESS" ]; then
  help
  exit 1
fi

CONF_PATH="/etc/openvpn/${OVPN_CLIENT_NAME}.ovpn"

docker exec \
  -w /etc/openvpn/easy-rsa \
  -it \
  ${OVPN_SERVER_NAME} \
  sh -c "/app/create-client.sh -c ${OVPN_CLIENT_NAME} -r ${OVPN_REMOTE_ADDRESS}"

docker cp ${OVPN_SERVER_NAME}:$CONF_PATH .
