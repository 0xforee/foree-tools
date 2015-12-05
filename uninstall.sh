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
    if (sudo echo -n);then
        echo -n
    else
        echo "You must be root Or use \"sudo uninstall.sh\""
        exit
    fi

    #取得DEBUG路径,并擦除配置文件相关配置
    DEBUG_PATH=`pwd`
    #擦除配置文件相关配置
    sed -i "/DEBUG_PATH/ s#=.*#=#" ./foree-tools.conf

    #擦除配置文件LINK_LIST,user版文件已经删除,因此不需要清理
    sed -i "/LINK_LIST/ s#=.*#=#" ./foree-tools.conf
    echo "Already CLeaned =====> var-LINK_LIST"

    #清除函数列表到环境变量
    _delete_export

    #清除link文件
    _clean_link_script

}
main $@
