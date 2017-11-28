modules=firmware-common example-module atlas weather

default: all

all:
	cd .. ; for d in $(modules) ; do     \
		(cd $$d && make) ;   \
	done

veryclean: clean
	cd .. ; for d in $(modules) ; do           \
		(cd $$d && git clean -d -f) ;   \
	done

clean:
	cd .. ; for d in $(modules) ; do           \
		(cd $$d && make clean) ;   \
	done
