# Secfs Test Collection

This is a collection of file system test programs, which can be used to test POSIX file systems and in particular OSXFUSE and FUSE file systems. I use this collection of tools to test my own file system Secfs (Secure Cloud File System).

This collection is wholly comprised of projects written by others. Each individual project has its own license which applies to it and it remains of course the property of its respective owner(s). In many cases I did some porting work to/from OSX and to/from Linux to ensure that all tools (with a single exception) run on both operating systems. I release any such changes to the public domain.

My motivation in creating this collection is that there was no single place where a file system developer can go to get a comprehensive test suite to test their file system. Although tools exist, they are difficult to find, not well maintained and often quirky and buggy. OTOH these tools have helped me find quite a few problems in my own file system, the OSXFUSE/FUSE layer and even OSX itself.

The tools included in the collection are:

- fstest: A port to OSX of the ntfs-3g-pjd-fstest from Linux, which is itself a port of the original FreeBSD file system test suite by Pawel Jakub Dawidek.
    - License: BSD 2-clause
- fstools: Apple's fsx and fstorture programs. They are very good at finding issues with various system calls and in particular overlapping reads/writes. Fsx has been ported to Linux. Although possible I have not spent the time to port Fstorture as well.
    - License: APPLE PUBLIC SOURCE LICENSE v2.0
- fsstress: Originally from SGI and the XFS test suite it has been ported to Linux by the LTP. Exercises various aspects of the file system. In my case it identified issues with directory loops during rename. Ported to OSX.
    - License: GPL v2
- fsracer: From the LTP. A collection of shell scripts that runs multiple operations simultaneously  in an attempt to identify race conditions, etc.
    - License: GPL v2
- bonnie++: Benchmarking tool that can also be used to test file system consistency. Runs on OSX and Linux.
    - License: GPL v2
- iozone: Benchmarking tool that can also be used to test file system consistency. Runs on OSX and Linux.
    - License:
    > License to freely use and distribute this software is hereby granted 
    > by the author, subject to the condition that this copyright notice 
    > remains intact.  The author retains the exclusive right to publish 
    > derivative works based on this work, including, but not limited to,
    > revised versions of this work