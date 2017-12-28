ROOT=..

modules=$(ROOT)/firmware-common $(ROOT)/example-module $(ROOT)/fkfs $(ROOT)/atlas $(ROOT)/weather $(ROOT)/naturalist $(ROOT)/module-protocol $(ROOT)/app-protocol $(ROOT)/sonar $(ROOT)/core $(ROOT)/cloud $(ROOT)/app

default: all

all: $(modules)
	@for d in $(modules); do          \
		(cd $$d && make) || exit 1;   \
	done

deps:
	cd $(ROOT)/cloud && go get ./...

clean: $(modules)
	@for d in $(modules); do                    \
		(cd $$d && make clean) || exit 1;       \
	done

veryclean: clean
	@for d in $(modules); do                    \
		(cd $$d && make veryclean) || exit 1;   \
	done

status: $(modules)
	@for d in $(modules); do                    \
		(cd $$d && git fetch) || exit 1;        \
		./branch-status.sh $$d || exit 1;       \
	done

push: $(modules)
	@for d in $(modules); do                    \
		(cd $$d && git push) || exit 1;         \
	done

pull: $(modules)
	@for d in $(modules); do                    \
		(cd $$d && git pull) || exit 1;         \
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
