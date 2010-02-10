#!/usr/bin/perl -w

use strict;
use warnings;
use t::lib::XSP::Test tests => 2;

run_diff xsp_stdout => 'expected';

__DATA__

=== Verbatim blocks
--- xsp_stdout
%module{Foo};
%package{Foo};

%{
Straight to XS, no checks...
%}
--- expected
#include <exception>


MODULE=Foo

MODULE=Foo PACKAGE=Foo


Straight to XS, no checks...

=== Space after verbatim blocks
--- xsp_stdout
%module{Foo};

class X
{
%{
Straight to XS, no checks...
%}
    int foo(int a);
};
--- expected
#include <exception>


MODULE=Foo

MODULE=Foo PACKAGE=X


Straight to XS, no checks...


int
X::foo( a )
    int a
  CODE:
    try {
      RETVAL = THIS->foo( a );
    } catch (std::exception& e) {
      croak("Caught unhandled C++ exception: %s", e.what());
    } catch (...) {
      croak("Caught unhandled C++ exception of unknown type");
    }
  OUTPUT: RETVAL

