#!/usr/bin/perl -w

use strict;
use warnings;
use lib 't/lib';
use XSP::Test tests => 2;

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
X::foo( int a )
  CODE:
    try {
      RETVAL = THIS->foo( a );
    }
    catch (std::exception& e) {
      croak("Caught C++ exception of type or derived from 'std::exception': %s", e.what());
    }
    catch (...) {
      croak("Caught C++ exception of unknown type");
    }
  OUTPUT: RETVAL

