#!/usr/bin/python

from winfstest import *

name = uniqname()

expect(0, "CreateFile %s GENERIC_WRITE 0 0 CREATE_ALWAYS FILE_ATTRIBUTE_NORMAL 0" % name)
e, r = expect(0, "GetFileInformation %s" % name)
print r[0]
btime = r[0]["CreationTime"]
atime = r[0]["LastAccessTime"]
mtime = r[0]["LastWriteTime"]
expect(0, "SetFileTime %s 2134 2134-10-11T12:34:56 0" % name)
e, r = expect(0, "GetFileInformation %s" % name)
print r[0]
testeval('"2134-01-01T00:00:00Z" == r[0]["CreationTime"]')
testeval('"2134-10-11T12:34:56Z" == r[0]["LastAccessTime"]')
testeval('mtime == r[0]["LastWriteTime"]')
expect(0, "DeleteFile %s" % name)

testdone()
