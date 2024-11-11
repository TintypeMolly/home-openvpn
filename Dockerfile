FROM ubuntu:noble

ARG CA_PASSPHRASE
ARG OVPN_SERVERNAME

RUN apt update && apt install -y openvpn easy-rsa expect  && rm -rf /var/lib/apt/lists/*
RUN make-cadir /etc/openvpn/easy-rsa && cd /etc/openvpn/easy-rsa
WORKDIR /etc/openvpn/easy-rsa
COPY expect-scripts/build-ca.exp /etc/openvpn/easy-rsa/
RUN ./easyrsa init-pki && expect build-ca.exp
RUN yes '' | ./easyrsa gen-req ${OVPN_SERVERNAME} nopass
RUN ./easyrsa gen-dh
COPY expect-scripts/sign-req-server.exp /etc/openvpn/easy-rsa/
RUN expect sign-req-server.exp
RUN cp pki/dh.pem pki/ca.crt pki/issued/${OVPN_SERVERNAME}.crt pki/private/${OVPN_SERVERNAME}.key /etc/openvpn/
COPY server.conf /etc/openvpn/${OVPN_SERVERNAME}.conf
RUN sed -i "s|cert server.crt|cert ${OVPN_SERVERNAME}.crt|g" /etc/openvpn/${OVPN_SERVERNAME}.conf && \
    sed -i "s|key server.key|key ${OVPN_SERVERNAME}.key|g" /etc/openvpn/${OVPN_SERVERNAME}.conf
WORKDIR /etc/openvpn
RUN openvpn --genkey --secret ta.key
COPY container-scripts/run-ovpn-daemon.sh /app/
RUN sed -i "s|%i|${OVPN_SERVERNAME}|g" /app/run-ovpn-daemon.sh
COPY container-scripts/create-client.sh /app/

CMD ["/bin/bash", "/app/run-ovpn-daemon.sh"]
