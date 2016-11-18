all: install

install:
	mkdir -p bin
	cp src/dpviz bin/
	cp src/plot.R bin/

clean:
	-rm -rf bin
