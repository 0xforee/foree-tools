#!/bin/bash
### Description: 自己的工具集合的安装脚本
### Author: foree
### Date: 20151025
TOOLS_NAME="foree-tools"
TOOLS_PATH=~/bin
TOOLS_CONFIG_DIR=~/.config/foree-tools
TOOLS_CONFIG_NAME="foree-tools.conf"

if [ ! -d $TOOLS_CONFIG_DIR ];then
    mkdir -p $TOOLS_CONFIG_DIR
fi

if [ ! -f $TOOLS_CONFIG_DIR/$TOOLS_CONFIG_NAME ];then
    touch $TOOLS_CONFIG_DIR/$TOOLS_CONFIG_NAME
fi
