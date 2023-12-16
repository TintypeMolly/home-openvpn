#!/bin/bash

/usr/sbin/openvpn \
  --script-security 2 \
  --config /etc/openvpn/%i.conf
