#!/bin/bash

PUBLIC_SERVER=127.0.0.1
SS_BINARY=/usr/bin/ss-server
SS_IP=0.0.0.0
SS_PORT=8899
SS_METHOD=aes-256-cfb
SS_PASSWORD=`pwgen 8 1`

KCP_BINARY=/usr/bin/kcptun_server
KCP_PORT=8900
KCP_MODE=fast2
KCP_MTU=1400
KCP_SEND_WINDOW=1024
KCP_RECV_WINDOW=1024

while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    -s|--server)
    PUBLIC_SERVER="$2"
    shift # past argument
    ;;
    -p|--port)
    KCP_PORT="$2"
    shift # past argument
    ;;
    -P|--ssport)
    SS_PORT="$2"
    shift # past argument
    ;;
    -k|--password)
    SS_PASSWORD="$2"
    ;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
done


$SS_BINARY -s $SS_IP -p $SS_PORT -m $SS_METHOD -k $SS_PASSWORD -v &>/var/log/ss.log &
$KCP_BINARY -mtu $KCP_MTU -sndwnd $KCP_SEND_WINDOW -rcvwnd $KCP_RECV_WINDOW -mode $KCP_MODE -t "127.0.0.1:$SS_PORT" -l ":$KCP_PORT" --log /var/log/kcp.log &

read -r -d '' SERVER_CONFIG << EOM
{
	"from": "firewalla",
	"server_port": $SS_PORT,
	"password":"$SS_PASSWORD",
	"timeout":1000,
	"method":"aes-256-cfb",
	"server": "$PUBLIC_SERVER",
	"kcp_enabled": true,
	"kcp_mode": "$KCP_MODE",
	"kcp_send_window": $KCP_SEND_WINDOW,
	"kcp_recv_window": $KCP_RECV_WINDOW,
	"kcp_server": "$PUBLIC_SERVER",
	"kcp_server_port": "$KCP_PORT"
}

EOM

echo $SERVER_CONFIG

echo "QR Code for server config"
QR_BINARY=/usr/bin/qrcode-terminal
$QR_BINARY "$SERVER_CONFIG"

# this is just to ensure this docker container will keep running
tail -f /dev/null
