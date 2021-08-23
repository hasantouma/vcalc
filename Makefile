build:
	dune build bin/calculator.exe
	ln -sf _build/default/bin/calculator.exe calc

run:
	dune exec bin/calculator.exe

.PHONY: test
test:
	dune runtest

.PHONY: clean
clean:
	rm -f calc
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

