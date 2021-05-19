PATCHVER=273
ILOFILE=CP042663.scexe
ILOURL=https://downloads.hpe.com/pub/softlib2/software1/sc-linux-fw-ilo/p192122427/v176128/$(ILOFILE)
ILO250FILE=CP027911.scexe
ILO250URL=https://downloads.hpe.com/pub/softlib2/software1/sc-linux-fw-ilo/p192122427/v112485/$(ILO250FILE)

shell: all
	docker build -t fan .
	docker run --rm -it fan bash

all: ilo/ilo250/ilo4_250.bin ilo/ilo4_$(PATCHVER).bin.fanpatch

ilo/ilo4_$(PATCHVER).bin.fanpatch: ilo/ilo$(PATCHVER)/ilo4_$(PATCHVER).bin
	bspatch $< $@ $(PATCHVER).patch

ilo/ilo$(PATCHVER)/ilo4_$(PATCHVER).bin: |ilo/ilo$(PATCHVER)/$(ILOFILE)
	sh $| --unpack=$(@D)

ilo/ilo$(PATCHVER)/$(ILOFILE):
	mkdir -p $(@D)
	wget $(ILOURL) -O $@

ilo/ilo250/$(ILO250FILE):
	mkdir -p $(@D)
	wget $(ILO250URL) -O $@

ilo/ilo250/ilo4_250.bin: |ilo/ilo250/$(ILO250FILE)
	sh $| --unpack=$(@D)
