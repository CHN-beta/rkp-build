#/bin/bash

url=$1
name=${1##*/}
name=${name%.tar*}

echo $name

aria2c $url
tar -xf $name.*
cd $name
git clone git@github.com:CHN-beta/xmurp-ua.git package/xmurp-ua
make defconfig
make package/xmurp-ua/compile V=sc
cp bin/targets/*/*/packages/kmod-xmurp-ua_*.ipk ../rkp-ua-32.$name.ipk

