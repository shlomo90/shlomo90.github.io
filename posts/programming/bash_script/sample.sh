#!/bin/bash

set -ex

proc_php=`ps aux | grep php | awk '{ if ($11 == "php") print $2; }'`
echo "|$proc_php|"
if [ -n "$proc_php" ]; then
        echo "killed php $proc_php"
        kill -9 $proc_php
fi


proc_ngx=`ps aux | grep nginx | awk '{ if ($12 == "master" || $12 == "worker") print $2; }'`
echo $proc_ngx
for pid in $proc_ngx
do
        echo "killed $pid"
        kill -9 $pid
done

#/workspace/nginx/objs/nginx -s quit

pushd /workspace/html
  php -S 127.0.0.1:9000 &
popd


