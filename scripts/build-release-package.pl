#!/usr/bin/perl

use strict;
use warnings;

use Cwd;
use Data::Dumper;
use File::Copy;
use File::Path qw(make_path);
use File::Temp qw(tempdir);
use FindBin qw($Bin);
use Getopt::Long;


my $help;
my $output_dir;
my $manifest_file = 'MANIFEST';
my $package_name  = 'Archive-ByteBoozer';
my $version_from  = 'lib/Archive/ByteBoozer.pm';

GetOptions(
    'help'         => \$help,
    'output-dir=s' => \$output_dir,
);

help() if $help or not defined $output_dir or not -d $output_dir;

my $version_number = get_version_number($version_from);
my $project_dir = sprintf '%s-%s', $package_name, $version_number;
my $target_name = sprintf '%s.tar.gz', $project_dir;
my $target_file = sprintf '%s/%s', $output_dir, $target_name;

die "File already exists: $target_file" if -e $target_file;

print <<DETAILS;

Building a new release package of "$package_name" project:

  * version number: $version_number
  * target file: $target_file

DETAILS

my $temp_dir = tempdir(CLEANUP => 1);

my $build_dir = setup_build_dir($temp_dir, $project_dir, $manifest_file);

fix_compilation_errors($build_dir);
compress_files($build_dir, $target_file, $target_name);

print "\nBuild successful!\n\n";

sub get_version_number {
    my ($version_from) = @_;

    my $command = sprintf q{grep -e 'our $VERSION' %s | awk '{print $4}' | sed -e "s/[';]//g"}, $version_from;

    my $version_number = `$command`;
    chomp $version_number;

    return $version_number;
}

sub setup_build_dir {
    my ($temp_dir, $project_dir, $manifest_file) = @_;

    my $build_dir = sprintf '%s/%s', $temp_dir, $project_dir;

    mkdir $build_dir;

    my $manifest = `cat $manifest_file`;
    $manifest =~ s/\r\n/\n/g;

    print "Copying files:\n";

    my @filelist = split "\n", $manifest;
    for my $file (@filelist) {

        my $source = sprintf '%s/../%s', $Bin, $file;
        my $target = sprintf '%s/%s', $build_dir, $file;

        (my $target_path = $target) =~ s!/[^/]+$!!;
        make_path($target_path, { verbose => 0, mode => 0755 });

        printf "\n  * from: %s", $source;
        printf "\n      to: %s\n", $target;

        copy($source, $target) or die "\nCopy failed: $!";
    }

    return $build_dir;
}

sub fix_compilation_errors {
    my ($build_dir) = @_;

    print "\nFixing compilation errors:\n\n";

    my $dir = getcwd;
    chdir $build_dir;

    print "  * remove mac/windows new line characters\n";
    my $command = q{find ./ -type f | xargs perl -i -pne 's/\\r\\n?/\\n/g;'};
    print "\n    $command\n";
    system $command;

    printf "\n  * %s\n", "error: expected ';', identifier or '(' before 'char'";
    $command = q{perl -pi -e 's/bool(?=[ ;])/_bool/g' *.c *.h};
    print "\n    $command\n";
    system $command;

    printf "\n  * %s\n", "error: expected identifier before numeric constant";
    $command = q{perl -pi -e 's/true(?=[ ;)])/_true/g' *.c *.h};
    print "\n    $command";
    system $command;
    $command = q{perl -pi -e 's/false(?=[ ;)])/_false/g' *.c *.h};
    print "\n    $command\n";
    system $command;

    print qq{\n  * include additional header files in "cruncher.h"\n};
    $command = q{perl -pi -e 's/^#include "bb.h"/#include <strings.h>\n$&/' cruncher.h};
    print "\n    $command\n";
    system $command;
    $command = q{perl -pi -e 's/^#include "bb.h"/#include <stdlib.h>\n\n$&/' cruncher.h};
    print "    $command\n";
    system $command;

    printf "\n  * %s\n", "error: two or more data types in declaration specifiers";
    $command = q{perl -pi -e 's!^#include "bb.h"$!#include "file.h" // $&!' cruncher.h};
    print "\n    $command\n";
    system $command;
    $command = q{perl -pi -e 's!^#include "file.h"$!#include "bb.h" // $&!' cruncher.h};
    print "    $command\n";
    system $command;
    $command = q{perl -pi -e 's!^#include "bb.h"$!// $&!' file.h};
    print "    $command\n";
    system $command;
    $command = q{perl -pi -e 's!^#include <sys/stat.h>$!$&\n\n#include "bb.h"!' file.h};
    print "    $command\n";
    system $command;

    printf "\n  * %s\n", "error: ByteBoozer.so: undefined symbol 'outLen'";
    $command = q{sed -i 's/^inline/static inline/' cruncher.c};
    print "\n    $command\n";
    system $command;

    chdir $dir;

    return;
}

sub compress_files {
    my ($build_dir, $target_file, $target_name) = @_;

    printf qq{\nCompressing project build into "tar.gz" archive:\n\n  * target file: %s\n\n}, $target_name;

    my $dir = getcwd;
    chdir $build_dir;

    my $command = 'perl Makefile.PL && make dist';
    print "    $command\n\n";
    system $command;


    $command = sprintf 'mv %s %s', $target_name, $target_file;
    print "\n    $command\n";
    system $command;

    chdir $dir;

    return;
}

sub help {
    print <<USAGE;

Usage: $0 <OPTIONS>

    --output-dir=<DIRECTORY> - set (mandatory) output directory
    --help                   - show this help message

USAGE

    exit;
}
