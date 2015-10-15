#!/usr/bin/python

from winfstest import *

name = uniqname()

expect(0, "CreateDirectory %s 0" % name)
expect("ERROR_ALREADY_EXISTS", "CreateDirectory %s 0" % name)
e, r = expect(0, "GetFileInformation %s" % name)
testeval('r[0]["FileAttributes"] == "0x10"')
expect("ERROR_ACCESS_DENIED", "DeleteFile %s" % name)
expect(0, "RemoveDirectory %s" % name)

testdone()
