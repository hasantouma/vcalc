build:
	dune build bin/calculator.exe

run:
	dune exec bin/calculator.exe

.PHONY: clean
clean:
	dune clean

