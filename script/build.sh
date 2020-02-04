#/bin/bash

cat list.txt | while read line
do
    # 读取参数
    echo "building $line" | tee -a status.log
    version=$(echo $line | awk '{print $1}')
    target=$(echo $line | awk '{print $2}')
    subtarget=$(echo $line | awk '{print $3}')
    sdk=$(echo $line | awk '{print $4}')
    url=$(echo $line | awk '{print $5}')
    
    # 准备 SDK 和源代码
    curl -sO --retry 99 $url
    tar -xf $sdk.tar.xz
    cd $sdk
    git clone -q https://github.com/CHN-beta/xmurp-ua.git package/xmurp-ua

    # 编译
	echo $line >> ../compile.log
    make defconfig >> ../compile.log 2>&1
    make package/xmurp-ua/compile V=sc >> ../compile.log 2>&1

    # 整理，清理
    mkdir -p ../bin/$version
    cp -r bin/targets/* ../bin/$version/
    cd ..
    rm -rf $sdk*
done
