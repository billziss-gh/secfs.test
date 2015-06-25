#!/bin/sh

desc="Darwin resource fork basic testing"

dir=`dirname $0`
. ${dir}/../misc.sh

case "${os}" in
Darwin)
    echo "1..2"

    n0=`namegen`
    n1=`namegen`

    dd if=/dev/urandom of="${n0}" bs=1k count=1024 >/dev/null 2>&1
    cp /dev/null "${n1}" 
    cp -X "${n0}" "${n1}"/..namedfork/rsrc
    test_check $? -eq 0
    cmp "${n0}" "${n1}"/..namedfork/rsrc
    test_check $? -eq 0
    rm "${n0}" "${n1}"
    ;;
*)
    quick_exit
    ;;
esac

