#!/bin/bash
### Description: 对于已经编译过的版本,可以直接lunch上一次编译的类型
### Author:foree
### Date:20151109

#取得当前目录的根目录
function _gettopdir()
{

    TOPDIRFILE=build/core/envsetup.mk
    TOPDIR=
    HERE=`pwd`
    if [ ! -f $TOPDIRFILE ];then 
    while [ !  -f $TOPDIRFILE ]; do
        if [ "$PWD" = "/" ];then return 1;fi
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
    TOPDIR=$(_gettopdir)

    if [ -d $TOPDIR/out/target/product ];then
        cd $TOPDIR/out/target/product
    else
        echo "out directry not found, please run lunch manually first"
        return 1
    fi

    previous_path=$(find . -maxdepth 2 -name "previous_build_config.mk" |xargs ls -t1)
    previous_number=$( echo "$previous_path" |wc -l )
    if [ $previous_number -eq '0' ];then
        echo "previous_build_config.mk not found, please run lunch manually first"
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
    TOPDIR=$(_gettopdir)
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
    unset DEFAULT_BRANCH
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
