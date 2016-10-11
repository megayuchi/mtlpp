#!/bin/bash -ex

cd "$(dirname "${BASH_SOURCE[0]}")"

build_mac()
{
    local ver=$1
    local output="../.build/macos_$ver"
    local objcflags="-std=c++11 -x objective-c++ -mmacosx-version-min=$ver"
    local cppflags="-std=c++11 -mmacosx-version-min=$ver"
    local ldflags="-framework Metal -framework CoreFoundation -fobjc-link-runtime"

    rm -Rf $output
    mkdir -p $output

    clang++ $objcflags -c ../mtlpp.mm -o $output/mtlpp.o

    clang++ $cppflags $ldflags ../examples/00_init.cpp $output/mtlpp.o -o $output/00_init
    clang++ $cppflags $ldflags ../examples/01_clear.cpp $output/mtlpp.o -o $output/01_clear
    clang++ $cppflags $ldflags ../examples/02_triangle.cpp $output/mtlpp.o -o $output/02_triangle
}

build_ios()
{
    local ver=$1
    local arch="$2"
    local output="../.build/ios_${ver}_${arch}"
    local sdk="--sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk"
    local objcflags="-std=c++11 -x objective-c++ -miphoneos-version-min=$ver $sdk -arch $arch"
    local cflags="-std=c++11 -miphoneos-version-min=$ver $sdk -arch $arch"
    local ldflags="-framework Metal -framework CoreFoundation -fobjc-link-runtime"
    local cc="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++"

    rm -Rf $output
    mkdir -p $output

    $cc $objcflags -c ../mtlpp.mm -o $output/mtlpp.o

    $cc $cflags $ldflags ../examples/00_init.cpp $output/mtlpp.o -o $output/00_init
    $cc $cflags $ldflags ../examples/01_clear.cpp $output/mtlpp.o -o $output/01_clear
    $cc $cflags $ldflags ../examples/02_triangle.cpp $output/mtlpp.o -o $output/02_triangle
}

if [[ "$arch" == "arm" ]]; then
    build_ios 7.0 armv7
    build_ios 8.0 armv7
    build_ios 9.0 armv7
    build_ios 10.0 armv7

    build_ios 7.0 armv7s
    build_ios 8.0 armv7s
    build_ios 9.0 armv7s
    build_ios 10.0 armv7s

    build_ios 7.0 arm64
    build_ios 8.0 arm64
    build_ios 9.0 arm64
    build_ios 10.0 arm64
else
    build_mac 10.9
    build_mac 10.10
    build_mac 10.11
    build_mac 10.12
fi

