FROM ubuntu:16.04
MAINTAINER Melvin Tu <melvinto@gmail.com>

RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:max-c-lv/shadowsocks-libev
RUN apt-get update
RUN apt-get install -y shadowsocks-libev pwgen wget
RUN wget -q https://github.com/MelvinTo/ss_docker/raw/master/kcptun_server -O /usr/bin/kcptun_server && chmod +x /usr/bin/kcptun_server
RUN wget -q https://github.com/MelvinTo/ss_docker/raw/master/qrcode-terminal -O /usr/bin/qrcode-terminal && chmod +x /usr/bin/qrcode-terminal
RUN wget -q https://github.com/MelvinTo/ss_docker/raw/master/ss_kcp_setup.sh -O /usr/bin/ss_kcp_setup.sh && chmod +x /usr/bin/ss_kcp_setup.sh && md5sum /usr/bin/ss_kcp_setup.sh

ENTRYPOINT ["/usr/bin/ss_kcp_setup.sh"]
