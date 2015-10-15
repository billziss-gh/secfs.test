#!/usr/bin/python

from winfstest import *

name = uniqname()

expect(0, "CreateFile %s GENERIC_WRITE 0 0 CREATE_NEW FILE_ATTRIBUTE_NORMAL 0" % name)
expect("ERROR_FILE_EXISTS", "CreateFile %s GENERIC_WRITE 0 0 CREATE_NEW FILE_ATTRIBUTE_NORMAL 0" % name)
expect(0, "DeleteFile %s" % name)
expect("ERROR_FILE_NOT_FOUND", "DeleteFile %s" % name)

expect(0, "CreateFile %s GENERIC_WRITE 0 0 CREATE_ALWAYS FILE_ATTRIBUTE_NORMAL 0" % name)
expect(0, "CreateFile %s GENERIC_WRITE 0 0 CREATE_ALWAYS FILE_ATTRIBUTE_NORMAL 0" % name)
expect("ERROR_ALREADY_EXISTS", "-e CreateFile %s GENERIC_WRITE 0 0 CREATE_ALWAYS FILE_ATTRIBUTE_NORMAL 0" % name)
expect(0, "DeleteFile %s" % name)

expect(0, "CreateFile %s GENERIC_WRITE 0 0 OPEN_ALWAYS FILE_ATTRIBUTE_NORMAL 0" % name)
expect(0, "CreateFile %s GENERIC_WRITE 0 0 OPEN_ALWAYS FILE_ATTRIBUTE_NORMAL 0" % name)
expect("ERROR_ALREADY_EXISTS", "-e CreateFile %s GENERIC_WRITE 0 0 OPEN_ALWAYS FILE_ATTRIBUTE_NORMAL 0" % name)
expect(0, "DeleteFile %s" % name)

expect("ERROR_FILE_NOT_FOUND", "CreateFile %s GENERIC_WRITE 0 0 OPEN_EXISTING FILE_ATTRIBUTE_NORMAL 0" % name)
expect(0, "CreateFile %s GENERIC_WRITE 0 0 CREATE_ALWAYS FILE_ATTRIBUTE_NORMAL 0" % name)
expect(0, "CreateFile %s GENERIC_WRITE 0 0 OPEN_EXISTING FILE_ATTRIBUTE_NORMAL 0" % name)
expect(0, "DeleteFile %s" % name)

expect("ERROR_FILE_NOT_FOUND", "CreateFile %s GENERIC_WRITE 0 0 TRUNCATE_EXISTING FILE_ATTRIBUTE_NORMAL 0" % name)
expect(0, "CreateFile %s GENERIC_WRITE 0 0 CREATE_ALWAYS FILE_ATTRIBUTE_NORMAL 0" % name)
expect(0, "CreateFile %s GENERIC_WRITE 0 0 TRUNCATE_EXISTING FILE_ATTRIBUTE_NORMAL 0" % name)
expect(0, "DeleteFile %s" % name)

expect("ERROR_PATH_NOT_FOUND", "CreateFile %s\\bar GENERIC_WRITE 0 0 CREATE_NEW FILE_ATTRIBUTE_NORMAL 0" % name)

testdone()
