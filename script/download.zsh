#/bin/zsh

download() {
    # args: version target subtarget sdk url dir

    version=$1
    target=$2
    subtarget=$3
    sdk=$4
    url=$5
    dir=$6
    echo "version=$version target=$target subtarget=$subtarget sdk=$sdk url=$url dir=$dir"
    
    cd "$dir"
    if [ ! -d sdk/$version/$target/$subtarget/$sdk ]
    then
        mkdir -p sdk/$version/$target/$subtarget
        cd sdk/$version/$target/$subtarget
        curl -O --retry 99 $url
        tar -xvf $sdk.tar.xz
        rm -rf $sdk.tar.gz
    fi
}

dir=$(pwd)
cat list.txt | while read line
do
    download $(echo $line) "$dir"
done
