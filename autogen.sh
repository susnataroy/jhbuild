#!/bin/sh
# Run this to generate all the initial makefiles, etc.

test -n "$srcdir" || srcdir=`dirname "$0"`
test -n "$srcdir" || srcdir=.

olddir=`pwd`
cd $srcdir

AUTORECONF=`which autoreconf`
if test -z $AUTORECONF; then
        echo "*** No autoreconf found, please intall it ***"
        exit 1
fi

GNOMEDOC=`which yelp-build`
if test -z $GNOMEDOC; then
        echo "*** The tools to build the documentation are not found,"
        echo "    documentation will not be builded ***"
fi

INTLTOOLIZE=`which intltoolize`
if test -z $INTLTOOLIZE; then
        echo "*** No intltoolize found, please install the intltool package ***"
        exit 1
fi

# if the AC_CONFIG_MACRO_DIR() macro is used, create that directory
# This is a automake bug fixed in automake 1.13.2
# See http://debbugs.gnu.org/cgi/bugreport.cgi?bug=13514
m4dir=`autoconf --trace 'AC_CONFIG_MACRO_DIR:$1'`
if [ -n "$m4dir" ]; then
  mkdir -p $m4dir
fi

autoreconf --force --install --verbose || exit $?
intltoolize --automake --copy || exit $?

cd $olddir
test -n "$NOCONFIGURE" || "$srcdir/configure" "$@"
