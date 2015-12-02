#!/bin/bash
### Description: 对于已经编译过的版本,可以直接lunch上一次编译的类型
### Author:foree
### Date:20151109

#取得当前目录的根目录
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
            echo 'y'
            ;;
        n|no|N|NO)
            echo 'n'
            ;;
        *)
            echo "input error,please again"
            yes_or_no
            ;;
    esac
}

function _gettopdir()
{

    local TOPDIRFILE=build/core/envsetup.mk
    TOPDIR=
    HERE=`pwd`
    if [ ! -f $TOPDIRFILE ];then
        while [ ! -f $TOPDIRFILE -a "$PWD" != "/" ]; do
            \cd ..
            TOPDIR=`pwd -P`
        done
    else
        TOPDIR=`pwd -P`
    fi

    cd $HERE
    if [ -f $TOPDIR/$TOPDIRFILE ];then
        echo $TOPDIR
    fi
}

function _gettarget()
{
    local TOPDIR=$(_gettopdir)

    if [ -z $TOPDIR ];then echo "Not Found Project Here !!";return 1 ;fi

    if [ -d $TOPDIR/out/target/product ];then
        cd $TOPDIR/out/target/product
    else
        echo "You Must be run lunch manually first !!"
        return 1
    fi

    previous_path=$(find . -maxdepth 2 -name "previous_build_config.mk" |xargs ls -t1 | grep -v "generic")
    previous_number=$( echo "$previous_path" |wc -l )
    if [ $previous_number -eq '0' ];then
        echo "previous_build_config.mk not found, You Must be run lunch manually first !!"
        cd $HERE
        return 1
    elif [ $previous_number -gt '1' ];then
        previous_path=$(echo "$previous_path" |head -1)
    fi

    product_name=${previous_path#*/}
    product_name=${product_name%/*}
    lunch_name=$( grep $previous_path -e "[a-z]*_$product_name-[a-z]*" -o)

    echo $lunch_name

}

function repo_sync
{
    local whattime
    local DEFAULT_BRANCH
    local TOPDIR=$(_gettopdir)

    if [ -z "$TOPDIR" ];then echo "Not Found Project Here !!";return 1 ;fi

    cd $TOPDIR

    if [ -f .repo/manifests/default.xml ];then
        DEFAULT_BRANCH=$(cat .repo/manifests/default.xml |grep default |grep revision  |awk -F "\"" '{print $2}')
    else
        echo "default.xml not found !"
        return 1
    fi
    whattime=`date +%Y_%m%d_%H%M`
    repo sync -c -d
    repo start ${DEFAULT_BRANCH}_${whattime} --all
}

function relunch()
{
    HERE=`pwd`
    TOPDIR=$(_gettopdir)

    lunch_name=$(_gettarget)

    cd $TOPDIR
    source build/envsetup.sh
    lunch $lunch_name
    cd $HERE
}

function is_reference()
{
    local alternate=".repo/manifests.git/objects/info/alternates"
    T=$(_gettopdir)
    if [ -f "$T/$alternate" ];then
        cat "$T/$alternate"
    else
        echo "No Reference"
    fi
}
