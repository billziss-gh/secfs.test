# Secfs Test Collection

This is a collection of file system test programs, which can be used to test POSIX and Windows file systems. I use this collection of tools to test my own file system Secfs (Secure Cloud File System).

This collection is comprised mostly of projects written by others. Each individual project has its own license which applies to it and it remains the property of its respective owner(s). In many cases I did some porting work between OSX, Linux and Windows; I release any such porting changes to the public domain.

My motivation in creating this collection is that there was no single place where a file system developer can go to get a comprehensive test suite to test their file system. Although tools exist, they are difficult to find, not well maintained and often quirky and buggy. OTOH these tools have helped me find quite a few problems in my own file system, the OSXFUSE/FUSE layer and even OSX itself.

## Projects

The projects included in the collection are:

- fstest: A port to OSX of the ntfs-3g-pjd-fstest from Linux, which is itself a port of the original FreeBSD file system test suite by Pawel Jakub Dawidek.
    - Platform: OSX, Linux
    - License: BSD 2-clause
- fstools: Apple's fsx and fstorture programs. They are very good at finding issues with various system calls and in particular overlapping reads/writes.
    - Platform: fsx: OSX, Linux, Windows; fstorture: OSX
    - License: APPLE PUBLIC SOURCE LICENSE v2.0
- fsstress: Originally from SGI and the XFS test suite it has been ported to Linux by the LTP. Exercises various aspects of the file system. In my case it identified issues with directory loops during rename.
    - Platform: OSX, Linux
    - License: GPL v2
- fsracer: From the LTP. A collection of shell scripts that runs multiple operations simultaneously  in an attempt to identify race conditions, etc.
    - Platform: OSX, Linux
    - License: GPL v2
- fsrand.py: A file system randomizer tool. It will perform a series of random operations on a file system, creating new files/directories and updating/removing existing ones.
    - Platform: OSX, Linux
    - License: BSD 3-clause
- bonnie++: Benchmarking tool that can also be used to test file system consistency.
    - Platform: OSX, Linux
    - License: GPL v2
- iozone: Benchmarking tool that can also be used to test file system consistency.
    - Platform: OSX, Linux
    - License:
    "License to freely use and distribute this software is hereby granted 
    by the author, subject to the condition that this copyright notice 
    remains intact.  The author retains the exclusive right to publish 
    derivative works based on this work, including, but not limited to,
    revised versions of this work."
- winfstest: Windows file system testing. Inspired by the FreeBSD fstest, but written from scratch to work on Windows.
    - Platform: Windows
    - License: BSD 3-clause

## Docker Image

A docker image prepared by Yujun Zhang (@yujunz) is available at [dockerhub](https://hub.docker.com/r/yujunz/secfs.test) and can be pulled using `docker pull yujunz/secfs.test`. (See PR #4.)
