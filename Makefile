ROOT=..

modules=$(ROOT)/cmake $(ROOT)/bootloaders \
	$(ROOT)/module-protocol $(ROOT)/data-protocol $(ROOT)/app-protocol \
	$(ROOT)/phylum $(ROOT)/arduino-logging $(ROOT)/lwstreams $(ROOT)/lwcron $(ROOT)/enhanced-io $(ROOT)/simple-lora-comms \
	$(ROOT)/firmware-common $(ROOT)/core $(ROOT)/naturalist \
	$(ROOT)/example-module $(ROOT)/atlas $(ROOT)/weather $(ROOT)/sonar \
	$(ROOT)/cloud $(ROOT)/testing $(ROOT)/app

default: $(ROOT)/bin all

all: $(modules)
	+@for d in $(modules); do                     \
    $(MAKE) -C $$d || exit 1;                   \
	done

clean: $(modules)
	+@for d in $(modules); do                     \
    $(MAKE) -C $$d clean || exit 1;             \
	done

veryclean: clean
	+@for d in $(modules); do                     \
    $(MAKE) -C $$d veryclean || exit 1;         \
	done

status:
	@echo $(modules) | xargs -n1 | parallel -k -I% --max-args=1 --no-notice ./branch-status.sh %

push: $(modules)
	@echo $(modules) | xargs -n1 | parallel -k -I% --max-args=1 --no-notice "cd % && git push --tags"

fetch: $(modules)
	git fetch
	@echo $(modules) | xargs -n1 | parallel -k -I% --max-args=1 --no-notice "cd % && git fetch"

pull: $(modules)
	git pull
	@echo $(modules) | xargs -n1 | parallel -k -I% --max-args=1 --no-notice "cd % && git pull"

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
