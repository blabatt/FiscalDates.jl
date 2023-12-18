include Makefile.defs
.PHONY: test docs

test: 
	$(JULIA) $(ACTIVATE) test/runtests.jl
hello: 
	$(JULIA) $(ACTIVATE) $(EXECUTE) "using $(PROJECT); greet()"
docs:
	$(JULIA) $(ACTIVATE) docs/make.jl
showdocs: 
	$(BROWSER) docs/build/index.html
