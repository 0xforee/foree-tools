#!/bin/bash
### Description: 添加对整个工具的更新
### Author: foree
### Date: 20151119
source ./foree-tools.conf

FUNCTION_LIST="common.sh fastboot_flash.sh pick_branch.sh ssh_bringup.sh fadb_funtion fkill foree-tools.conf SERVER_0 SERVER_1"

#更新服务器的project列表,不加参数,默认不更新服务器project列表
if [ "$@x" = "-ax" ];then 
    ./find_project.sh
    if [ "$?" -ne '0' ];then echo "find project error" ;exit 1 ;fi
else
    echo "skip update server list"
fi

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
source ~/.config/foree-tools/common.sh
source ~/.config/foree-tools/fadb_funtion
complete -W "M80_base M76-l1_base M86_flyme5 M76_base M75_base M71C-l1_base M71-l1_base M85-l1_base M88_base" bringup_ssh
# end by foree-tools
EOF
echo "add success"
fi
