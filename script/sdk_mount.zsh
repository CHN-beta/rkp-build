#!/bin/zsh

cd $(dirname $0:A)
mkdir sdk
cd sdk

for img in $(ls ../../sdk)
do
    sdk=$(echo $img | sed 's/\(.*\)\.img/\1/g')
    mkdir $sdk
    mkdir $sdk.upper
    mkdir $sdk.lower
    mkdir $sdk.work
    sudo mount -o ro ../../sdk/$sdk.img $sdk.lower
    sudo mount -t overlay overlay -o upperdir=$sdk.upper,lowerdir=$sdk.lower,workdir=$sdk.work $sdk
done
