#!/bin/bash 

### Description: 查找给定地址的服务器的projects
### Author: foree
### Date: 20151025

#定义变量
ROJECT_LIST=""

SOFT_DIR=$(dirname $0)
source $SOFT_DIR/foree-tools.conf
source $SOFT_DIR/common.sh
flog -D "SOFT_DIR is $SOFT_DIR"

#判断给定的目录是否是project根目录
function is_project_dir
{
    project_dir=$1
    base_dir=$2

    if [ -d $project_dir/.repo ];then
        if [ -f $project_dir/build/core/envsetup.mk ];then
            if [ ! -z "$2" ];then
                flog -I "project dir is $base_dir/$project_dir"
            else
                flog -I "project dir is $project_dir"
            fi
            PROJECT_LIST="$PROJECT_LIST$base_dir/$project_dir\n"
        fi
    else
        return 2
    fi
}

#遍历服务器下的目录
function find_project_dir
{
    local whattime=`date +%Y_%m%d_%H%S`

    #SERVER_* 文件需要重新生成，避免IP列表只有一个时另一个文件存在会干扰
    flog -d "删除SERVER_*"
    rm $SOFT_DIR/SERVER_* >/dev/null

    for i in ${!BRINGUP_SERVER_SAMBA_PATH[@]}
    do
        PROJECT_LIST=""
        cd ${BRINGUP_SERVER_SAMBA_PATH[$i]}
        level1_dir_list=$( find . -maxdepth 1 -type d |cut -d / -f 2 |grep -v '^\.' )
        for dir in $level1_dir_list
        do
            is_project_dir $dir
            if [ $? -eq '2' ];then
                cd $dir
                level2_dir_list=$( find . -maxdepth 1 -type d |cut -d / -f 2 |grep -v '^\.' )
                for level2_dir in $level2_dir_list
                do
                    is_project_dir $level2_dir $dir
                    if [ $? -eq '2' ];then
                        cd $level2_dir
                        level3_dir_list=$( find . -maxdepth 1 -type d |cut -d / -f 2 |grep -v '^\.' )
                        for level3_dir in $level3_dir_list
                        do
                            is_project_dir $level3_dir $dir/$level2_dir
                        done
                        cd ..
                    fi
                done
                cd ..
            fi
        done

        flog -d "${BRINGUP_PROJECT_LIST[$i]}"

        echo "# update at $whattime" > $SOFT_DIR/${BRINGUP_PROJECT_LIST[$i]}
        echo -e "$PROJECT_LIST" >>$SOFT_DIR/${BRINGUP_PROJECT_LIST[$i]}
    done
    cd $SOFT_DIR

}
find_project_dir
