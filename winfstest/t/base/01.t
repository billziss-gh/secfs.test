#!/usr/bin/python

from winfstest import *

expect(0, "CreateFile foo GENERIC_WRITE 0 0 CREATE_ALWAYS FILE_ATTRIBUTE_NORMAL 0")
e, r = expect(0, "GetFileInformation foo")
testeval('r[0]["FileAttributes"] == "0x20"')
expect(0, "CreateFile foo GENERIC_WRITE 0 0 CREATE_ALWAYS FILE_ATTRIBUTE_READONLY 0")
e, r = expect(0, "GetFileInformation foo")
testeval('r[0]["FileAttributes"] == "0x21"')
expect(0, "SetFileAttributes foo FILE_ATTRIBUTE_NORMAL")
expect(0, "CreateFile foo GENERIC_WRITE 0 0 CREATE_ALWAYS FILE_ATTRIBUTE_SYSTEM 0")
e, r = expect(0, "GetFileInformation foo")
testeval('r[0]["FileAttributes"] == "0x24"')
expect(0, "SetFileAttributes foo FILE_ATTRIBUTE_NORMAL")
expect(0, "CreateFile foo GENERIC_WRITE 0 0 CREATE_ALWAYS FILE_ATTRIBUTE_HIDDEN 0")
e, r = expect(0, "GetFileInformation foo")
testeval('r[0]["FileAttributes"] == "0x22"')
expect(0, "DeleteFile foo")

testdone()
