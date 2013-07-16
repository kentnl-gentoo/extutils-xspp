#!/usr/bin/perl -w

use strict;
use warnings;
use t::lib::XSP::Test tests => 2;

run_diff xsp_stdout => 'expected';

__DATA__

=== Handle class/method/function annotations
--- xsp_stdout
%module{Foo};
%package{Foo};
%loadplugin{TestParserPlugin};

int foo(int y) %MyFuncRename{Foo};

class klass
{
    %MyClassRename{Klass};

    klass() %MyMethodRename{newKlass};

    void bar() %MyMethodRename{Bar};
};
--- expected
TYPEMAP: <<END
TYPEMAP
klass*	O_OBJECT

END
# XSP preamble


MODULE=Foo

MODULE=Foo PACKAGE=Foo

int
Foo( int y )
  CODE:
    try {
      RETVAL = foo( y );
    }
    catch (std::exception& e) {
      croak("Caught C++ exception of type or derived from 'std::exception': %s", e.what());
    }
    catch (...) {
      croak("Caught C++ exception of unknown type");
    }
  OUTPUT: RETVAL


MODULE=Foo PACKAGE=Klass

#undef  xsp_constructor_class
#define xsp_constructor_class(c) (CLASS)

static klass*
klass::newKlass()
  CODE:
    try {
      RETVAL = new klass();
    }
    catch (std::exception& e) {
      croak("Caught C++ exception of type or derived from 'std::exception': %s", e.what());
    }
    catch (...) {
      croak("Caught C++ exception of unknown type");
    }
  OUTPUT: RETVAL

#undef  xsp_constructor_class
#define xsp_constructor_class(c) (c)

void
klass::Bar()
  CODE:
    try {
      THIS->bar();
    }
    catch (std::exception& e) {
      croak("Caught C++ exception of type or derived from 'std::exception': %s", e.what());
    }
    catch (...) {
      croak("Caught C++ exception of unknown type");
    }

=== Handle top level directives
--- xsp_stdout
%module{Foo};
%package{Foo};
%loadplugin{TestParserPlugin};

%MyDirective{Foo};

--- expected
# XSP preamble


MODULE=Foo

MODULE=Foo PACKAGE=Foo

// Foo
