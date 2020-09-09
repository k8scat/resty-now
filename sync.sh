#!/bin/bash
set -e

source_path=$1
if [ ! -f "$source_path" ];then
  echo "not a file: $source_path"
  exit 1
fi
dest_path=$2

scp "$source_path" "$REMOTE_USER"@"$REMOTE_IP":"$dest_path"
ssh "$REMOTE_USER"@"$REMOTE_IP" "/usr/local/openresty/nginx/sbin/nginx -p /usr/local/openresty/nginx/ -c conf/nginx.conf -s reload"
