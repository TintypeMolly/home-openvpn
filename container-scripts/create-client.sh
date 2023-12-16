#!/bin/bash

help()
{
  echo "Create client *.ovpn config file."
  echo
  echo "Usage: ./run.sh [-h] -c OVPN_CLIENT_NAME -r OVPN_REMOTE_ADDRESS"
  echo "Options:"
  echo "-h     Print this help message."
  echo "-c     Set OpenVPN client name."
  echo "-r     Set OpenVPN remote address. (Hostname or IP Address)"
  echo
}

while getopts "hc:r:" o
do
  case "${o}" in
    h)
      help
      exit 0
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

cd /etc/openvpn/easy-rsa
./easyrsa gen-req ${OVPN_CLIENT_NAME} nopass
./easyrsa sign-req client ${OVPN_CLIENT_NAME}

cat << EOF > $CONF_PATH
client
proto udp
EOF

echo "remote ${OVPN_REMOTE_ADDRESS}" >> $CONF_PATH

cat << EOF >> $CONF_PATH
port 1194
dev tun
nobind
key-direction 1

<ca>
EOF

cat /etc/openvpn/easy-rsa/pki/ca.crt >> $CONF_PATH

cat << EOF >> $CONF_PATH
</ca>

<cert>
EOF

cat /etc/openvpn/easy-rsa/pki/issued/${OVPN_CLIENT_NAME}.crt >> $CONF_PATH

cat << EOF >> $CONF_PATH
</cert>

<key>
EOF

cat /etc/openvpn/easy-rsa/pki/private/${OVPN_CLIENT_NAME}.key >> $CONF_PATH

cat << EOF >> $CONF_PATH
</key>

<tls-auth>
EOF

cat /etc/openvpn/ta.key >> $CONF_PATH

cat << EOF >> $CONF_PATH
</tls-auth>
EOF
