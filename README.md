## Reference

Refer to the official Ubuntu documentation for OpenVPN installation.

https://ubuntu.com/server/docs/service-openvpn

## Configuration on Host Computer

Edit `/etc/sysctl.conf` and uncomment the following line to enable IP forwarding.

```conf
#net.ipv4.ip_forward=1
```

Then reload sysctl.

```sh
sudo sysctl -p /etc/sysctl.conf
```

## Build

```sh
./build.sh
```

## Run

```sh
./run.sh
```

## Create Client Config

Generate a client configuration for your VPN client by running the following command:

```sh
./create-client.sh -c myclient -r hostname.of.vpnserver
```

This will create the `myclient.ovpn` configuration file.
