CFLAGS	+= -Wall -DNO_XFS -D_LARGEFILE64_SOURCE -D_GNU_SOURCE
fsstress: fsstress.c global.h xfscompat.h
	$(CC) $(CFLAGS) fsstress.c -o fsstress
