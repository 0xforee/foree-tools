#!/bin/bash -x

### Description: 查找给定地址的服务器的projects
### Author: foree
### Date: 20151025

#定义变量
SERVER_PATH_1=~/server/bringup36
SERVER_PATH_2=~/server/bringup38
SERVERS_PATH=(~/server/bringup36/ ~/server/bringup38/)
PROJECT_LIST=""
PROJECT_CONF=~/.config/foree-tools/foree-tools.conf

#判断给定的目录是否是project根目录
function is_project_dir
{
    project_dir=$1

    if [ -d $project_dir/.repo ];then
        echo "project dir is $project_dir"
        PROJECT_LIST=$PROJECT_LIST" "$project_dir
    else
        return 2
    fi
}

#遍历服务器下的目录
function find_project_dir
{
    cd $SERVER_PATH_1
    level1_dir_list=$( find . -maxdepth 1 -type d |cut -d / -f 2 |grep -v '^\.' )
    for dir in $level1_dir_list
    do
        is_project_dir $dir
        if [ $? -eq '2' ];then
            cd $dir
            level2_dir_list=$( find . -maxdepth 1 -type d |cut -d / -f 2 |grep -v '^\.' )
            for level2_dir in $level2_dir_list
            do
                is_project_dir $level2_dir
                if [ $? -eq '2' ];then
                    cd $level2_dir
                    level3_dir_list=$( find . -maxdepth 1 -type d |cut -d / -f 2 |grep -v '^\.' )
                    for level3_dir in $level3_dir_list
                    do
                        is_project_dir $level3_dir
                    done
                    cd ..
                fi
            done
            cd ..
        fi
    done

    echo "SERVER_1:$PROJECT_LIST" >>$PROJECT_CONF
}

find_project_dir
