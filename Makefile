.PHONY: test setup httpbin

test:
	vim-themis/bin/themis --reporter dot test

setup:
	git clone git@github.com:thinca/vim-themis.git
	git clone git@github.com:syngan/vim-vimlint
	git clone git@github.com:ynkdir/vim-vimlparser

lint:
	./vim-vimlint/bin/vimlint.sh -l ./vim-vimlint -p ./vim-vimlparser -e EVL102.l:_=1 -c func_abort=1 autoload ftdetect plugin syntax
