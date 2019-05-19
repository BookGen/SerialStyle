# Creates links from `$srcdir/*.c[ls]s` to `Styles/*.c[ls]s`.
#
# Example usage from within another Makefile:
#
# 	serialstyle: ; $(MAKE) -f SerialStyle/Makefile
# 	.PHONY: serialstyle

SHELL = /bin/sh
srcdir := $(patsubst %/Makefile,%,$(lastword $(MAKEFILE_LIST)))
serialsrcs := $(wildcard $(srcdir)/*.c[ls]s)
serialstyles := $(patsubst $(srcdir)/%,Styles/%,$(serialsrcs))

serial: $(serialstyles);
$(serialstyles): Styles/%: $(srcdir)/%
	[[ -d Styles ]] || mkdir Styles
	ln -fs "$(realpath $<)" $@
clobber distclean gone: ; rm -f $(serialstyles)
.PHONY: serial clobber distclean gone
