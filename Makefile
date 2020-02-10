ROOT = $(shell pwd)/..
MODULES = \
	$(ROOT)/cmake \
	$(ROOT)/data-protocol $(ROOT)/app-protocol $(ROOT)/atlas-protocol \
	$(ROOT)/phylum $(ROOT)/arduino-logging $(ROOT)/lwstreams $(ROOT)/lwcron $(ROOT)/enhanced-io \
	$(ROOT)/arduino-osh $(ROOT)/loading \
	$(ROOT)/firmware \
	$(ROOT)/cloud $(ROOT)/testing $(ROOT)/app

default: $(ROOT)/bin all

.PHONY: $(MODULES)

all: $(MODULES)

$(MODULES):
	$(MAKE) -C $@

MODULES_CLEAN_TARGETS = $(MODULES:%=clean-%)

.PHONY: $(MODULES_CLEAN_TARGETS)

clean: $(MODULES_CLEAN_TARGETS)

$(MODULES_CLEAN_TARGETS):
	$(MAKE) -C $(@:clean-%=%) clean

.PHONY: $(MODULES_VERYCLEAN_TARGETS)

MODULES_VERYCLEAN_TARGETS = $(MODULES:%=veryclean-%)

veryclean: $(MODULES_VERYCLEAN_TARGETS)

$(MODULES_VERYCLEAN_TARGETS):
	$(MAKE) -C $(@:veryclean-%=%) veryclean

status:
	@echo $(MODULES) | xargs -n1 | parallel -k -I% --max-args=1 --no-notice ./branch-status.sh %

push:
	@echo $(MODULES) | xargs -n1 | parallel -k -I% --max-args=1 --no-notice "cd % && git push && git push --tags"

fetch:
	git fetch
	@echo $(MODULES) | xargs -n1 | parallel -k -I% --max-args=1 --no-notice "cd % && git fetch"

pull:
	git pull
	@echo $(MODULES) | xargs -n1 | parallel -k -I% --max-args=1 --no-notice "cd % && git pull"

test:
	@for d in arduino-logging lwcron arduino-osh phylum firmware; do     \
		(cd $(ROOT)/$$d && echo $$d && $(MAKE) test) || exit 1; \
	done

install: $(MODULES)
	@for d in testing app-protocol fkfs cloud; do \
		(cd $(ROOT)/$$d && echo $$d && INSTALLDIR=$(ROOT)/bin $(MAKE) install) || exit 1; \
	done

$(ROOT)/bin:
	mkdir -p $(ROOT)/bin
