# ss_docker
This is a docker image for both shadowsocks server and kcptun server, which can help you run shadowsocks and kcp in your VPC very easily.

* shadowsocks server: https://github.com/shadowsocks/shadowsocks-libev
* kcptun server: https://github.com/xtaci/kcptun

This docker image will use pre-compiled shadowsocks-libev from ubuntu apt repo, and pre-compiled kcptun server by myself (added to this git repo already). When building this docker image, docker will pull kcptun_server from this git repo. This is to reduce the size of the docker image. To use your own pre-compiled binaries, just edit **Dockerfile**

# How to use this docker image
````
docker build . -t <image_name>
docker run -d -p 8900:8900/udp <image_name> -k <your password> -s <your_vpc_public_hostname_or_ip>
docker logs <container_id>
````

## Example
````
docker build . -t ss_kcp
docker run -d -p 8900:8900/udp ss_kcp -k ss123456 -s yourvpc.com

# more ss and kcp configurations can be found in console output
docker logs d17565c47321

# use another port other than 8900
docker run -d -p 9900:9900/udp ss_kcp -k ss123456 -s yourvpc.com -p 9900
````
