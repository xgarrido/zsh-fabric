# Name of your emacs binary
EMACS=emacs

ZFILES  = zsh-fabric.org
ZFILESO = $(ZFILES:.org=.zsh)
PFILES  = python-fabfile.org
PFILESO = $(PFILES:.org=.py)

all: zsh python

zsh: $(ZFILESO)

python: $(PFILESO)

%.zsh: %.org
	@echo "Tangling $< file"
	@sed -e '/:tangle\s\+no/d' $< | sed -n '/BEGIN_SRC/,/END_SRC/p' | sed -e '/END_SRC/d' -e '/BEGIN_SRC/d' > $@

%.py: %.org
	@echo "Tangling $< file"
	@sed -e '/:tangle\s\+no/d' $< | sed -n '/BEGIN_SRC/,/END_SRC/p' | sed -e '/END_SRC/d' -e '/BEGIN_SRC/d' -e 's/^..//' > $@

doc: doc/index.html

doc/index.html: $(FILESO) zsh-fabric-publish.org
	mkdir -p doc
	$(EMACS) --batch -Q --eval '(org-babel-load-file "zsh-fabric-publish.org")'
	rm zsh-fabric-publish.el
	cp doc/zsh-fabric.html doc/index.html
	echo "Documentation published to doc/"

clean:
	rm -f *.aux *.tex *.pdf zsh-fabric*.zsh python-fabfile.py* *.html doc/*html *~
	rm -rf doc
