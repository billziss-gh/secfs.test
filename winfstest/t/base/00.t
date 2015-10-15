#!/usr/bin/python

from winfstest import *

expect(0, "CreateFile foo GENERIC_WRITE 0 0 CREATE_NEW FILE_ATTRIBUTE_NORMAL 0")
expect("ERROR_FILE_EXISTS", "CreateFile foo GENERIC_WRITE 0 0 CREATE_NEW FILE_ATTRIBUTE_NORMAL 0")
expect(0, "DeleteFile foo")

endplan()
