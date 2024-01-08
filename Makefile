#
# PyFilesystem
#

include docs/portable.mk

####

# since we rely on paths relative to the makefile location, abort if current directory != makefile directory
ifneq ($(current_dir),$(mkfile_dir))
$(error ERR!: Invalid current directory; this makefile must be invoked from the directory it resides in ('$(mkfile_dir)'))
endif

####

ifeq (${mkfile_path},Makefile)
BUILD_HELP_ALIAS ?= make
else
BUILD_HELP_ALIAS ?= make -f "$(mkfile_path)"
endif

####

.PHONY: release
release: cleandist
	$(PYTHON) -m pip install twine wheel mypy pylint black tox nose
	$(PYTHON) -m build
	$(PYTHON) -m twine upload --non-interactive -r testpypi dist/*

.PHONY: cleandist
cleandist:
	@$(call xRM,"dist$(/)*.whl")
	@$(call xRM,"dist$(/)*.tar.gz")

.PHONY: cleandocs
cleandocs:
	$(MAKE) -C docs clean

.PHONY: clean
clean: cleandist cleandocs

.PHONY: test
test:
	$(PYTHON) -m nosetests --with-coverage --cover-package=fs -a "!slow" tests

.PHONY: slowtest
slowtest:
	$(PYTHON) -m nosetests --with-coverage --cover-erase --cover-package=fs tests

.PHONY: testall
testall:
	$(PYTHON) -m tox

.PHONY: docs
docs:
	$(MAKE) -C docs html
	$(PYTHON) -c "import os, webbrowser; webbrowser.open('file://' + os.path.abspath('./docs/build/html/index.html'))"

.PHONY: typecheck
typecheck:
	$(PYTHON) -m mypy -p fs --config pyproject.toml
