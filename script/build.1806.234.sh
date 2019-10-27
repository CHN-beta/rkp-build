#/bin/bash

cd $(dirname $0)
cd ../tmp

# 逐个下载，解压，编译，复制
mkdir -p sdk
rm -rf sdk/*
mkdir -p bin
rm -rf bin/*
cd sdk
cat ../sdk_list.txt | while read line
do
	sub1=$(echo $line | awk '{print $1}')
	sub2=$(echo $line | awk '{print $2}')
	sdk=$(echo $line | awk '{print $3}')
	url=$(echo $line | awk '{print $4}')
	aria2c $url
	tar -xf $sdk
	cd ${sdk%.tar*}
	git clone git@github.com:CHN-beta/xmurp-ua.git package/xmurp-ua
	make defconfig
	make package/xmurp-ua/compile
	mkdir -p ../../bin/$sub1$sub2
	cp bin/targets/*/*/packages/kmod-xmurp-ua_*.ipk ../../bin/$sub1$sub2
	cd ..
done

