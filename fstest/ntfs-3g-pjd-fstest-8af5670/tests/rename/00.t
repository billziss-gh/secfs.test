#!/bin/sh
# $FreeBSD: src/tools/regression/fstest/tests/rename/00.t,v 1.1 2007/01/17 01:42:10 pjd Exp $

desc="rename changes file name"

dir=`dirname $0`
. ${dir}/../misc.sh

echo "1..79"

n0=`namegen`
n1=`namegen`
n2=`namegen`
n3=`namegen`

expect 0 mkdir ${n3} 0755
cdir=`pwd`
cd ${n3}

expect 0 create ${n0} 0644
expect regular,0644,1 lstat ${n0} type,mode,nlink
inode=`${fstest} lstat ${n0} inode`
expect 0 rename ${n0} ${n1}
expect ENOENT lstat ${n0} type,mode,nlink
expect regular,${inode},0644,1 lstat ${n1} type,inode,mode,nlink
expect 0 link ${n1} ${n0}
expect regular,${inode},0644,2 lstat ${n0} type,inode,mode,nlink
expect regular,${inode},0644,2 lstat ${n1} type,inode,mode,nlink
expect 0 rename ${n1} ${n2}
expect regular,${inode},0644,2 lstat ${n0} type,inode,mode,nlink
expect ENOENT lstat ${n1} type,mode,nlink
expect regular,${inode},0644,2 lstat ${n2} type,inode,mode,nlink
expect 0 unlink ${n0}
expect 0 unlink ${n2}

expect 0 mkdir ${n0} 0755
expect dir,0755 lstat ${n0} type,mode
inode=`${fstest} lstat ${n0} inode`
expect 0 rename ${n0} ${n1}
expect ENOENT lstat ${n0} type,mode
expect dir,${inode},0755 lstat ${n1} type,inode,mode
expect 0 rmdir ${n1}

expect 0 mkfifo ${n0} 0644
expect fifo,0644,1 lstat ${n0} type,mode,nlink
inode=`${fstest} lstat ${n0} inode`
expect 0 rename ${n0} ${n1}
expect ENOENT lstat ${n0} type,mode,nlink
expect fifo,${inode},0644,1 lstat ${n1} type,inode,mode,nlink
expect 0 link ${n1} ${n0}
expect fifo,${inode},0644,2 lstat ${n0} type,inode,mode,nlink
expect fifo,${inode},0644,2 lstat ${n1} type,inode,mode,nlink
expect 0 rename ${n1} ${n2}
expect fifo,${inode},0644,2 lstat ${n0} type,inode,mode,nlink
expect ENOENT lstat ${n1} type,mode,nlink
expect fifo,${inode},0644,2 lstat ${n2} type,inode,mode,nlink
expect 0 unlink ${n0}
expect 0 unlink ${n2}

expect 0 create ${n0} 0644
rinode=`${fstest} lstat ${n0} inode`
expect regular,0644 lstat ${n0} type,mode
expect 0 symlink ${n0} ${n1}
sinode=`${fstest} lstat ${n1} inode`
expect regular,${rinode},0644 stat ${n1} type,inode,mode
expect symlink,${sinode} lstat ${n1} type,inode
expect 0 rename ${n1} ${n2}
expect regular,${rinode},0644 stat ${n0} type,inode,mode
expect ENOENT lstat ${n1} type,mode
expect symlink,${sinode} lstat ${n2} type,inode
expect 0 unlink ${n0}
expect 0 unlink ${n2}

# successful rename(2) updates ctime.
expect 0 create ${n0} 0644
ctime1=`${fstest} stat ${n0} ctime`
sleep 1
expect 0 rename ${n0} ${n1}
ctime2=`${fstest} stat ${n1} ctime`
case "${os}:${fs}" in
Darwin:*|*:secfs)
    # This test wants ctime of a renamed file to be updated, but POSIX does not require it
    # and Darwin (and secfs) do not update it!
    #
    # Here is the POSIX note found at:
    # http://pubs.opengroup.org/onlinepubs/9699919799/functions/rename.html
    # <<
    # Some implementations mark for update the last file status change timestamp of renamed files
    # and some do not. Applications which make use of the last file status change timestamp may
    # behave differently with respect to renamed files unless they are designed to allow for
    # either behavior.
    #>>
    test_check $ctime1 -le $ctime2
    ;;
*)
    test_check $ctime1 -lt $ctime2
    ;;
esac
expect 0 unlink ${n1}

expect 0 mkdir ${n0} 0755
ctime1=`${fstest} stat ${n0} ctime`
sleep 1
expect 0 rename ${n0} ${n1}
ctime2=`${fstest} stat ${n1} ctime`
case "${os}:${fs}" in
Darwin:*|*:secfs)
    # This test wants ctime of a renamed file to be updated, but POSIX does not require it
    # and Darwin (and secfs) do not update it!
    #
    # See comments above on POSIX note.
    test_check $ctime1 -le $ctime2
    ;;
*)
    test_check $ctime1 -lt $ctime2
    ;;
esac
expect 0 rmdir ${n1}

expect 0 mkfifo ${n0} 0644
ctime1=`${fstest} stat ${n0} ctime`
sleep 1
expect 0 rename ${n0} ${n1}
ctime2=`${fstest} stat ${n1} ctime`
case "${os}:${fs}" in
Darwin:*|*:secfs)
    # This test wants ctime of a renamed file to be updated, but POSIX does not require it
    # and Darwin (and secfs) do not update it!
    #
    # See comments above on POSIX note.
    test_check $ctime1 -le $ctime2
    ;;
*)
    test_check $ctime1 -lt $ctime2
    ;;
esac
expect 0 unlink ${n1}

expect 0 symlink ${n2} ${n0}
ctime1=`${fstest} lstat ${n0} ctime`
sleep 1
expect 0 rename ${n0} ${n1}
ctime2=`${fstest} lstat ${n1} ctime`
case "${os}:${fs}" in
Darwin:*|*:secfs)
    # This test wants ctime of a renamed file to be updated, but POSIX does not require it
    # and Darwin (and secfs) do not update it!
    #
    # See comments above on POSIX note.
    test_check $ctime1 -le $ctime2
    ;;
*)
    test_check $ctime1 -lt $ctime2
    ;;
esac
expect 0 unlink ${n1}

# unsuccessful link(2) does not update ctime.
expect 0 create ${n0} 0644
ctime1=`${fstest} stat ${n0} ctime`
sleep 1
expect EACCES -u 65534 rename ${n0} ${n1}
ctime2=`${fstest} stat ${n0} ctime`
test_check $ctime1 -eq $ctime2
expect 0 unlink ${n0}

expect 0 mkdir ${n0} 0755
ctime1=`${fstest} stat ${n0} ctime`
sleep 1
expect EACCES -u 65534 rename ${n0} ${n1}
ctime2=`${fstest} stat ${n0} ctime`
test_check $ctime1 -eq $ctime2
expect 0 rmdir ${n0}

expect 0 mkfifo ${n0} 0644
ctime1=`${fstest} stat ${n0} ctime`
sleep 1
expect EACCES -u 65534 rename ${n0} ${n1}
ctime2=`${fstest} stat ${n0} ctime`
test_check $ctime1 -eq $ctime2
expect 0 unlink ${n0}

expect 0 symlink ${n2} ${n0}
ctime1=`${fstest} lstat ${n0} ctime`
sleep 1
expect EACCES -u 65534 rename ${n0} ${n1}
ctime2=`${fstest} lstat ${n0} ctime`
test_check $ctime1 -eq $ctime2
expect 0 unlink ${n0}

cd ${cdir}
expect 0 rmdir ${n3}
