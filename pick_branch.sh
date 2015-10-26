#!/bin/bash

# author: liming1@meizu.com
# date: 2015/07/31
# usage: pick redundant branch

OUTPUT_PATH=`pwd`
OUTPUT_FILE="${OUTPUT_PATH}/redundant_file"
REPOINIT_LOGFILE="${OUTPUT_PATH}/repoinit_log.file"
REPOSYNC_LOGFILE="${OUTPUT_PATH}/reposync_log.file"
FIND_RESULT="${OUTPUT_PATH}/find_result.sh"
WORK_DIR=$1
OPTION_NUMBER=$#

function usage
{
    echo "usage: pick_brach.sh work_dir" 
    echo "  work_dir: source dir"
}


function checkOptions
{
    usage

    #delete tmpfiles if they exist
    if [ -d "${OUTPUT_PATH}/redundant_dir" ]; then
        rm -rf ${OUTPUT_PATH}/redundant_dir
    fi

    if [ "$OPTION_NUMBER" -ne "1" ]
    then
        echo "Please add option, and try again"
        exit 1
    fi

    echo "Please make sure you have run 'repo init -u URL' first. "
    echo "                               "
    echo "And find_result.sh is exist!!!!"
    echo "                               "
    echo -n "run?(y/n):"
    read IS_EXEC
    case "$IS_EXEC" in
        yes |YES |Y |y) ;;
        no |NO |N |n) exit 0;;
    esac

    #check if find_result.sh is exist
    if [ ! -f $FIND_RESULT ]
    then
        echo "this script run with find_result.sh, please add it."
        exit 1
    fi

    for file in $OUTPUT_FILE $REPOINIT_LOGFILE $REPOSYNC_LOGFILE
    do
        if [ -f $file ]
        then
            mv $file "${file}.old"
        fi
    done

    cd $WORK_DIR

    if [ ! -d ".repo" ] 
    then
        echo ".repo not exist" 
        exit 1
    fi
}

#将结果输出到文件
function print_to_file
{
    cd ${OUTPUT_PATH}/redundant_dir/
    TMPFILE_LIST=`ls -A`
    for FILE in $TMPFILE_LIST
    do
        echo ${FILE//\./\/} >>$OUTPUT_FILE
        #echo $FILE |sed 's/\./\//g' >> $OUTPUT_PATH
        cat $FILE >> $OUTPUT_FILE
    done
    cd -
    #delete all tmpfiles
    rm -rf ${OUTPUT_PATH}/redundant_dir/
}

function main
{
    checkOptions
    #get all available branch
    #ALL_BRANCH=$(cd .repo/manifests/;git branch -r |grep '^ *origin' |egrep -v 'android|gradle|tools|webview|studio|bak|dev|publish|bsp|\/jb|\/kitkat|stable|\/ics|\/idea|\/master|monthly|_mp|adt|\/ub|temp|CTA|froyo|test|\/ginger|patchrom|upstreamupstream|75base20150429'|awk -F "/" '{print $2}';cd -)
    ALL_BRANCH="mx2_base mx3_base M81_base M85_base M86_base"

    for SINGLE_BRANCH in ${ALL_BRANCH}
    do
        echo "开始检索 $SINGLE_BRANCH 分支"
        #repo init -u ssh://liming1@review.rnd.meizu.com:29999/platform/manifest -b $SINGLE_BRANCH
        repo init -b $SINGLE_BRANCH  2>&1 | tee ${REPOINIT_LOGFILE}
        DEFAULT_BRANCH_NAME=`cat .repo/manifests/default.xml |head -n 15|grep default |awk -F "\"" '{print $2}'`
        DEFAULT_REMOTE_NAME=`egrep "^\ +remote" .repo/manifests/default.xml |awk -F "\"" '{print $2}'`
        #挑选出需要同步的project进行同步,忽略其他project
        NEED_SYNC_PROJECT=`egrep "revision" .repo/manifests/default.xml |grep -v default|awk -F "\"" '{print $2}'`

        repo sync $NEED_SYNC_PROJECT 2>&1 | tee ${REPOSYNC_LOGFILE}
        if [ $? != 0 ] ;then
            echo "repo sync fail"
            exit 1
        fi

        repo forall $NEED_SYNC_PROJECT -c "${OUTPUT_PATH}/find_result.sh $DEFAULT_BRANCH_NAME $DEFAULT_REMOTE_NAME $OUTPUT_PATH"
        if [ $? != 0 ]; then
            #echo "branch not exist"
            exit 1
        fi
        #repo forall $NEED_SYNC_PROJECT -p -c "[ -n "$(git branch -r|grep -w "meizu\/$DEFAULT_BRANCH_NAME")" ] && echo \"redundant branch is $DEFAULT_BRANCH_NAME\" " 
    done
    print_to_file
}
main $@
