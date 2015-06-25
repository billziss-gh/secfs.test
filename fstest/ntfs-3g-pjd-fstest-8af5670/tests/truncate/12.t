#!/bin/sh
# $FreeBSD: src/tools/regression/fstest/tests/truncate/12.t,v 1.1 2007/01/17 01:42:12 pjd Exp $

desc="truncate returns EFBIG or EINVAL if the length argument was greater than the maximum file size"

dir=`dirname $0`
. ${dir}/../misc.sh

case "${os}:${fs}" in
Darwin:HFS+)
    # This test makes the filesystem unusable on OS X 10.10; so disable it!
    quick_exit
    ;;
*)
    echo "1..3"

    n0=`namegen`

    expect 0 create ${n0} 0644
    r=`${fstest} truncate ${n0} 999999999999999 2>/dev/null`
    case "${r}" in
    EFBIG|EINVAL|ENOSPC)
    	expect 0 stat ${n0} size
    	;;
    0)
    	expect 999999999999999 stat ${n0} size
    	;;
    *)
    	echo "not ok ${ntest}"
    	ntest=`expr ${ntest} + 1`
    	;;
    esac
    expect 0 unlink ${n0}
esac
