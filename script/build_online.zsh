#/bin/zsh

build() {
    # args: version target subtarget sdk url dir

    version=$1
    target=$2
    subtarget=$3
    sdk=$4
    url=$5
    dir=$6
    echo "version=$version target=$target subtarget=$subtarget sdk=$sdk url=$url dir=$dir"

    # download and prepare
    cd "$dir"
    echo "here we go" >> build.log
    echo $@ >> build.log
    curl -O --retry 99 $url
    tar -xvf $sdk.tar.xz
    cd $sdk
    git clone https://github.com/CHN-beta/xmurp-ua.git package/xmurp-ua
    git clone https://github.com/CHN-beta/rkp-ipid.git package/rkp-ipid

    # compile
    make defconfig >> ../build.log 2>&1 
    make package/xmurp-ua/compile V=sc >> ../build.log 2>&1
    make package/rkp-ipid/compile V=sc >> ../build.log 2>&1

    # copy and clean
    mkdir -p ../bin/$version/$target/$subtarget
    cp bin/targets/*/*/packages/* ../bin/$version/$target/$subtarget
    cd "$dir"
    rm -rf $sdk*
}

dir=$(pwd)
cat list.txt | while read line
do
    build $(echo $line) "$dir"
done
