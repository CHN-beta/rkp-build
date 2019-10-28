#/bin/bash

cd $(dirname $0)
cd ../../tmp

mkdir -p sdk
rm -rf sdk/*
mkdir -p bin
rm -rf bin/*
cd sdk
cp ../sdk_download.txt .
aria2c -i sdk_download.txt -j 1

mkdir ../package
git clone git@github.com:CHN-beta/xmurp-ua.git ../package/xmurp-ua

cat ../sdk_list.txt | while read line
do
	{
		sdk=$(echo $line | awk '{print $3}')
		tar -xf $sdk
	} &
	sleep 3
done
wait

