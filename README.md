# ss_docker
This is a docker image for both shadowsocks server and kcptun server, which can help you run shadowsocks and kcp in your VPC very easily.

* shadowsocks server: https://github.com/shadowsocks/shadowsocks-libev
* kcptun server: https://github.com/xtaci/kcptun

This docker image will use pre-compiled shadowsocks-libev from ubuntu apt repo, and pre-compiled kcptun server by myself (added to this git repo already). When building this docker image, docker will pull kcptun_server from this git repo. This is to reduce the size of the docker image. To use your own pre-compiled binaries, just edit **Dockerfile**

# How to use this docker image
````
docker pull melvinto/ss_kcptun
docker run -d -p 8900:8900/udp -p 8899:8899/udp <image_name> [-k <your password>] -s <your_vpc_public_hostname_or_ip> [-p <kcp_port>] [-P <ss_port>]
docker logs <container_id>
````

## Example
````
# 8900 is kcp port
# 8899 is ss udp port (8899 is used for replaying dns query via ss-tunnel)
docker run -d -p 8900:8900/udp -p 8899:8899/udp ss_kcp -k ss123456 -s yourvpc.com

# more ss and kcp configurations can be found in console output
docker logs d17565c47321

# use another port other than 8900, 8899
docker run -d -p 9900:9900/udp -p 9990:9990/udp ss_kcp -k ss123456 -s yourvpc.com -p 9900 -P 9990

# if -k (password) is not specified, random 8-charactor password will be generated and print in console of the docker container

# mount log folder to host (/var/log @ docker container => ~/log @ host)
docker run -d -p 8900:8900/udp -p 8899:8899/udp ss_kcp -k ss123456 -s yourvpc.com -v ~/log:/var/log

# or you can build docker image by yourself
docker build .
````

## Default parameters
* KCP
  * method: fast2
  * send window: 1024
  * recv window: 1024
  * MTU: 1400
  * port: 8900
* Shadowsocks
  * port: 8899
  * method: aes-256-cfb
