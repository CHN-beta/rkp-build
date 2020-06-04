#!/bin/zsh

cd $(dirname $0:A)
mkdir sdk
cd sdk

if [ -n "$@" ]
then
    sdks="$@"
else
    sdks=$(ls ../../sdk | sed 's/\(.*\)\.img/\1/g')
fi

for sdk in $sdks
do
    mkdir $sdk
    mkdir $sdk.upper
    mkdir $sdk.lower
    mkdir $sdk.work
    sudo mount -o ro ../../sdk/$sdk.img $sdk.lower
    sudo mount -t overlay overlay -o upperdir=$sdk.upper,lowerdir=$sdk.lower,workdir=$sdk.work $sdk
done
