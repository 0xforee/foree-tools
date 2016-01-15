#!/bin/bash
### Description: update goagentIP auto
### Author: foree
### Date: 20160115

SOFT_DIR=$(dirname(realpath $0))
source $SOFT_DIR/common.sh

goagent_path=~/Software/goagent

wget https://raw.githubusercontent.com/out0fmemory/GoAgent-Always-Available/master/%E7%94%B5%E4%BF%A1%E5%AE%BD%E5%B8%A6%E9%AB%98%E7%A8%B3%E5%AE%9A%E6%80%A7Ip.txt -O /tmp/ips.txt

goagentIP=`cat /tmp/ips.txt`

flog -D $goagentIP

function parse_proxy_ini
{
    sed -i "/^google_cn/ s/=.*/=\ $goagentIP/g" $goagent_path/local/proxy.ini
    sed -i "/^google_hk/ s/=.*/=\ $goagentIP/g" $goagent_path/local/proxy.ini
    sed -i "/^google_talk/ s/=.*/=\ $goagentIP/g" $goagent_path/local/proxy.ini

}

parse_proxy_ini
