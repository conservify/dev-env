ROOT=..

modules=$(ROOT)/cmake $(ROOT)/bootloaders \
	$(ROOT)/module-protocol $(ROOT)/data-protocol $(ROOT)/app-protocol \
	$(ROOT)/phylum $(ROOT)/arduino-logging $(ROOT)/lwstreams $(ROOT)/lwcron $(ROOT)/enhanced-io $(ROOT)/simple-lora-comms \
	$(ROOT)/firmware-common $(ROOT)/core $(ROOT)/naturalist \
	$(ROOT)/example-module $(ROOT)/atlas $(ROOT)/weather $(ROOT)/sonar $(ROOT)/fona \
	$(ROOT)/cloud $(ROOT)/testing $(ROOT)/app

default: $(ROOT)/bin all

all: $(modules)
	+@for d in $(modules); do                     \
		(cd $$d && $(MAKE)) || exit 1;              \
	done

deps:
	cd $(ROOT)/cloud && go get ./...

clean: $(modules)
	+@for d in $(modules); do                     \
		(cd $$d && $(MAKE) clean) || exit 1;        \
	done

veryclean: clean
	+@for d in $(modules); do                     \
		(cd $$d && $(MAKE) veryclean) || exit 1;    \
	done

status: $(modules)
	+@for d in $(modules); do                     \
		(cd $$d && git fetch) || exit 1;            \
		./branch-status.sh $$d || exit 1;           \
	done

push: $(modules)
	+@for d in $(modules); do                     \
		(cd $$d && git push) || exit 1;             \
	done

pull: $(modules)
	git pull
	+@for d in $(modules); do                     \
		(cd $$d && echo $$d && git pull) || exit 1; \
	done

test: $(modules)
	@for d in fkfs phylum firmware-common; do     \
		(cd $(ROOT)/$$d && echo $$d && $(MAKE) test) || exit 1; \
	done

install: $(modules)
	@for d in testing app-protocol fkfs cloud; do \
		(cd $(ROOT)/$$d && echo $$d && INSTALLDIR=$(ROOT)/bin $(MAKE) install) || exit 1; \
	done

$(ROOT)/firmware-common:
	git clone git@github.com:fieldkit/firmware-common.git $@

$(ROOT)/example-module:
	git clone git@github.com:fieldkit/firmware-common.git $@

$(ROOT)/sonar:
	git clone git@github.com:fieldkit/sonar.git $@

$(ROOT)/weather:
	git clone git@github.com:fieldkit/atlas.git $@

$(ROOT)/atlas:
	git clone git@github.com:fieldkit/atlas.git $@

$(ROOT)/app:
	git clone git@github.com:fieldkit/app.git $@

$(ROOT)/bin:
	mkdir -p $(ROOT)/bin
