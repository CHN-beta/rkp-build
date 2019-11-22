#/bin/bash

echo -n "" > sdk_list.txt
echo -n "" > sdk_download.txt

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
		echo $base_url$sub11$sub22$sdk >> sdk_download.txt
	done
done


