#!/bin/bash
### Description: 自己的工具集合的安装脚本
### Author: foree
### Date: 20151025

source ./foree-tools.conf

#FUNCTION_LIST="common.sh fastboot_flash.sh pick_branch.sh ssh_bringup.sh fadb_funtion fkill foree-tools.conf SERVER_0 SERVER_1"
FUNCTION_LIST=`ls |grep -v "install.sh update.sh README.md"`
LINK_LIST="bringup_ssh fadb fkill frepo"
LINK_PATH=

#导出函数列表到指定文件
function _export_function_to_shell()
{
    local SHELL_RC

    #判断当前shell
    if (echo -n $SHELL |grep -q "bash" ); then
        SHELL_RC=.bashrc
    elif ( echo -n $SHELL |grep -q "zsh" ); then
        SHELL_RC=.zshrc
    fi

    #是否已经导出函数列表
    if [ ! -z "$(cat ~/$SHELL_RC |grep foree-tools)" ];then
        echo "exist already! skip !"
    else
        whattime=`date +%Y_%m%d_%H%M`
        cat ~/$SHELL_RC <<EOF
# $whattime add by foree-tools
source $DEBUG_PATH/export_to_shell
# end by foree-tools
EOF
        echo "Add to $1 success"
    fi
}

#链接可执行文件
function _link_script()
{
    for i in $LINK_LIST
    do
        if [ ! -f /usr/local/bin/$i -a -n "$LINK_PATH" ];then
            sudo ln -s $LINK_PATH/$i /usr/local/bin/$i
            echo "Linking $i =====> /usr/local/bin/$i"
        fi
    done
}

function main()
{
    #检查是否以sudo运行命令
    if (sudo echo);then
        echo -n
    else
        echo "You must be root Or use \"sudo install.sh\""
        exit
    fi

    #调试模式
    if [ ! -z "$1" -a "x$1" = "x-b" ];then

        #取得DEBUG路径,并写入配置文件
        DEBUG_PATH=`pwd`
        sed -i "/DEBUG_PATH/ s#=#=$DEBUG_PATH#" ./foree-tools.conf

        LINK_PATH=$DEBUG_PATH

    else #用户模式

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

        LINK_PATH=$TOOLS_CONFIG_DIR

    fi

    #导出函数列表到环境变量
    _export_function_to_shell

    #链接可执行文件
    _link_script

}
main $@
