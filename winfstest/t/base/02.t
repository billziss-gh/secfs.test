#!/usr/bin/python

from winfstest import *

expect(0, "CreateDirectory foo 0")
e, r = expect(0, "GetFileInformation foo")
testeval('r[0]["FileAttributes"] == "0x10"')
expect("ERROR_ACCESS_DENIED", "DeleteFile foo")
expect(0, "RemoveDirectory foo")

testdone()
