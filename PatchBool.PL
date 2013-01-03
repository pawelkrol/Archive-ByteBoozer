#!/usr/bin/perl

# Fix for "two or more data types in declaration specifiers" compilation error:
system qq{perl -pi -e 's/bool(?=[ ;])/boolean/g' *.c *.h};

# Fix for infinite loop of "Error (C-1): Packed file too large" runtime error:
my $old_code = q{uint len = plainLen \\% 255;};
my $new_code = q{uint len = (plainLen \\% 255) \\? plainLen \\% 255 : 255;};
system qq{perl -pi -e 's/${old_code}/${new_code}/g' cruncher.c\n};
