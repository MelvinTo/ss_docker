FROM ubuntu:16.04
MAINTAINER Melvin Tu <melvinto@gmail.com>

RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:max-c-lv/shadowsocks-libev
RUN apt-get update
RUN apt-get install -y shadowsocks-libev pwgen

ENTRYPOINT ["/usr/bin/ss-server"]
