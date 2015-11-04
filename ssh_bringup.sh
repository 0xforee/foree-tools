#!/bin/bash
SERVER_IP_1=172.16.132.36
SERVER_IP_2=172.16.132.38
LOGIN_IP=$SERVER_IP_1
PROJECT_LIST=~/bin/project_list
PROJECT_CONF=/home/fbash/.config/foree-tools/foree-tools.conf
DO_CHOICE="true"

source $PROJECT_CONF

function add_color_for_echo
{
    echo -e "\033[33m $1 \033[0m"
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

function server_info
{
    echo "which server you want to login ?"

    for local_i in ${!BRINGUP_IPS[@]}
    do
        echo "$((local_i+1)). ${BRINGUP_IPS[$local_i]}"
        cat ~/.config/foree-tools/${BRINGUP_PROJECT_LIST[$local_i]}
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
            if [ yes_or_no -eq '1' ];then
                ssh-keygen -t rsa
                is_first_login $1
            fi
        fi
    fi
}

function bringup_ssh
{
    if [ ! -z "$1" ];then
        search_result=$( grep -i "$1" $PROJECT_CONF |awk -F : '{print $1}')
        if [ ! -z "$search_result" ];then
            if [ "$search_result"x = "SERVER_1"x ];then
                DO_CHOICE="false"
                LOGIN_IP="$SERVER_IP_1"
                echo "项目在 $search_result"
            elif [ "$search_result"x = "SERVER_IP_2"x ];then
                DO_CHOICE="false"
                LOGIN_IP="$SERVER_IP_2"
                echo "项目在 $search_result"
            else
                echo "多个服务器同时存在$1 项目，请选择"
            fi
        else
            echo "没有指定的项目存在,请在以下项目中选择"
        fi
    fi

    if [ "$DO_CHOICE"x = "true"x ];then
        server_info
        echo -n "<1/2>?"
        read SELECTION

        case "$SELECTION" in 
            2)
                LOGIN_IP=${BRINGUP_IPS[1]}
                ;;
            *)
                LOGIN_IP=${BRINGUP_IPS[0]}
                SELECTION=1
                ;;
        esac
        is_first_login $(($SELECTION-1))
    fi

    ssh bringup@$LOGIN_IP
}
bringup_ssh
