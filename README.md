# SerialStyle

A collection of styles for use with [BookGen](https://github.com/marrus-sh/BookGen/), especially suited to serialized works.
Featuring:

+ Standard Serif and Largetype Sans PDF forms
+ Additional information on chapter­‑only PDFs for ease of distribution
+ Trade (6x9in) page size
+ CSS stylesheet with optionally embedded fonts

## Prerequisites

PDF styles are designed for use with XeLaTeX (the BookGen default).

### Fonts (for PDF)

All PDF styles require the [Old Standard TT](https://github.com/akryukov/oldstand/releases) fonts. The Largetype style additionally requires [Lato](http://www.latofonts.com/lato-free-fonts/).

The Web+Fonts style embeds the Old Standard TT font using Base64 data: URIs.
The Web-Fonts style lacks this font-embedding.

### Colours (for HTML):

By specifying a raw HTML `<style>` block in the `header-includes` of your project, you can change the colours of the document in supporting browsers by overriding the following CSS custom properties on the root element:

+ `--SerialStyle-Colour-White`
+ `--SerialStyle-Colour-Bright`
+ `--SerialStyle-Colour-Light`
+ `--SerialStyle-Colour-Regular`
+ `--SerialStyle-Colour-Medium`
+ `--SerialStyle-Colour-Dark`
+ `--SerialStyle-Colour-Dim`
+ `--SerialStyle-Colour-Black`

For example:

````yaml
header-includes: |
  ```{=html}
  <style>
  html {
  	--SerialStyle-Colour-White: #FFF8E3;
  	--SerialStyle-Colour-Bright: #EEE2BF;
  	--SerialStyle-Colour-Light: #AA9F7F;
  	--SerialStyle-Colour-Regular: #998B53;
  	--SerialStyle-Colour-Medium: #887744;
  	--SerialStyle-Colour-Dark: #776335;
  	--SerialStyle-Colour-Dim: #443628;
  	--SerialStyle-Colour-Black: #332714;
  }
  </style>
  ```
````

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
