#!/bin/sh

desc="utime returns EPERM when setting non-current time by non-owner"

dir=`dirname $0`
. ${dir}/../misc.sh

echo "1..13"

n0=`namegen`
n1=`namegen`

expect 0 mkdir ${n0} 0777
expect 0 chown ${n0} 65534 65534
expect 0 -u 65534 -g 65534 create ${n0}/${n1} 0755
now=`${fstest} stat ${n0} mtime`
hourback=`echo $now-3600 | bc`
halfhourback=`echo $now-1800 | bc`
expect 0 utime ${n0}/${n1} $hourback $halfhourback
#
# not allowed for another user
#
# 5
expect EPERM -u 65533 -g 65533 utime ${n0}/${n1} $now $now
expect $hourback stat ${n0}/${n1} atime
expect $halfhourback stat ${n0}/${n1} mtime
expect EPERM -u 65533 -g 65534 utime ${n0}/${n1} $now $now
expect $hourback stat ${n0}/${n1} atime
expect $halfhourback stat ${n0}/${n1} mtime
#
# delete
#
# 11
expect 0 chmod ${n0} 0755
expect 0 unlink ${n0}/${n1}
expect 0 rmdir ${n0}
