PATCHVER=273
ILOFILE=CP042663.scexe
ILOURL=https://downloads.hpe.com/pub/softlib2/software1/sc-linux-fw-ilo/p192122427/v176128/$(ILOFILE)
ILO250FILE=CP027911.scexe
ILO250URL=https://downloads.hpe.com/pub/softlib2/software1/sc-linux-fw-ilo/p192122427/v112485/$(ILO250FILE)

export PATCHVER

shell: all
	@docker build --build-arg PATCHVER=$(PATCHVER) -t fan .
	@echo "\n\nBuild complete, and ilo4_$(PATCHVER).fan.bin has been created.\n"
	@echo "The ilo4_$(PATCHVER).fan.bin file can be used by the ilo4 toolbox"
	@echo "to patch a machine running ILO4 v2.50."
	@echo "An unmodified version of 2.50 has been downloaded (outside of the"
	@echo "container, and can be used to downgrade an existing machine through"
	@echo "the machine's ILO web interface.\n"
	@docker run --rm -it fan bash

all: ilo/ilo250/ilo4_250.bin ilo/ilo$(PATCHVER)/ilo4_$(PATCHVER).bin

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

# This can be used to generate the patched ilo outside of the container
ilo/ilo4_$(PATCHVER).bin.fanpatch: /usr/bin/bspatch ilo/ilo$(PATCHVER)/ilo4_$(PATCHVER).bin
	bspatch $< $@ $(PATCHVER).patch

/usr/bin/bspatch:
	apt-get -y install bspatch

