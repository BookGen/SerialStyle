# SerialStyle

A collection of styles for use with [BookGen](https://github.com/marrus-sh/BookGen/), especially suited to serialized works.
Featuring:

+ Standard Serif and Largetype Sans PDF forms
+ Additional information on chapter­‑only PDFs for ease of distribution
+ Trade (6x9in) page size
+ CSS stylesheet

## Prerequisites

PDF styles are designed for use with XeLaTeX (the BookGen default).

### Fonts (for PDF)

All PDF styles require the [Old Standard TT](https://github.com/akryukov/oldstand/releases) fonts. The Largetype style additionally requires [Lato](http://www.latofonts.com/lato-free-fonts/).

## Makefile configuration

To make usage of these styles simpler, you might want to set up a makefile in your work directory which automatically generates symlinks to their locations.
The provided `Makefile` is intended to aid in this process.
The following is an example makefile that one might set up which makes use of it:

	SHELL = /bin/sh

	# Replace with the paths to these repositories on your device:
	BOOKGEN := BookGen
	SERIALSTYLE := SerialStyle

	# BookGen configuration:
	# DRAFTS := Drafts
	# export DRAFTS

	default: serialstyle bookgen

	# BookGen default make:
	bookgen:
		@$(MAKE) -ef "$(BOOKGEN)/GNUmakefile"

	# SerialStyle default make:
	serialstyle:
		@$(MAKE) -f "$(SERIALSTYLE)/Makefile"

	# Do not pattern­‑match this makefile:
	Makefile: ;

	# Always pass all unmatched patterns through to BookGen after running a SerialStyle make:
	%: serialstyle
		@$(MAKE) -ef "$(BOOKGEN)/GNUmakefile" $@

	# Delete generated files:
	clobber distclean gone:
		@$(MAKE) -f "$(SERIALSTYLE)/Makefile" gone
		@$(MAKE) -ef "$(BOOKGEN)/GNUmakefile" gone

	.PHONY: default bookgen serialstyle clobber distclean gone
