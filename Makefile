ROOT=..

modules=$(ROOT)/firmware-common $(ROOT)/example-module $(ROOT)/atlas $(ROOT)/weather $(ROOT)/module-protocol $(ROOT)/app-protocol $(ROOT)/sonar $(ROOT)/core $(ROOT)/cloud

default: all

all: $(modules)
	@for d in $(modules); do     \
		(cd $$d && make);   \
	done

deps:
	cd $(ROOT)/cloud && go get ./...

$(ROOT)/firmware-common:
	git clone git@github.com:fieldkit/firmware-common.git $(ROOT)/firmware-common

$(ROOT)/example-module:
	git clone git@github.com:fieldkit/firmware-common.git $(ROOT)/example-module

$(ROOT)/sonar:
	git clone git@github.com:fieldkit/sonar.git $(ROOT)/sonar

$(ROOT)/weather:
	git clone git@github.com:fieldkit/atlas.git $(ROOT)/weather

$(ROOT)/atlas:
	git clone git@github.com:fieldkit/atlas.git $(ROOT)/atlas

$(ROOT)/cloud:
	cd $(ROOT)/cloud && go get ./...

clean: $(modules)
	@for d in $(modules); do           \
		(cd $$d && make clean);   \
	done

veryclean: clean
	@for d in $(modules); do              \
		(cd $$d && git clean -d -f); \
	done

status: $(modules)
	@for d in $(modules); do           \
		(cd $$d && git fetch);        \
		./branch-status.sh $$d;       \
	done

pull: $(modules)
	@for d in $(modules); do           \
		(cd $$d && git pull);         \
	done
