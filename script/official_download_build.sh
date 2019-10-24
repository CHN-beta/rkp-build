#/bin/bash

cd $(dirname $0)
cd ..
mkdir -p tmp
cd tmp
echo -n "" > sdk_list.txt

# 抓取所有 SDK 下载地址
base_url=$1
echo $base_url
sub1=$(curl $base_url | grep '<tr><td class="n">' | awk '{split($0,b,'"\"\\\"\""');print b[4]}')
echo $sub1
for sub11 in $sub1
do
	sub2=$(curl $base_url$sub11 | grep '<tr><td class="n">' | awk '{split($0,b,'"\"\\\"\""');print b[4]}')
	echo $sub11$sub2
	for sub22 in $sub2
	do
		sdk=$(curl $base_url$sub11$sub22 | grep '<tr><td class="n">' | awk '{split($0,b,'"\"\\\"\""');print b[4]}' | grep openwrt-sdk)
		echo "$sub11 $sub22 $sdk $base_url$sub11$sub22$sdk" >> sdk_list.txt
	done
done

# 逐个下载，解压，编译，复制
mkdir -p sdk
mkdir -p bin
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

