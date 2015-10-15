#!/usr/bin/python

from winfstest import *

name = uniqname()

expect(0, "CreateFile %s GENERIC_WRITE 0 0 CREATE_ALWAYS FILE_ATTRIBUTE_NORMAL 0" % name)
e, r = expect(0, "GetFileInformation %s" % name)
testeval('r[0]["FileSize"] == 0')
expect(0, "SetEndOfFile %s 42" % name)
e, r = expect(0, "GetFileInformation %s" % name)
testeval('r[0]["FileSize"] == 42')
expect(0, "SetEndOfFile %s 13" % name)
e, r = expect(0, "GetFileInformation %s" % name)
testeval('r[0]["FileSize"] == 13')
expect(0, "DeleteFile %s" % name)

testdone()
