# $FreeBSD: src/tools/regression/fstest/Makefile,v 1.1 2007/01/17 01:42:07 pjd Exp $

Platform=$(shell uname)

ifeq ($(Platform),Darwin)
CFLAGS+=-DHAS_LCHMOD
endif
#CFLAGS+=-DHAS_CHFLAGS
#CFLAGS+=-DHAS_LCHFLAGS
#CFLAGS+=-DHAS_TRUNCATE64
#CFLAGS+=-DHAS_STAT64
ifeq ($(Platform),Linux)
CFLAGS+=-DHAS_ACL
LDLIBS=-lacl
endif

all:	fstest

fstest:	fstest.c
	gcc -Wall ${CFLAGS} fstest.c -o fstest ${LDLIBS}

clean:
	rm -f fstest
