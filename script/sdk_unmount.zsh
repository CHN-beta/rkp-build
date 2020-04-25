#!/bin/bash

cd $(dirname $0)
sdks=$(ls | grep -v -E "(upper|lower|work)")

for sdk in $sdks
do
    sudo umount $sdk
    sudo umount $sdk.lower
done