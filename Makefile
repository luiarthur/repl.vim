plugin_name = repl

all: docs

docs: doc/$(plugin_name).txt

doc/$(plugin_name).txt: README.md
	@mkdir -p doc
	@cp README.md doc/$(plugin_name).txt
	@vim -c 'helptags doc | q'

clean:
	rm -f doc/tags
