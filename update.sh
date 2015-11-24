#!/bin/bash
### Description: 添加对整个工具的更新
### Author: foree
### Date: 20151119
source ./foree-tools.conf.default

FUNCTION_LIST="common.sh fastboot_flash.sh pick_branch.sh ssh_bringup.sh fadb_funtion"

#更新配置文件
if [ ./foree-tools.conf.default -nt $TOOLS_CONFIG_DIR/$TOOLS_CONFIG_NAME ];then
    cp ./foree-tools.conf.default $TOOLS_CONFIG_DIR/$TOOLS_CONFIG_NAME
    if [ $? -eq '0' ];then echo "Update config ...";fi
fi

#更新服务器的project列表,不加参数,默认不更新服务器project列表
if [ "$@x" = "-ax" ];then 
    ./find_project.sh
    if [ "$?" -ne '0' ];then echo "find project error" ;exit 1 ;fi
else
    echo "skip update server list"
fi

#更新存放project的对应文件
for i in ${!BRINGUP_PROJECT_LIST[@]}
do
    if [ "${BRINGUP_PROJECT_LIST[$i]}"x = "SERVER_$i"x -a ./SERVER_${i}_default -nt $TOOLS_CONFIG_DIR/SERVER_$i ];then
        echo "Updating ${BRINGUP_PROJECT_LIST[$i]} ..."
        cp ./SERVER_${i}_default $TOOLS_CONFIG_DIR/SERVER_$i
    fi
done

#更新相关文件
for function_list_file in $FUNCTION_LIST
do
    if [ ./$function_list_file -nt $TOOLS_CONFIG_DIR/$function_list_file ];then
        echo "Updating $function_list_file ..."
        cp ./$function_list_file $TOOLS_CONFIG_DIR/$function_list_file
    fi
done

#在.bashrc中source 环境变量
if [ ! -z "$(cat ~/.bashrc |grep "foree-tools")" ];then
   echo "exist already! skip !"
else
    whattime=`date +%Y_%m%d_%H%M`
    cat >>~/.bashrc <<EOF
# $whattime add by foree-tools
source ~/.config/foree-tools/fadb_funtion
source ~/.config/foree-tools/ssh_bringup.sh
source ~/.config/foree-tools/common.sh
complete -W "M80_base M76-l1_base M86_flyme5 M76_base M75_base M71C-l1_base M71-l1_base M85-l1_base M88_base" bringup_ssh
# end by foree-tools
EOF
echo "add success"
fi
