#!/bin/bash 

### Description: 查找给定地址的服务器的projects
### Author: foree
### Date: 20151025

#定义变量
SERVER_PATH_1=~/server/bringup36
SERVER_PATH_2=~/server/bringup38
PROJECT_LIST=""
PROJECT_CONF=~/.config/foree-tools/foree-tools.conf

#遍历服务器下的目录
function find_dir
{
    cd $SERVER_PATH_1
    root_dir_list=$( find . -maxdepth 1 -type d |cut -d / -f 2 |grep -v '^\.' )
    for dir in $root_dir_list
    do
        is_project_dir $dir
    done
    echo "SERVER_1:$PROJECT_LIST" >>$PROJECT_CONF
    PROJECT_LIST=""
    cd $SERVER_PATH_2
    root_dir_list=$( find . -maxdepth 1 -type d |cut -d / -f 2 |grep -v '^\.' )
    for dir in $root_dir_list
    do
        is_project_dir $dir
    done
    echo "SERVER_2:$PROJECT_LIST" >>$PROJECT_CONF
}

#判断给定的目录是否是project 目录,如果不是，继续向下查找
function is_project_dir
{
    root_dir=$1
    if [ -d $root_dir/.repo ];then
        echo "project dir is $root_dir"
        PROJECT_LIST=${PROJECT_LIST}" "${root_dir}
    else
        dir_level_2=$( find $root_dir -maxdepth 1 -type d )
        for dir in $dir_level_2
        do
            if [ -d $dir/.repo ];then
                echo "project dir is $dir"
                PROJECT_LIST=${PROJECT_LIST}" "${dir}
            fi
        done
    fi
}
find_dir
