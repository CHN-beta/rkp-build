#!/bin/bash

rm -f list.txt
touch list.txt

base_url="https://downloads.openwrt.org/releases/"
echo "base_url=$base_url"

# 抓取所有系统版本
versions=$(curl -s $base_url | grep '<tr><td class="n">' | awk '{split($0,b,'"\"\\\"\""');print b[4]}' | grep -v faillogs | grep -v packages)
versions=${versions//\// }
versions=$(echo $versions | xargs echo)
echo -e " versions: $versions"

for version in $versions
do
    targets=$(curl -s $base_url$version/targets/ | grep '<tr><td class="n">' | awk '{split($0,b,'"\"\\\"\""');print b[4]}')
    targets=${targets//\// }
    targets=$(echo $targets | xargs echo)
    echo "  targets: $targets"
    for target in $targets
    do
        subtargets=$(curl -s $base_url$version/targets/$target/ | grep '<tr><td class="n">' | awk '{split($0,b,'"\"\\\"\""');print b[4]}')
        subtargets=${subtargets//\// }
        subtargets=$(echo $subtargets | xargs echo)
        echo "   subtargets: $subtargets"
        for subtarget in $subtargets
        do
            sdk=$(curl -s $base_url$version/targets/$target/$subtarget/ | grep '<tr><td class="n">' | awk '{split($0,b,'"\"\\\"\""');print b[4]}' | grep tar.xz | grep sdk)
            sdk=${sdk%.tar.xz}
            echo "    sdk: $sdk"
            echo "$version $target $subtarget $sdk $base_url$version/targets/$target/$subtarget/$sdk.tar.xz" >> list.txt
        done
    done
done
