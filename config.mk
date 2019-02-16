PYTHON = python3
PIP = pip3
TEST_COMMAND = $(PYTHON) -m pytest papis tests --cov=papis

bash-autocomplete:
	make -C scripts/shell_completion/

update-authors:
	git shortlog -s -e -n | \
		sed -e "s/\t/  /" | \
		sed -e "s/^\s*//" > \
		AUTHORS

.PHONY: submodules

submodules: \
	papis/deps/colorama \
	papis/deps/prompt_toolkit \
	papis/deps/click \
	papis/deps/filetype \
	papis/deps/arxiv2bib.py \
	papis/deps/slugify \


papis/deps/slugify: submodules/python-slugify
	git submodule update -i $<
	mkdir -p $@
	cp -rv submodules/python-slugify/slugify/*.py $@

papis/deps/arxiv2bib.py: submodules/arxiv2bib
	git submodule update -i $<
	cp -v submodules/arxiv2bib/arxiv2bib.py $@

papis/deps/filetype: submodules/filetype.py
	git submodule init $<
	git submodule update $<
	mkdir -p $@
	cp -rv submodules/filetype.py/filetype/* $@

papis/deps/colorama: submodules/colorama
	git submodule update -i $<
	mkdir -p $@
	cp -v submodules/colorama/colorama/*.py $@

papis/deps/click: submodules/click
	git submodule update -i $<
	mkdir -p $@
	cp -v submodules/click/click/*.py $@

papis/deps/prompt_toolkit: submodules/prompt-toolkit
	git submodule update -i $<
	mkdir -p $@
	cp -rv submodules/prompt-toolkit/prompt_toolkit/* $@
	sed -i "s/from prompt_toolkit/from papis.deps.prompt_toolkit/g" \
		$$(find $@ -name '*.py')
