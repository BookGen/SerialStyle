# Creates links from `$srcdir/*.c[ls]s` to `Styles/*.c[ls]s`.
#
# Example usage from within another Makefile ( assuming `all` and `clean` are defined elsewhere ) :
#
# 	style: ; $(MAKE) -f FellStyle/Makefile
# 	.PHONY: style

SHELL = /bin/sh
srcdir := $(patsubst %/Makefile,%,$(lastword $(MAKEFILE_LIST)))
fellsrcs := $(wildcard $(srcdir)/*.c[ls]s)
fellstyles := $(patsubst $(srcdir)/%,Styles/%,$(fellsrcs))

fell: $(fellstyles);
$(fellstyles): Styles/%: $(srcdir)/%; ln -fs "$(realpath $<)" $@
clobber distclean gone: ; rm -f $(fellstyles)
.PHONY: fell clobber distclean gone
