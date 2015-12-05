#!/bin/bash
### Description: 卸载并删除所有相关文件
### Author:foree
### Date:20151205

source ./foree-tools.conf
source ./common.sh

function _delete_export()
{
    local SHELL_RC

    #判断当前shell
    if (echo -n $SHELL |grep -q "bash" ); then
        SHELL_RC=~/.bashrc
    elif ( echo -n $SHELL |grep -q "zsh" ); then
        SHELL_RC=~/.zshrc
    fi

    #是否已经导出函数列表
    if [ ! -z "$(cat $SHELL_RC |grep foree-tools)" ];then
        #清除export命令
        sed -i "/add by foree-tools/,/end by foree-tools/d" $SHELL_RC
        echo "Clean Success =====> $SHELL_RC"
    else
        echo "Already Cleaned =====> $SHELL_RC "
    fi
}

#清除链接的可执行文件
function _clean_link_script()
{
    if [ -n "$LINK_LIST" ];then
        for i in $LINK_LIST
        do
            echo $i
            if [ -L /usr/local/bin/$i ];then
                sudo rm /usr/local/bin/$i
                echo "Cleaning $i =====> /usr/local/bin/$i"
            fi
        done
    else
        echo "LINK_LIST is null, Please check foree-tools.conf"
    fi
}

function main()
{
    #检查是否以sudo运行命令
    if (sudo echo);then
        echo -n
    else
        echo "You must be root Or use \"sudo uninstall.sh\""
        exit
    fi

    #调试模式
    if [ ! -z "$1" -a "x$1" = "x-b" ];then

        #取得DEBUG路径,并擦除配置文件相关配置
        DEBUG_PATH=`pwd`
        #擦除配置文件相关配置
        sed -i "/DEBUG_PATH/ s#=.*#=#" ./foree-tools.conf

    else #用户模式

        echo -n "You will clean User configuration(yes/no)?"
        RSEULT=$(yes_or_no)
        case $RESULT in
            n)
                exit;;
            yes)
                ;;
        esac

        #清理用户配置文件
        if [ -d $TOOLS_CONFIG_DIR ];then
            rm $TOOLS_CONFIG_DIR -rf
        else
            echo "Already Cleaned =====> $TOOLS_CONFIG_DIR"
        fi

    fi

    #清除函数列表到环境变量
    _delete_export

    #清除link文件
    _clean_link_script

}
main $@
