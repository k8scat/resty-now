# resty-now

OpenResty - Nginx Oauth Wechat

## Start

Put `now.conf` and `now.lua` in `/usr/local/openresty/nginx/conf/`

```
# Edit /usr/local/openresty/nginx/conf/nginx.conf
include /usr/local/openresty/nginx/conf/now.conf;

# Update now.conf
set $now_corp_id "";
set $now_agent_id "";
set $now_secret "";
set $now_callback_schema "https";
set $now_callback_host "example.com";
set $now_callback_uri "/oauth_wechat";
set $now_logout_uri "/oauth_logout";
set $now_token_expires "7200";
set $use_secure_cookie "true";
access_by_lua_file "/usr/local/openresty/nginx/conf/now.lua";

```

## Best develop experiment with `lua`

#### IDEA developer (recommend)

- IDEA with plugins
    - EmmyLua
    - OpenResty Lua Support
    - nginx Support
- scp
    - sync local file to remote server
- ssh
    - execute commands after sync

```shell script
./sync.sh $LOCAL_PATH $REMOTE_PATH

```

#### Cloud Studio by coding.net

Coding with a browser vscode (also need install `EmmyLua` Extension),
but I cannot find an extension for OpenResty snippet.

```
# need jdk8
yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel

```

#### VSCode with `Remote - SSH` Extension

## Install openresty + luarocks

Refer the Dockerfile below

```dockerfile
FROM centos:7

WORKDIR /data

EXPOSE 80
EXPOSE 443

RUN yum install -y pcre-devel openssl-devel gcc curl perl wget make unzip && \
wget https://openresty.org/download/openresty-1.17.8.2.tar.gz && \
tar -zxf openresty-1.17.8.2.tar.gz && \
cd openresty-1.17.8.2 && \
./configure --with-http_v2_module && \
make && \
make install && \
cd - && \
wget https://luarocks.org/releases/luarocks-3.3.1.tar.gz && \
tar -zxf luarocks-3.3.1.tar.gz && \
cd luarocks-3.3.1 && \
./configure --prefix=/usr/local/openresty/luajit \
--with-lua=/usr/local/openresty/luajit \
--lua-suffix=jit \
--with-lua-include=/usr/local/openresty/luajit/include/luajit-2.1 && \
cd - && \
rm -f openresty-1.17.8.2.tar.gz luarocks-3.3.1.tar.gz

```

## Enable HTTPS

`certbot` + `letsencrypt`

```
# install certbot
yum install -y certbot

# reinstall requests and urllib3
# refer https://github.com/ansible/tower-cli/issues/603
# uninstall
pip uninstall requests
pip uninstall urllib3
yum remove python-urllib3
yum remove python-requests
# check
rpm -qa | grep requests
pip freeze | grep requests
# install
yum install python-urllib3
yum install python-requests

# request certs
certbot certonly --standalone -d $YOUR_DOMAIN

```

## Difference between ngx.var.request_uri and ngx.var.uri

ngx.var.request_uri is the full request uri with query params,
ngx.var.uri is more simple which only contains the request path.

```
# GET https://api.example.com/user?id=24
ngx.var.request_uri == /user?id=24
ngx.var.uri == /user

```

## Lua modules

- [lua-nginx-module](https://github.com/openresty/lua-nginx-module)
- [lua-resty-http](https://github.com/ledgetech/lua-resty-http)
- [lua-cjson](https://github.com/mpx/lua-cjson)

## Notes

#### Should specify `lua_ssl_verify_depth` and `lua_ssl_verify_depth` in site config

error: unable to get local issuer certificate

http://blog.kankanan.com/article/4fee590d-ssl-certificate-problem-unable-to-get-local-issuer-certificate.html

#### Alert reverse proxy setup is broken when applied to jenkins

```
# Set `X-Forwarded-Proto` header
proxy_set_header   X-Forwarded-Proto $scheme;

```

https://wiki.jenkins.io/display/JENKINS/Jenkins+says+my+reverse+proxy+setup+is+broken

## Nginx documentation

http://nginx.org/en/docs/

## Wechat Oauth Documentation

https://work.weixin.qq.com/api/doc/90000/90135/91025