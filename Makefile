all: tools tools/bin/bonnie++ tools/bin/fstorture tools/bin/fsx tools/bin/iozone

tools:
	mkdir -p tools/bin

tools/bin/bonnie++:
	cd bonnie++ && ./configure --prefix $(CURDIR)/tools
	make -C bonnie++
	cp bonnie++/bonnie++ $@
	git clean -dfx bonnie++

tools/bin/fstorture:
	make -C fstools/src/fstorture
	cp fstools/src/fstorture/fstorture $@
	git clean -dfx fstools/src/fstorture

tools/bin/fsx:
	make -C fstools/src/fsx
	cp fstools/src/fsx/fsx $@
	git clean -dfx fstools/src/fsx

tools/bin/iozone:
	make -C iozone/src/current macosx
	cp iozone/src/current/iozone $@
	git clean -dfx iozone/src/current
