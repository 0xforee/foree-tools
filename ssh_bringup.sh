#!/bin/bash
PROJECT_DIR=/home/fbash/.config/foree-tools
PROJECT_CONF=/home/fbash/.config/foree-tools/foree-tools.conf
TMP_IPS=()
TMP_LOCATION=()

source $PROJECT_CONF

function add_color_for_echo
{
    echo -e "\033[33m 
    $1
    \033[0m"
}


function yes_or_no
{
    read input_choice
    case $input_choice in
        y|yes|Y|Yes)
            return 1
            ;;
        n|no|N|NO)
            return 0
            ;;
        *)
            echo "input error,please again"
            yes_or_no
            ;;
    esac
}

function do_choice
{
    local i=0
    local count=${#TMP_IPS[@]}
    if [ $count -eq '1' ];then
        add_color_for_echo " IP: ${TMP_IPS[$i]}
        LOCATION: ${TMP_LOCATION[$i]}"
        LOGIN_IP=${TMP_IPS[$i]}
    else
        if [ $count -eq '0' ];then
            server_info
            echo "未指定项目或指定的项目不存在!!!"
            count=${#BRINGUP_IPS[@]}
            echo "which server you want to login ?"
            echo -n "<1...$count>?"
            read SELECTION
            #如果选择不为0,且小于等于IP数量,并且选择是个数字,那么就去选择IP
            if [ $SELECTION -ne '0' -a $SELECTION -le $count ] && [[ $SELECTION =~ [0-9]* ]];then
                LOGIN_IP=${BRINGUP_IPS[$(($SELECTION-1))]}
                is_first_login $(($SELECTION-1))
            else
                echo "输入错误,请在1...${count}中选择"
            fi
        else
            while [ $i -lt $count ]
            do
                add_color_for_echo "IP: ${TMP_IPS[$i]}\n LOCATION: ${TMP_LOCATION[$i]}"
                let 'i++'
            done
            echo "which server you want to login ?"
            echo -n "<1...$count>?"
            read SELECTION
            case $SELECTION in
                [0-9]*)
                    LOGIN_IP=${TMP_IPS[$(($SELECTION-1))]}
                    is_first_login $(($SELECTION-1))
                    ;;
                *)
                    LOGIN_IP=${BRINGUP_IPS[0]}
                    is_first_login 0
                    ;;
            esac
        fi
    fi
}

function server_info
{

    for local_i in ${!BRINGUP_IPS[@]}
    do
        echo "$((local_i+1)). ${BRINGUP_IPS[$local_i]}"
        cat ~/.config/foree-tools/${BRINGUP_PROJECT_LIST[$local_i]}|grep -v ^#
    done

    #echo -n "   bringup:"
    #echo -e "\033[33m M76_flyme5 \033[0m"
    #echo -n "   dailybuild: "
    #echo -e "\033[33m M75_base, M76_base, M85_base\033[0m"
    #echo " 2.IP 172.16.132.38"
    #echo -n "   bringup:"
    #echo -e "\033[33m M71_flyme5, MA01C_base \033[0m"
    #echo -n "   dailybuild:"
    #echo -e "\033[33m M71C_base, M85-l1_base, M86_base, M86_flyme5, M88_base, MA01_base\033[0m"
}

function is_first_login
{
    if [ -z "$1" ];then
        echo "input error"
    elif [ "${FIRST_LOGIN[$1]}" = "true" ]; then
        echo "first login"
        if [ -f ~/.ssh/id_rsa.pub ];then
            ssh-copy-id -i ~/.ssh/id_rsa.pub bringup@${BRINGUP_IPS[$1]} 2>&1 > /dev/null
            FIRST_LOGIN[$1]="false"
            for i in ${!FIRST_LOGIN[@]}
            do
                sed -i "/FIRST_LOGIN/ s/true/${FIRST_LOGIN[$i]}/" $PROJECT_CONF
            done
        else
            echo -e "\033[33m If you want to login without input passwd \033[0m"
            echo -e "\033[33m You must generate your rsa key first!! \033[0m"
            add_color_for_echo "Generate now(y/n)?"
            yes_or_no
            if [ $? -eq '1' ];then
                ssh-keygen -t rsa
                is_first_login $1
            fi
        fi
    fi
}

function bringup_ssh
{
    cd $PROJECT_DIR
    local i=0
    local tmp_i=0
    if [ ! -z "$1" ];then
        SERVER_LIST=$( ls SERVER_* )
        for SERVER in $SERVER_LIST
        do
            search_result=$( grep -i "$1" $SERVER |grep -v ^#)
            if [ ! -z "$search_result" ];then
                TMP_LOCATION[$tmp_i]="$search_result"
                TMP_IPS[$tmp_i]="${BRINGUP_IPS[$i]}"
                let 'tmp_i++'
            fi
            let 'i++'
        done
    fi
    do_choice

    ssh bringup@$LOGIN_IP
    unset LOGIN_IP

}
