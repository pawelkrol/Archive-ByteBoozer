#!/usr/bin/perl

use ExtUtils::MakeMaker;

WriteMakefile(
    NAME              => 'Archive::ByteBoozer',
    VERSION_FROM      => 'lib/Archive/ByteBoozer.pm',
    PREREQ_PM         => {
                             Data::Dumper        => undef,
                             File::Temp          => undef,
                             IO::Capture::Stdout => undef,
                             IO::File            => undef,
                             IO::Scalar          => undef,
                             Params::Validate    => undef,
                             Scalar::Util        => undef,
                             Test::Deep          => undef,
                             Test::Exception     => undef,
                             Test::More          => undef,
                         },
    ($] >= 5.005 ?
      (AUTHOR         => 'Pawel Krol <pawelkrol@cpan.org>') : ()),
    DEFINE            => '',
    OBJECT            => 'ByteBoozer.o cruncher.o',
    OPTIMIZE          => '-O2',
    PL_FILES          => { 'PatchBool.PL' => 'PatchBool' },
    depend            => { 'pm_to_blib' => 'PatchBool' },
);
