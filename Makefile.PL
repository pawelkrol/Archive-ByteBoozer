#!/usr/bin/perl

use ExtUtils::MakeMaker;

WriteMakefile(
    NAME              => 'Archive::ByteBoozer',
    VERSION_FROM      => 'lib/Archive/ByteBoozer.pm',
    PREREQ_PM         => {
                             Capture::Tiny    => 0,
                             Data::Dumper     => 0,
                             File::Temp       => 0,
                             IO::File         => 0,
                             IO::Scalar       => 0,
                             Params::Validate => '1.21',
                             Scalar::Util     => 0,
                             Test::Deep       => 0,
                             Test::Exception  => 0,
                             Test::More       => 0,
                         },
    ($] >= 5.005 ?
      (AUTHOR         => 'Pawel Krol <djgruby@gmail.com>') : ()),
    DEFINE            => '',
    OBJECT            => 'ByteBoozer.o cruncher.o',
    OPTIMIZE          => '-O2',
    META_MERGE        => {
        'meta-spec' => {
            'version' => 2,
        },
        'resources' => {
            'bugtracker' => {
                'web' => 'https://github.com/pawelkrol/Archive-ByteBoozer/issues',
            },
            'repository' => {
                'type' => 'git',
                'url'  => 'git://github.com/pawelkrol/Archive-ByteBoozer.git',
                'web'  => 'https://github.com/pawelkrol/Archive-ByteBoozer.git',
            },
        },
    },
);
