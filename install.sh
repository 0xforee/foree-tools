#!/bin/bash
### Description: 自己的工具集合的安装脚本
### Author: foree
### Date: 20151025

source ./foree-tools.conf

FUNCTION_LIST="common.sh fastboot_flash.sh pick_branch.sh ssh_bringup.sh fadb_funtion fkill foree-tools.conf SERVER_0 SERVER_1"

#创建程序的配置目录
if [ ! -d $TOOLS_CONFIG_DIR ];then
    mkdir -p $TOOLS_CONFIG_DIR
fi

#初始化相关文件
for function_list_file in $FUNCTION_LIST
do
    if [ ! -f $TOOLS_CONFIG_DIR/$function_list_file ];then
        echo "Installing $function_list_file ......."
        cp ./$function_list_file $TOOLS_CONFIG_DIR/$function_list_file
    fi
done

#在.bashrc中source 环境变量
if [ ! -z "$(cat ~/.bashrc |grep foree-tools)" ];then
   echo "exist already! skip !"
else
    whattime=`date +%Y_%m%d_%H%M`
    cat >>~/.bashrc <<EOF
# $whattime add by foree-tools
source ~/.config/foree-tools/common.sh
source ~/.config/foree-tools/fadb_funtion
complete -W "M80_base M76-l1_base M86_flyme5 M76_base M75_base M71C-l1_base M71-l1_base M85-l1_base M88_base" bringup_ssh
# end by foree-tools
EOF
echo "Add success"
fi
