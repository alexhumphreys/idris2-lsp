.PHONY: build
build:
	idris2 --build lsp.ipkg

clean:
	idris2 --clean lsp.ipkg
	${RM} -r build
	${MAKE} -C tests clean

repl:
	rlwrap idris2 --repl lsp.ipkg

testbin:
	@${MAKE} -C tests testbin

# usage: `make test only=messages001`
test-only:
	${MAKE} -C tests only=$(only)

test: build testbin test-only
