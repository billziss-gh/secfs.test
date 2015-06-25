#!/bin/sh

desc="utime returns EACCES if Search permission is denied for one of the directories"

dir=`dirname $0`
. ${dir}/../misc.sh

echo "1..30"

n0=`namegen`
n1=`namegen`

expect 0 mkdir ${n0} 0755
expect 0 chown ${n0} 65534 65534
expect 0 -u 65534 -g 65534 create ${n0}/${n1} 0666
now=`${fstest} stat ${n0} mtime`
hourback=`echo $now-3600 | bc`
halfhourback=`echo $now-1800 | bc`
expect 0 chmod ${n0} 0676
#
# allowed for root
#
expect 0 utime ${n0}/${n1} $hourback $halfhourback
expect $hourback stat ${n0}/${n1} atime
expect $halfhourback stat ${n0}/${n1} mtime
expect 0 utime ${n0}/${n1}
atime=`${fstest} stat ${n0}/${n1} atime`
test_check $now -le $atime
mtime=`${fstest} stat ${n0}/${n1} mtime`
test_check $now -le $mtime
#
# group has directory access to set to current time
#
# 11
expect 0 utime ${n0}/${n1} $hourback $halfhourback
expect 0 -u 65533 -g 65534 utime ${n0}/${n1}
atime=`${fstest} stat ${n0}/${n1} atime`
test_check $now -le $atime
mtime=`${fstest} stat ${n0}/${n1} mtime`
test_check $now -le $mtime
#
# not allowed for owner
#
# 15
expect 0 utime ${n0}/${n1} $hourback $halfhourback
expect EACCES -u 65534 -g 65534 utime ${n0}/${n1} $now $now
expect $hourback stat ${n0}/${n1} atime
expect $halfhourback stat ${n0}/${n1} mtime
expect EACCES -u 65534 -g 65534 utime ${n0}/${n1}
expect $hourback stat ${n0}/${n1} atime
expect $halfhourback stat ${n0}/${n1} mtime
#
# not allowed for another user,
# - either not current time, though group access
# - or current time, though write access to file
#
# 22
expect 'EACCES|EPERM' -u 65533 -g 65534 utime ${n0}/${n1} $now $now
expect $hourback stat ${n0}/${n1} atime
expect $halfhourback stat ${n0}/${n1} mtime
expect EACCES -u 65533 -g 65533 utime ${n0}/${n1}
expect $hourback stat ${n0}/${n1} atime
expect $halfhourback stat ${n0}/${n1} mtime
#
# delete
#
# 28
expect 0 chmod ${n0} 0755
expect 0 unlink ${n0}/${n1}
expect 0 rmdir ${n0}
