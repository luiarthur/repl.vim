doc_fname = repl.txt
readme = README.md

all: docs

docs: doc/$(doc_fname) doc/tags

doc/$(doc_fname) doc/tags: $(readme)
	@cp $(readme) doc/$(doc_fname)
	@vim -c 'helptags doc | q'

clean:
	rm -f doc/*
