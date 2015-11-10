#!/bin/bash
### Description: 自己的工具集合的安装脚本
### Author: foree
### Date: 20151025

source ~/.config/foree-tools/foree-tools.conf

#创建程序的配置目录
if [ ! -d $TOOLS_CONFIG_DIR ];then
    mkdir -p $TOOLS_CONFIG_DIR
fi

#初始化或者更新配置文件
if [ ! -f $TOOLS_CONFIG_DIR/$TOOLS_CONFIG_NAME -o ./foree-tools.conf.default -nt $TOOLS_CONFIG_DIR/$TOOLS_CONFIG_NAME ];then
    cp ./foree-tools.conf.default $TOOLS_CONFIG_DIR/$TOOLS_CONFIG_NAME
    echo "init/update success"
fi

#生成存放project的对应文件
source $TOOLS_CONFIG_DIR/$TOOLS_CONFIG_NAME

for i in ${!BRINGUP_PROJECT_LIST[@]}
do
    echo ${BRINGUP_PROJECT_LIST[$i]}
    if [ "${BRINGUP_PROJECT_LIST[$i]}"x = "SERVER_$i"x -a ! -f $TOOLS_CONFIG_DIR/SERVER_$i ];then
        touch $TOOLS_CONFIG_DIR/SERVER_$i
    fi
done

#在.bashrc中source 环境变量
if [ ! -z "$(cat ~/.bashrc |grep foreetools)" ];then
   echo "exist already! skip !"
else
    whattime=`date +%Y_%m%d_%H%M`
    cat >>~/.bashrc <<EOF
# $whattime add by foreetools
source ~/github/foree-tools/fadb_funtion
source ~/github/foree-tools/ssh_bringup.sh
source ~/github/foree-tools/find_project.sh
source ~/github/foree-tools/common.sh
EOF
echo "add success"
fi
