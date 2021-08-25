build:
	dune build bin/vcalc.exe
	ln -sf _build/default/bin/vcalc.exe vcalc

run:
	dune exec bin/vcalc.exe

.PHONY: test
test:
	dune runtest

.PHONY: clean
clean:
	rm -f vcalc
	rm -f mygraph.dot
	rm -f mygraph.png
	dune clean

# You can stick this section in your own project if you wish.
# 'make graph' produces a image that can be included in 'README.md'.
#
.PHONY: graph deps.png
graph: deps.png
deps.png:
	mkdir -p img
	dune-deps | tred | dot -Tpng > img/deps.png

