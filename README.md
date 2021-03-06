Archive-ByteBoozer
==================

[![CPAN version](https://badge.fury.io/pl/Archive-ByteBoozer.png)](https://metacpan.org/pod/Archive::ByteBoozer)

Archive::ByteBoozer package provides a Perl interface to David Malmborg's "ByteBoozer", a data cruncher for Commodore files written in C. The following operations are supported: reading data from any given IO:: interface, packing data using the compression algorithm implemented via "ByteBoozer", and writing data into any given IO:: interface.

VERSION
-------

Version 0.10 (2018-11-26)

INSTALLATION
------------

To install this module type the following:

    perl Makefile.PL
    make
    make test
    make install

DOCUMENTATION
-------------

A comprehensive module documentation is available on [CPAN](https://metacpan.org/pod/Archive::ByteBoozer).

COPYRIGHT AND LICENCE
---------------------

ByteBoozer cruncher/decruncher:

Copyright (C) 2004-2006, 2008-2009, 2012 David Malmborg.

Archive::ByteBoozer Perl interface:

Copyright (C) 2012-2013, 2016, 2018 by Pawel Krol.

This library is free open source software; you can redistribute it and/or modify it under the same terms as Perl itself, either Perl version 5.8.6 or, at your option, any later version of Perl 5 you may have available.

PLEASE NOTE THAT IT COMES WITHOUT A WARRANTY OF ANY KIND!
