#/bin/bash

cd $(dirname $0)
cd ../../tmp/sdk

# 逐个编译，复制
cat ../sdk_list.txt | while read line
do
	sub1=$(echo $line | awk '{print $1}')
	sub2=$(echo $line | awk '{print $2}')
	sdk=$(echo $line | awk '{print $3}')
	url=$(echo $line | awk '{print $4}')
	cd ${sdk%.tar*}
	cp -rf ../../package/xmurp-ua package/xmurp-ua
	make defconfig

	ARCH=$(ls build_dir)
	ARCH=${ARCH%%_*}
	ARCH=${ARCH#*-}

	CROSS_COMPILE=$(pwd)/staging_dir/$(ls staging_dir | grep toolchain)/bin/$(ls staging_dir/toolchain-* | grep 'openwrt-linux$')-

	echo "$ARCH $CROSS_COMPILE"
	make package/xmurp-ua/compile ARCH=$ARCH CROSS_COMPILE=$CROSS_COMPILE V=sc
	mkdir -p ../../bin/$sub1$sub2
	cp bin/targets/*/*/packages/kmod-xmurp-ua_*.ipk ../../bin/$sub1$sub2
	cd ..
done

