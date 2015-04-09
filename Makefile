Platform	= $(shell uname)

ifeq ($(Platform),Darwin)
iozone_tgt	= macosx
all: tools tools/bin/bonnie++ tools/bin/fsracer tools/bin/fstorture tools/bin/fsx tools/bin/iozone
else
iozone_tgt	= linux
all: tools tools/bin/bonnie++ tools/bin/fsracer tools/bin/fsx tools/bin/iozone
endif

tools:
	mkdir -p tools/bin

tools/bin/bonnie++:
	cd bonnie++ && ./configure --prefix $(CURDIR)/tools
	make -C bonnie++
	cp bonnie++/bonnie++ $@
	git clean -dfx bonnie++

tools/bin/fsracer:
	cp fsracer/* $(@D)

tools/bin/fstorture:
	make -C fstools/src/fstorture
	cp fstools/src/fstorture/fstorture $@
	git clean -dfx fstools/src/fstorture

tools/bin/fsx:
	make -C fstools/src/fsx
	cp fstools/src/fsx/fsx $@
	git clean -dfx fstools/src/fsx

tools/bin/iozone:
	make -C iozone/src/current $(iozone_tgt)
	cp iozone/src/current/iozone $@
	git clean -dfx iozone/src/current
