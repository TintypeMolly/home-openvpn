## Reference

https://ubuntu.com/server/docs/service-openvpn

## Need to be done in host computer

Edit `/etc/sysctl.conf`` and uncomment the following line to enable IP forwarding.

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

```sh
./create-client.sh -c myclient -r hostname.of.vpnserver
```

It generates `myclient.ovpn` config file.