# Makefile for Sphinx documentation
#
# cross platform (*nix/windows) Makefile
# see https://github.com/rivy-go/git-changelog/blob/master/Makefile

## NOTE: requirements ...
## * windows ~ `awk`, `grep`, and `make`; use `scoop install gawk grep make`
## * all platforms ~ `goverage`; use `go get -u github.com/haya14busa/goverage`

NAME = ## optional (defaults to name of parent directory)

####

# spell-checker:ignore () busa changelog haya haya14busa
# spell-checker:ignore (targets) deps realclean veryclean
# spell-checker:ignore (make) abspath addprefix addsuffix endef findstring firstword ifeq ifneq lastword undefine notdir
#
# spell-checker:ignore (MSVC flags) defaultlib nologo
# spell-checker:ignore (abbrev/acronyms/names) MSVC
# spell-checker:ignore (clang flags) flto Xclang Wextra Werror
# spell-checker:ignore (flags) coverprofile
# spell-checker:ignore (go) GOBIN GOPATH dep goverage golint
# spell-checker:ignore (misc) brac cmdbuf forwback lessecho lesskey libcmt libpath linenum optfunc opttbl stdext ttyin
# spell-checker:ignore (shell/nix) printf uname
# spell-checker:ignore (shell/win) COMSPEC USERPROFILE delims findstr goawk mkdir
# spell-checker:ignore (vars) BQUOTE BSLASH CFLAGS CXXFLAGS DQUOTE LDFLAGS RMDIR SQUOTE devnull mkfile

####

# require at least `make` v4 (minimum needed for correct path functions)
MAKE_VERSION_major := $(word 1,$(subst ., ,$(MAKE_VERSION)))
MAKE_VERSION_fail := $(filter $(MAKE_VERSION_major),3 2 1 0)
ifneq ($(MAKE_VERSION_fail),)
$(error ERR!: `make` v4+ required)
endif

/ := /
NULL :=
SPACE := $() $()
BSLASH := $(strip \)
BQUOTE := $(firstword \` \`)
DQUOTE := \"
SQUOTE := \'

ifeq ($(OS),Windows_NT)
/ := $(strip \)
BQUOTE := $(subst \,,$(BQUOTE))
DQUOTE := $(subst \,,$(DQUOTE))
SQUOTE := $(subst \,,$(SQUOTE))
endif


mkfile_path := $(subst /,$(/),$(lastword $(MAKEFILE_LIST)))
mkfile_abs_path := $(subst /,$(/),$(abspath $(mkfile_path)))
mkfile_dir := $(subst /,$(/),$(abspath $(dir $(mkfile_abs_path))))
ifeq (${OS},Windows_NT)
SHELL := cmd
COMSPEC := $(shell echo %COMSPEC%)## avoid any env variable case variance issue
current_dir := $(subst /,$(/),$(abspath $(shell "$(COMSPEC)" /x/d/c echo %CD%)))## %CD% requires CMD extensions
else
SHELL := bash
current_dir := $(subst /,$(/),$(abspath $(shell echo $$PWD)))
endif

ifeq (${NAME},)
override NAME = $(notdir $(mkfile_dir))
endif

# $(info mkfile_path='$(mkfile_path)')
# $(info mkfile_abs_path='$(mkfile_abs_path)')
# $(info mkfile_dir='$(mkfile_dir)')
# $(info current_dir='$(current_dir)')

ifeq (${SPACE},$(findstring ${SPACE},${mkfile_abs_path}))
$(error ERR!: <space>'s within project directory may cause issues)
endif

####

OS_PREFIX=
ifeq (${OS},Windows_NT)
	OS_ID      = win
	OS_PREFIX  = $(OS_ID).
	EXT        = .exe
	HOME       ?= $(shell echo %USERPROFILE%)## avoid any env variable case variance issue
	SystemRoot := $(shell echo %SystemRoot%)## avoid any env variable case variance issue
	AWK        = gawk
	CP         = copy /y
	LOG       = $(if $(1),echo $(1))
	GREP       = grep
	MKDIR      = mkdir
	RM         = del
	RM_r       = $(RM) /s
	RM_rf      = $(RM) /s
	RMDIR      = rmdir /s /q
	RMDIR_f    = rmdir /s /q
	FIND       = "$(SystemRoot)\System32\find"
	FINDSTR    = "$(SystemRoot)\System32\findstr"
	MORE       = "$(SystemRoot)\System32\more"
	SORT       = "$(SystemRoot)\System32\sort"
	devnull    = NUL
	shell_true = cd .
	PYTHON     = py -3
else
	/ := /
	OS := $(shell uname | tr '[:upper:]' '[:lower:]')
	OS_ID      = $(OS)
	OS_PREFIX  = $(OS_ID).
	EXT        =
	AWK        = awk
	CP         = cp
	LOG       = $(if $(1),echo "$(1)")
	GREP       = grep
	MKDIR      = mkdir
	PRINTF     = printf
	RM         = rm
	RM_r       = $(RM) -r
	RM_rf      = $(RM) -rf
	RMDIR      = $(RM) -r
	RMDIR_f    = $(RM) -rf
	SORT       = sort
	devnull    = /dev/null
	shell_true = true
	PYTHON     = python3
endif

## xMKDIR_p == cross-platform MKDIR
ifeq ($(OS),Windows_NT)
define xMKDIR_p =
	if NOT EXIST "$(subst /,\,$(1:"%"=%))" $(MKDIR) "$(subst /,\,$(1:"%"=%))" >$(devnull)
endef
else
define xMKDIR_p =
	$(MKDIR) -p "$(1:"%"=%)" >$(devnull)
endef
endif

## xRM == cross-platform RM
ifeq ($(OS),Windows_NT)
define xRM =
	if EXIST "$(subst /,\,$(1:"%"=%))" $(RM) "$(subst /,\,$(1:"%"=%))" >$(devnull) 2>&1 && echo "$(subst /,\,$(1:"%"=%))" removed
endef
else
define xRM =
	ls -d "$(1:"%"=%)" >$(devnull) 2>&1 && $(RM) "$(1:"%"=%)" && echo \""$(1:"%"=%)"\" removed || ${shell_true}
endef
endif

## xRMDIR == cross-platform RMDIR
ifeq ($(OS),Windows_NT)
define xRMDIR =
	if EXIST "$(subst /,\,$(1:"%"=%))" $(RMDIR_f) "$(subst /,\,$(1:"%"=%))" >$(devnull) 2>&1 && echo "$(subst /,\,$(1:"%"=%))" directory removed
endef
else
define xRMDIR =
	ls -d "$(1:"%"=%)" >$(devnull) 2>&1 && $(RMDIR_f) "$(1:"%"=%)" && echo \""$(1:"%"=%)"\" directory removed || ${shell_true}
endef
endif

lc = $(subst A,a,$(subst B,b,$(subst C,c,$(subst D,d,$(subst E,e,$(subst F,f,$(subst G,g,$(subst H,h,$(subst I,i,$(subst J,j,$(subst K,k,$(subst L,l,$(subst M,m,$(subst N,n,$(subst O,o,$(subst P,p,$(subst Q,q,$(subst R,r,$(subst S,s,$(subst T,t,$(subst U,u,$(subst V,v,$(subst W,w,$(subst X,x,$(subst Y,y,$(subst Z,z,$(1)))))))))))))))))))))))))))

####

BUILD_DIR ?= \#builds

## `go` packages are generally compiled to targets which include debug and symbol information
CONFIG ?= debug
override CONFIG := $(call lc,$(CONFIG))

OUT_DIR = $(BUILD_DIR)$(/)$(OS_PREFIX)$(CONFIG)
# OUT_DIR = $(BUILD_DIR)$(/)$(OS_ID)

# $(info BUILD_DIR='$(BUILD_DIR)')
# $(info CONFIG='$(CONFIG)')
# $(info NAME='$(NAME)')
# $(info OUT_DIR='$(OUT_DIR)')

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = sphinx-build
PAPER         =
BUILDDIR      = build

# User-friendly check for sphinx-build
ifeq ($(shell which $(SPHINXBUILD) >/dev/null 2>&1; echo $$?), 1)
	$(error The '$(SPHINXBUILD)' command was not found. Make sure you have Sphinx installed, then set the SPHINXBUILD environment variable to point to the full path of the '$(SPHINXBUILD)' executable. Alternatively you can add the directory with the executable to your PATH. If you don\'t have Sphinx installed, grab it from http://sphinx-doc.org/)
endif

# Internal variables.
PAPEROPT_a4     = -D latex_paper_size=a4
PAPEROPT_letter = -D latex_paper_size=letter
ALLSPHINXOPTS   = -d $(BUILDDIR)$(/)doctrees $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) source
# the i18n builder cannot share the environment and doctrees with the others
I18NSPHINXOPTS  = $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) source

.PHONY: help
help:
	@$(call LOG,Please use 'make <target>' where <target> is one of)
	@$(call LOG,  html       to make standalone HTML files)
	@$(call LOG,  dirhtml    to make HTML files named index.html in directories)
	@$(call LOG,  singlehtml to make a single large HTML file)
	@$(call LOG,  pickle     to make pickle files)
	@$(call LOG,  json       to make JSON files)
	@$(call LOG,  htmlhelp   to make HTML files and a HTML help project)
	@$(call LOG,  qthelp     to make HTML files and a qthelp project)
	@$(call LOG,  applehelp  to make an Apple Help Book)
	@$(call LOG,  devhelp    to make HTML files and a Devhelp project)
	@$(call LOG,  epub       to make an epub)
	@$(call LOG,  epub3      to make an epub3)
	@$(call LOG,  latex      to make LaTeX files, you can set PAPER=a4 or PAPER=letter)
	@$(call LOG,  latexpdf   to make LaTeX files and run them through pdflatex)
	@$(call LOG,  latexpdfja to make LaTeX files and run them through platex/dvipdfmx)
	@$(call LOG,  text       to make text files)
	@$(call LOG,  man        to make manual pages)
	@$(call LOG,  texinfo    to make Texinfo files)
	@$(call LOG,  info       to make Texinfo files and run them through makeinfo)
	@$(call LOG,  gettext    to make PO message catalogs)
	@$(call LOG,  changes    to make an overview of all changed/added/deprecated items)
	@$(call LOG,  xml        to make Docutils-native XML files)
	@$(call LOG,  pseudoxml  to make pseudoxml-XML files for display purposes)
	@$(call LOG,  linkcheck  to check all external links for integrity)
	@$(call LOG,  doctest    to run all doctests embedded in the documentation (if enabled))
	@$(call LOG,  coverage   to run coverage check of the documentation (if enabled))
	@$(call LOG,  dummy      to check syntax errors of document sources)

.PHONY: clean
clean:
	$(call xRM,$(BUILDDIR)$(/)*)

.PHONY: html
html:
	$(SPHINXBUILD) -b html $(ALLSPHINXOPTS) $(BUILDDIR)$(/)html
	@$(call LOG,)
	@$(call LOG,Build finished. The HTML pages are in $(BUILDDIR)$(/)html.)

.PHONY: dirhtml
dirhtml:
	$(SPHINXBUILD) -b dirhtml $(ALLSPHINXOPTS) $(BUILDDIR)$(/)dirhtml
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)$(/)dirhtml."

.PHONY: singlehtml
singlehtml:
	$(SPHINXBUILD) -b singlehtml $(ALLSPHINXOPTS) $(BUILDDIR)$(/)singlehtml
	@echo
	@echo "Build finished. The HTML page is in $(BUILDDIR)$(/)singlehtml."

.PHONY: pickle
pickle:
	$(SPHINXBUILD) -b pickle $(ALLSPHINXOPTS) $(BUILDDIR)$(/)pickle
	@echo
	@echo "Build finished; now you can process the pickle files."

.PHONY: json
json:
	$(SPHINXBUILD) -b json $(ALLSPHINXOPTS) $(BUILDDIR)$(/)json
	@echo
	@echo "Build finished; now you can process the JSON files."

.PHONY: htmlhelp
htmlhelp:
	$(SPHINXBUILD) -b htmlhelp $(ALLSPHINXOPTS) $(BUILDDIR)$(/)htmlhelp
	@echo
	@echo "Build finished; now you can run HTML Help Workshop with the" \
	      ".hhp project file in $(BUILDDIR)/htmlhelp."

.PHONY: qthelp
qthelp:
	$(SPHINXBUILD) -b qthelp $(ALLSPHINXOPTS) $(BUILDDIR)$(/)qthelp
	@echo
	@echo "Build finished; now you can run "qcollectiongenerator" with the" \
	      ".qhcp project file in $(BUILDDIR)/qthelp, like this:"
	@echo "# qcollectiongenerator $(BUILDDIR)/qthelp/PyFilesystem2.qhcp"
	@echo "To view the help file:"
	@echo "# assistant -collectionFile $(BUILDDIR)/qthelp/PyFilesystem2.qhc"

.PHONY: applehelp
applehelp:
	$(SPHINXBUILD) -b applehelp $(ALLSPHINXOPTS) $(BUILDDIR)$(/)applehelp
	@echo
	@echo "Build finished. The help book is in $(BUILDDIR)/applehelp."
	@echo "N.B. You won't be able to view it unless you put it in" \
	      "~/Library/Documentation/Help or install it in your application" \
	      "bundle."

.PHONY: devhelp
devhelp:
	$(SPHINXBUILD) -b devhelp $(ALLSPHINXOPTS) $(BUILDDIR)$(/)devhelp
	@echo
	@echo "Build finished."
	@echo "To view the help file:"
	@echo "# mkdir -p $$HOME/.local/share/devhelp/PyFilesystem2"
	@echo "# ln -s $(BUILDDIR)/devhelp $$HOME/.local/share/devhelp/PyFilesystem2"
	@echo "# devhelp"

.PHONY: epub
epub:
	$(SPHINXBUILD) -b epub $(ALLSPHINXOPTS) $(BUILDDIR)$(/)epub
	@echo
	@echo "Build finished. The epub file is in $(BUILDDIR)/epub."

.PHONY: epub3
epub3:
	$(SPHINXBUILD) -b epub3 $(ALLSPHINXOPTS) $(BUILDDIR)$(/)epub3
	@echo
	@echo "Build finished. The epub3 file is in $(BUILDDIR)/epub3."

.PHONY: latex
latex:
	$(SPHINXBUILD) -b latex $(ALLSPHINXOPTS) $(BUILDDIR)$(/)latex
	@echo
	@echo "Build finished; the LaTeX files are in $(BUILDDIR)/latex."
	@echo "Run \`make' in that directory to run these through (pdf)latex" \
	      "(use \`make latexpdf' here to do that automatically)."

.PHONY: latexpdf
latexpdf:
	$(SPHINXBUILD) -b latex $(ALLSPHINXOPTS) $(BUILDDIR)$(/)latex
	@echo "Running LaTeX files through pdflatex..."
	$(MAKE) -C $(BUILDDIR)$(/)latex all-pdf
	@echo "pdflatex finished; the PDF files are in $(BUILDDIR)/latex."

.PHONY: latexpdfja
latexpdfja:
	$(SPHINXBUILD) -b latex $(ALLSPHINXOPTS) $(BUILDDIR)$(/)latex
	@echo "Running LaTeX files through platex and dvipdfmx..."
	$(MAKE) -C $(BUILDDIR)$(/)latex all-pdf-ja
	@echo "pdflatex finished; the PDF files are in $(BUILDDIR)/latex."

.PHONY: text
text:
	$(SPHINXBUILD) -b text $(ALLSPHINXOPTS) $(BUILDDIR)$(/)text
	@echo
	@echo "Build finished. The text files are in $(BUILDDIR)/text."

.PHONY: man
man:
	$(SPHINXBUILD) -b man $(ALLSPHINXOPTS) $(BUILDDIR)$(/)man
	@echo
	@echo "Build finished. The manual pages are in $(BUILDDIR)/man."

.PHONY: texinfo
texinfo:
	$(SPHINXBUILD) -b texinfo $(ALLSPHINXOPTS) $(BUILDDIR)$(/)texinfo
	@echo
	@echo "Build finished. The Texinfo files are in $(BUILDDIR)/texinfo."
	@echo "Run \`make' in that directory to run these through makeinfo" \
	      "(use \`make info' here to do that automatically)."

.PHONY: info
info:
	$(SPHINXBUILD) -b texinfo $(ALLSPHINXOPTS) $(BUILDDIR)$(/)texinfo
	@echo "Running Texinfo files through makeinfo..."
	make -C $(BUILDDIR)$(/)texinfo info
	@echo "makeinfo finished; the Info files are in $(BUILDDIR)/texinfo."

.PHONY: gettext
gettext:
	$(SPHINXBUILD) -b gettext $(I18NSPHINXOPTS) $(BUILDDIR)$(/)locale
	@echo
	@echo "Build finished. The message catalogs are in $(BUILDDIR)/locale."

.PHONY: changes
changes:
	$(SPHINXBUILD) -b changes $(ALLSPHINXOPTS) $(BUILDDIR)$(/)changes
	@echo
	@echo "The overview file is in $(BUILDDIR)/changes."

.PHONY: linkcheck
linkcheck:
	$(SPHINXBUILD) -b linkcheck $(ALLSPHINXOPTS) $(BUILDDIR)$(/)linkcheck
	@echo
	@echo "Link check complete; look for any errors in the above output " \
	      "or in $(BUILDDIR)/linkcheck/output.txt."

.PHONY: doctest
doctest:
	$(SPHINXBUILD) -b doctest $(ALLSPHINXOPTS) $(BUILDDIR)$(/)doctest
	@echo "Testing of doctests in the sources finished, look at the " \
	      "results in $(BUILDDIR)/doctest/output.txt."

.PHONY: coverage
coverage:
	$(SPHINXBUILD) -b coverage $(ALLSPHINXOPTS) $(BUILDDIR)$(/)coverage
	@echo "Testing of coverage in the sources finished, look at the " \
	      "results in $(BUILDDIR)/coverage/python.txt."

.PHONY: xml
xml:
	$(SPHINXBUILD) -b xml $(ALLSPHINXOPTS) $(BUILDDIR)$(/)xml
	@echo
	@echo "Build finished. The XML files are in $(BUILDDIR)/xml."

.PHONY: pseudoxml
pseudoxml:
	$(SPHINXBUILD) -b pseudoxml $(ALLSPHINXOPTS) $(BUILDDIR)$(/)pseudoxml
	@echo
	@echo "Build finished. The pseudo-XML files are in $(BUILDDIR)/pseudoxml."

.PHONY: dummy
dummy:
	$(SPHINXBUILD) -b dummy $(ALLSPHINXOPTS) $(BUILDDIR)$(/)dummy
	@echo
	@echo "Build finished. Dummy builder generates no files."
