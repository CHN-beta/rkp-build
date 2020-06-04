#!/bin/zsh

cd $(dirname $0:A)/sdk
sdks=$(ls | grep -v -E "(upper|lower|work)")

for sdk in $(echo $sdks)
do
    sudo umount $sdk
    sudo umount $sdk.lower
done

cd ..
rm -rf sdk
