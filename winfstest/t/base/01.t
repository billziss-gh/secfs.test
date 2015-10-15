#!/usr/bin/python

from winfstest import *

name = uniqname()

expect(0, "CreateFile %s GENERIC_WRITE 0 0 CREATE_ALWAYS FILE_ATTRIBUTE_NORMAL 0" % name)
e, r = expect(0, "GetFileInformation %s" % name)
testeval('r[0]["FileAttributes"] == "0x20"')
expect(0, "CreateFile %s GENERIC_WRITE 0 0 CREATE_ALWAYS FILE_ATTRIBUTE_READONLY 0" % name)
e, r = expect(0, "GetFileInformation %s" % name)
testeval('r[0]["FileAttributes"] == "0x21"')
expect(0, "SetFileAttributes %s FILE_ATTRIBUTE_NORMAL" % name)
expect(0, "CreateFile %s GENERIC_WRITE 0 0 CREATE_ALWAYS FILE_ATTRIBUTE_SYSTEM 0" % name)
e, r = expect(0, "GetFileInformation %s" % name)
testeval('r[0]["FileAttributes"] == "0x24"')
expect(0, "SetFileAttributes %s FILE_ATTRIBUTE_NORMAL" % name)
expect(0, "CreateFile %s GENERIC_WRITE 0 0 CREATE_ALWAYS FILE_ATTRIBUTE_HIDDEN 0" % name)
e, r = expect(0, "GetFileInformation %s" % name)
testeval('r[0]["FileAttributes"] == "0x22"')
expect(0, "DeleteFile %s" % name)

testdone()
