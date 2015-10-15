#!/usr/bin/python

from winfstest import *

name = uniqname()

expect(0, "CreateDirectory %s 0" % name)
expect(0, "CreateFile %s\\foo GENERIC_WRITE 0 0 CREATE_NEW FILE_ATTRIBUTE_NORMAL 0" % name)
expect("ERROR_DIR_NOT_EMPTY", "RemoveDirectory %s" % name)
expect("ERROR_DIRECTORY", "RemoveDirectory %s\\foo" %name)
expect(0, "DeleteFile %s\\foo" %name)
expect(0, "RemoveDirectory %s" % name)

expect(0, "CreateDirectory %s 0" % name)
expect(0, "CreateFile %s\\foo GENERIC_WRITE 0 0 CREATE_NEW FILE_ATTRIBUTE_NORMAL 0" % name)
expect(0, "CreateFile %s\\bar GENERIC_WRITE 0 0 CREATE_NEW FILE_ATTRIBUTE_NORMAL 0" % name)
e, r = expect(0, "FindFiles %s\\*" % name)
s = set(l["FileName"] for l in r)
testeval('len(s) == 4')
testeval('"." in s')
testeval('".." in s')
testeval('"foo" in s')
testeval('"bar" in s')
expect(0, "DeleteFile %s\\bar" %name)
expect(0, "DeleteFile %s\\foo" %name)
expect(0, "RemoveDirectory %s" % name)

testdone()
