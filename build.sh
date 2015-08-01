#!/bin/sh

while getopts "s:f:t:e:c:h" opt
do
    case $opt in
    s )
        src=$OPTARG;
        if [ ! -d $src ]; then
            echo "Invalid source directory ($src)";
            exit;
        fi;;
    f )
        frame=$OPTARG;
        if [ ! -d $frame ]; then
            echo "Invalid framework directory ($frame)";
            exit;
        fi;;
    t )
        target=$OPTARG;
        if [ ! -d $target ]; then
            echo "Invalid target directory ($target)";
            exit;
        fi;;
    e )
        entry=$OPTARG;;
    c )
        config=$OPTARG;;
    h )
        echo "-s <path>\t source directory.";
        echo "-f <path>\t framework directory.";
        echo "-t <path>\t target directory.";
        echo "-e <filename>\t entry filename.";
        echo "-c <filename>\t config filename.";
        exit;;
    ? )
        echo "undefined parameter.";
        echo "-s <path>\t source directory.";
        echo "-f <path>\t framework directory.";
        echo "-t <path>\t target directory.";
        echo "-e <filename>\t entry filename.";
        echo "-c <filename>\t config filename.";
        exit;;
    esac
done

if [ -z $src ]; then
    echo "Invalid source directory (empty)";
    exit;
fi
if [ -z $target ]; then
    echo "Invalid target directory (empty)";
    exit;
fi
if [ -z $frame ]; then
    echo "Invalid framework directory (empty)";
    exit;
fi
if [ ! -e "$src/$entry" ]; then
    echo "Cannot found entry file in $src";
    exit;
fi
if [ ! -e "$config" ]; then
    echo "Cannot found config file $config";
    exit;
fi

##删除target文件夹下面的文件
for dir in $(ls -l $src|awk '{print $9}'); do
    if [ -d $target/$dir ]; then
        rm -rf $target/$dir;
    fi
    if [ -e $target/$dir ]; then
        rm $target/$dir;
    fi
done

if [ -d $target/framework ]; then
    rm -rf $target/framework;
fi

##拷贝src文件至target
cp -r $src $target;
cp -r $frame $target;

##删除.git与.idea
for dir in $(find $target -name ".git" -o -name ".idea"); do
    rm -rf $dir;
done

##删除runtime
if [ -d $target/protected/runtime ]; then
    rm -rf $target/protected/runtime;
fi

##入口文件替换
if [ ! -z $entry ]; then
    mv "$target/$entry" "$target/index.php";
fi

##配置文件替换
if [ ! -z $config ]; then
    cp "$config" "$target/protected/config/main.php";
fi




