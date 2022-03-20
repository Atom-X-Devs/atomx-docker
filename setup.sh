#!/bin/bash

apt-get dist-upgrade -y -qq && apt-get upgrade -y -qq && apt-get update -y -qq
ln -snf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime && echo Asia/Kolkata > /etc/timezone
apt-get install --no-install-recommends -y -qq aria2 bc bison ca-certificates cpio curl file gcc git lib{c6,c,ssl,xml2}-dev make python2 unzip zip
apt-get autoremove -y && apt-get clean autoclean && rm -rf /var/lib/apt/lists/*

t2h() {
    echo "$1" | od -An -tx1 | tr -d '\n' | head -n1 | sed "s/ 0a$//g;s/ /\\\x/g"
}

rep() {
    LANG=C grep -robUaPHn "$(t2h '$1')" -l | while read -r f; do
        echo "${f}:${1}->${2}" && sed -i "s|$(t2h "$1")|$(t2h "$2")|g" "$f"
    done
}

rem() {
    cd /usr/"$1" && while read -r line; do rm -rfv "$line"; done < "/remove-$(echo "$1" | sed "s/32//g;s/64//g").txt" && cd /
}

get() {
    curl -LSs  "https://codeload.github.com/$1/zip/$2" -o "$3".zip
    unzip "$3".zip -d. && rm "$3".zip && mv -v "${1##*/}-$2" "/usr/${3}"
    find "/usr/${3}" -exec chmod +x {} \; && rm -rfv "/usr/${3}/.git"
    rem "$3"
}

get_llvm() {
    SRC=https://raw.githubusercontent.com/mvaisakh
    [[ $1 =~ '32' ]] && VSN='' || VSN=64
    [[ $3 != '' ]] && SHA="$3" || SHA="gcc-master"
    curl -LSs "$SRC/gcc-arm${VSN}/${SHA}/bin/lld" -o "$2/lld" && chmod +x "$2/lld"
    curl -LSs "$SRC/gcc-arm${VSN}/${SHA}/bin/llvm-ar" -o "$2/llvm-ar" && chmod +x "$2/llvm-ar"
    curl -LSs "$SRC/gcc-arm${VSN}/${SHA}/bin/llvm-as" -o "$2/llvm-as" && chmod +x "$2/llvm-as"
    curl -LSs "$SRC/gcc-arm${VSN}/${SHA}/bin/llvm-nm" -o "$2/llvm-nm" && chmod +x "$2/llvm-nm"
    curl -LSs "$SRC/gcc-arm${VSN}/${SHA}/bin/llvm-objdump" -o "$2/llvm-objdump" && chmod +x "$2/llvm-objdump"
    curl -LSs "$SRC/gcc-arm${VSN}/${SHA}/bin/llvm-objcopy" -o "$2/llvm-objcopy" && chmod +x "$2/llvm-objcopy"
    curl -LSs "$SRC/gcc-arm${VSN}/${SHA}/bin/llvm-readobj" -o "$2/llvm-readobj" && chmod +x "$2/llvm-readobj"
    ln -sv "$(realpath "$2/lld")" "$(realpath "$2")/ld.lld"
    ln -sv "$(realpath "$2/llvm-readobj")" "$(realpath "$2")/llvm-readelf"
    ln -sv "$(realpath "$2/llvm-objcopy")" "$(realpath "$2")/llvm-strip"
}

get_binutils() {
    SRC=https://raw.githubusercontent.com/mvaisakh
    if [[ $1 =~ '32' ]];then  VSN='' && PFX='arm-eabi'; else VSN=64 && PFX='aarch64-elf'; fi
    [[ $3 != '' ]] && SHA="$3" || SHA="gcc-master"
    [[ $4 != '' ]] && PFX_OVER="$4" || PFX_OVER="$PFX-"
    curl -LSs "$SRC/gcc-arm${VSN}/${SHA}/bin/${PFX}-ar" -o "$2/${PFX_OVER}ar" && chmod +x "$2/${PFX_OVER}ar"
    curl -LSs "$SRC/gcc-arm${VSN}/${SHA}/bin/${PFX}-as" -o "$2/${PFX_OVER}as" && chmod +x "$2/${PFX_OVER}as"
    curl -LSs "$SRC/gcc-arm${VSN}/${SHA}/bin/${PFX}-nm" -o "$2/${PFX_OVER}nm" && chmod +x "$2/${PFX_OVER}ld"
    curl -LSs "$SRC/gcc-arm${VSN}/${SHA}/bin/${PFX}-nm" -o "$2/${PFX_OVER}nm" && chmod +x "$2/${PFX_OVER}nm"
    curl -LSs "$SRC/gcc-arm${VSN}/${SHA}/bin/${PFX}-readelf" -o "$2/${PFX_OVER}elfedit" && chmod +x "$2/${PFX_OVER}elfedit"
    curl -LSs "$SRC/gcc-arm${VSN}/${SHA}/bin/${PFX}-objdump" -o "$2/${PFX_OVER}objdump" && chmod +x "$2/${PFX_OVER}objdump"
    curl -LSs "$SRC/gcc-arm${VSN}/${SHA}/bin/${PFX}-objcopy" -o "$2/${PFX_OVER}objcopy" && chmod +x "$2/${PFX_OVER}objcopy"
    curl -LSs "$SRC/gcc-arm${VSN}/${SHA}/bin/${PFX}-readelf" -o "$2/${PFX_OVER}readelf" && chmod +x "$2/${PFX_OVER}readelf"
    curl -LSs "$SRC/gcc-arm${VSN}/${SHA}/bin/${PFX}-strip" -o "$2/${PFX_OVER}strip" && chmod +x "$2/${PFX_OVER}strip"
}

get XSans02/Weeb-Clang main clang
get mvaisakh/gcc-arm64 gcc-master gcc64
get mvaisakh/gcc-arm gcc-master gcc32

cd /usr/clang && rep 'Weeb' 'Zero' && rep 'github.com/llvm/llvm-project' 'youtu.be/watch?v=dQw4w9WgXcQ' && cd /

# get_llvm 64 /usr/clang/bin 6595077c606eb70344f85259630db7964f6fc5fc # 20220208
# get_binutils 64 /usr/gcc64/bin 6595077c606eb70344f85259630db7964f6fc5fc # 20220208
# get_binutils 32 /usr/gcc32/bin cf08471c4ff7285db1532076c8bce1e13174ff7d # 20220208

ln -sv /usr/clang/bin/llvm-* /usr/gcc64/bin
ln -sv /usr/clang/bin/lld /usr/gcc64/bin
ln -sv /usr/clang/bin/ld.lld /usr/gcc64/bin

chmod +x strip.sh && /strip.sh / && rm -rfv strip.sh ./*.txt