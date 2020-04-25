#/bin/zsh

cd $(dirname $0:A)
build_dir=$(pwd)
cd sdk
for version in $(ls | grep -v -E "(upper|lower|work)")
do
    cd $build_dir/sdk/$version
    for target in $(ls)
    do
        cd $build_dir/sdk/$version/$target
        for subtarget in $(ls)
        do
            cd $build_dir/sdk/$version/$target/$subtarget/*/
            cp -rf $build_dir/package .
            make defconfig
            for package in $(ls $build_dir/package)
	    do
                make package/$package/compile V=sc -j8
            done
            mkdir -p $build_dir/bin/$version/$target/$subtarget
            cp bin/targets/*/*/packages/* $build_dir/bin/$version/$target/$subtarget/
        done
    done
done

