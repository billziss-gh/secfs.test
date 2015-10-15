#!/usr/bin/python

from winfstest import *

name = uniqname()

expect("CreateFile %s GENERIC_WRITE 0 0 CREATE_NEW FILE_ATTRIBUTE_NORMAL 0" % name, 0)
expect("CreateDirectory %s 0" % name, "ERROR_ALREADY_EXISTS")
expect("DeleteFile %s" % name, 0)

expect("CreateDirectory %s 0" % name, 0)
expect("CreateDirectory %s 0" % name, "ERROR_ALREADY_EXISTS")
expcnd("GetFileInformation %s" % name, 'r[0]["FileAttributes"] == 0x10')
expect("DeleteFile %s" % name, "ERROR_ACCESS_DENIED")
expect("RemoveDirectory %s" % name, 0)
expect("RemoveDirectory %s" % name, "ERROR_FILE_NOT_FOUND")

testdone()
