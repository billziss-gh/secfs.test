#!/bin/sh

desc="utime allowed when owner, or privileged, or current time and write access"

dir=`dirname $0`
. ${dir}/../misc.sh

echo "1..40"

n0=`namegen`
n1=`namegen`
n2=`namegen`

expect 0 mkdir ${n0} 0777
expect 0 chown ${n0} 65534 65534
expect 0 -u 65534 -g 65534 create ${n0}/${n1} 0464
expect 0 -u 65534 -g 65534 mkdir ${n0}/${n2} 0464
now=`${fstest} stat ${n0} mtime`
hourback=`echo $now-3600 | bc`
halfhourback=`echo $now-1800 | bc`
#
# allowed to root
#
# 5
expect 0 utime ${n0}/${n1} $hourback $halfhourback
expect $hourback stat ${n0}/${n1} atime
expect $halfhourback stat ${n0}/${n1} mtime
expect 0 utime ${n0}/${n1}
atime=`${fstest} stat ${n0}/${n1} atime`
test_check $now -le $atime
mtime=`${fstest} stat ${n0}/${n1} mtime`
test_check $now -le $mtime

expect 0 utime ${n0}/${n2} $hourback $halfhourback
expect $hourback stat ${n0}/${n2} atime
expect $halfhourback stat ${n0}/${n2} mtime
expect 0 utime ${n0}/${n2}
atime=`${fstest} stat ${n0}/${n2} atime`
test_check $now -le $atime
mtime=`${fstest} stat ${n0}/${n2} mtime`
test_check $now -le $mtime
#
# allowed to owner, though no write access
#
# 17
expect 0 -u 65534 -g 65534 utime ${n0}/${n1} $hourback $halfhourback
expect $hourback stat ${n0}/${n1} atime
expect $halfhourback stat ${n0}/${n1} mtime
expect 0 -u 65534 -g 65534 utime ${n0}/${n1}
atime=`${fstest} stat ${n0}/${n1} atime`
test_check $now -le $atime
mtime=`${fstest} stat ${n0}/${n1} mtime`
test_check $now -le $mtime

expect 0 -u 65534 -g 65534 utime ${n0}/${n2} $hourback $halfhourback
expect $hourback stat ${n0}/${n2} atime
expect $halfhourback stat ${n0}/${n2} mtime
expect 0 -u 65534 -g 65534 utime ${n0}/${n2}
atime=`${fstest} stat ${n0}/${n2} atime`
test_check $now -le $atime
mtime=`${fstest} stat ${n0}/${n2} mtime`
test_check $now -le $mtime
#
# group has access to set to current time
#
# 29
expect 0 utime ${n0}/${n1} $hourback $halfhourback
expect 0 -u 65533 -g 65534 utime ${n0}/${n1}
atime=`${fstest} stat ${n0}/${n1} atime`
test_check $now -le $atime
mtime=`${fstest} stat ${n0}/${n1} mtime`
test_check $now -le $mtime

expect 0 utime ${n0}/${n2} $hourback $halfhourback
expect 0 -u 65533 -g 65534 utime ${n0}/${n2}
atime=`${fstest} stat ${n0}/${n2} atime`
test_check $now -le $atime
mtime=`${fstest} stat ${n0}/${n2} mtime`
test_check $now -le $mtime
#
# cleanup
#
# 37
expect 0 chmod ${n0} 0755
expect 0 rmdir ${n0}/${n2}
expect 0 unlink ${n0}/${n1}
expect 0 rmdir ${n0}
