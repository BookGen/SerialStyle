# Creates links from `$srcdir/*.c[ls]s` to `Styles/*.c[ls]s`.
# In the case of CSS styles, creates versions both without (`-Fonts`) and with (`+Fonts`) embedded fonts.
# Also links the associated python filter.
#
# Example usage from within another Makefile:
#
# 	serialstyle: ; $(MAKE) -f SerialStyle/Makefile
# 	.PHONY: serialstyle

SHELL = /bin/sh
srcdir := $(patsubst %/Makefile,%,$(lastword $(MAKEFILE_LIST)))
serialclses := $(wildcard $(srcdir)/*.cls)
serialcsses := $(filter-out $(srcdir)/+Fonts.css,$(wildcard $(srcdir)/*.css))
serialclsstyles := $(patsubst $(srcdir)/%,Styles/%,$(serialclses))
serialcssnofontstyles := $(patsubst $(srcdir)/%.css,Styles/%-Fonts.css,$(serialcsses))
serialcssfontstyles := $(patsubst $(srcdir)/%.css,Styles/%+Fonts.css,$(serialcsses))
serialcssstyles := $(serialcssnofontstyles) $(serialcssfontstyles)
serialstyles := $(serialclsstyles) $(serialcssstyles)
serialstylepys := $(patsubst $(srcdir)/%.cls,Styles/%.py,$(serialclses)) $(patsubst $(srcdir)/%.css,Styles/%-Fonts.py,$(serialcsses)) $(patsubst $(srcdir)/%.css,Styles/%+Fonts.py,$(serialcsses))

serial: $(serialstyles) $(serialstylepys);
$(serialclsstyles): Styles/%: $(srcdir)/%
	[[ -d Styles ]] || mkdir Styles
	ln -fs "$(realpath $<)" $@
$(serialcssnofontstyles): Styles/%-Fonts.css: $(srcdir)/%.css
	[[ -d Styles ]] || mkdir Styles
	ln -fs "$(realpath $<)" $@
$(serialcssfontstyles): Styles/%+Fonts.css: $(srcdir)/%.css $(srcdir)/+Fonts.css
	[[ -d Styles ]] || mkdir Styles
	cat "$<" "$(srcdir)/+Fonts.css" > $@
$(serialstylepys): $(srcdir)/SerialStyle.py; ln -fs "$(realpath $<)" $@
clobber distclean gone: ; rm -f $(serialstyles)
.PHONY: serial clobber distclean gone
