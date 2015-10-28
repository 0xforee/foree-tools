#!/bin/bash -x
### Description: 自己的工具集合的安装脚本
### Author: foree
### Date: 20151025
TOOLS_NAME="foree-tools"
TOOLS_PATH=~/bin
TOOLS_CONFIG_DIR=~/.config/$TOOLS_NAME
TOOLS_CONFIG_NAME="foree-tools.conf"

#创建程序的配置目录
if [ ! -d $TOOLS_CONFIG_DIR ];then
    mkdir -p $TOOLS_CONFIG_DIR
fi

#创建配置文件
if [ ! -f $TOOLS_CONFIG_DIR/$TOOLS_CONFIG_NAME ];then
    cp ./foree-tools.conf.default $TOOLS_CONFIG_DIR/$TOOLS_CONFIG_NAME
fi

#遍历配置脚本中的数组来初始化
source $TOOLS_CONFIG_DIR/$TOOLS_CONFIG_NAME
for i in ${!BRINGUP_PROJECT_LIST[@]}
do
    echo ${BRINGUP_PROJECT_LIST[$i]}
    if [ "${BRINGUP_PROJECT_LIST[$i]}"x = "SERVER_$i"x -a ! -f $TOOLS_CONFIG_DIR/SERVER_$i ];then
        touch $TOOLS_CONFIG_DIR/SERVER_$i
    fi
done
