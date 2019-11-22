#/bin/bash

cd $1

rm -rf package
mkdir package
cd package
git clone git@github.com:CHN-beta/xmurp-ua.git
git clone git@github.com:CHN-beta/rkp-ipid.git
cd ..

# 逐个编译，复制
cat sdk_list.txt | while read line
do
	sub1=$(echo $line | awk '{print $1}')
	sub2=$(echo $line | awk '{print $2}')
	sdk=$(echo $line | awk '{print $3}')
	cd ${sdk%.tar*}
	cp -rf ../package/* package/
	make defconfig
	make package/xmurp-ua/compile
	make package/rkp-ipid/compile
	mkdir -p ../bin/$sub1$sub2
	cp bin/targets/*/*/packages/kmod-*.ipk ../bin/$sub1$sub2
	cd ..
done

