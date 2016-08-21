#!/usr/bin/python

# symbolic links (files)

from winfstest import *

def safeopen(name, mode = "r"):
    try:
        return open(name, mode)
    except:
        return None

srcname, dstname = uniqname(), uniqname()

e, r = expect("CreateSymbolicLink %s %s 0" % (srcname, dstname), 0)
if e == "0":
    expect("GetFileInformation %s" % srcname, lambda r: r[0]["FileAttributes"] == 0x420)
    expect("GetReparsePoint %s" % srcname, lambda r:\
        r[0]["ReparseTag"] == "IO_REPARSE_TAG_SYMLINK" and \
        r[0]["SubstituteName"] == dstname and \
        r[0]["PrintName"] == dstname)
    testeval(not safeopen(srcname))
    expect("CreateFile %s GENERIC_WRITE 0 0 CREATE_NEW FILE_ATTRIBUTE_NORMAL 0" % dstname, 0)
    testeval(safeopen(srcname))
    expect("DeleteFile %s" % dstname, 0)
    testeval(not safeopen(srcname))
    expect("DeleteFile %s" % srcname, 0)

testdone()
