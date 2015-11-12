#!/bin/bash
### Description: 自己的工具集合的安装脚本
### Author: foree
### Date: 20151025

source ./foree-tools.conf.default

FUNCTION_LIST="common.sh fastboot_flash.sh pick_branch.sh ssh_bringup.sh fadb_funtion find_project.sh"

#创建程序的配置目录
if [ ! -d $TOOLS_CONFIG_DIR ];then
    mkdir -p $TOOLS_CONFIG_DIR
fi

#初始化或者更新配置文件
if [ ! -f $TOOLS_CONFIG_DIR/$TOOLS_CONFIG_NAME -o ./foree-tools.conf.default -nt $TOOLS_CONFIG_DIR/$TOOLS_CONFIG_NAME ];then
    cp ./foree-tools.conf.default $TOOLS_CONFIG_DIR/$TOOLS_CONFIG_NAME
    if [ $? -eq '0' ];then echo "init/update success";fi
fi

#生成存放project的对应文件
for i in ${!BRINGUP_PROJECT_LIST[@]}
do
    if [ "${BRINGUP_PROJECT_LIST[$i]}"x = "SERVER_$i"x -a ! -f $TOOLS_CONFIG_DIR/SERVER_$i ];then
        echo "Installing ${BRINGUP_PROJECT_LIST[$i]}......"
        cp ./SERVER_${i}_default $TOOLS_CONFIG_DIR/SERVER_$i
    fi
done

#初始化或者更新相关文件
for function_list_file in $FUNCTION_LIST
do
    if [ ! -f $TOOLS_CONFIG_DIR/$function_list_file -o ./$function_list_file -nt $TOOLS_CONFIG_DIR/$function_list_file ];then
        echo "Installing $function_list_file ......."
        cp ./$function_list_file $TOOLS_CONFIG_DIR/$function_list_file
    fi
done

#在.bashrc中source 环境变量
if [ ! -z "$(cat ~/.bashrc |grep foreetools)" ];then
   echo "exist already! skip !"
else
    whattime=`date +%Y_%m%d_%H%M`
    cat >>~/.bashrc <<EOF
# $whattime add by foreetools
source ~/.config/foree-tools/fadb_funtion
source ~/.config/foree-tools/ssh_bringup.sh
source ~/.config/foree-tools/find_project.sh
source ~/.config/foree-tools/common.sh
EOF
echo "add success"
fi
