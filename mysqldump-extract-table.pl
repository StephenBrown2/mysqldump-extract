#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Std;

getopts('d:f:', \my %opts);

foreach (@ARGV) {
    die "Usage: $0 -f file [-d database] table [table]...\n" if (/-/ or !$opts{f});
}

unless (exists $opts{f}) {
    print "Must specify a file to extract from.\n";
    exit;
}
unless ( $#ARGV >= 1) {
    print "Must specify at least one table to extract";
    exit;
}

my $filename = $opts{f};
my $database = exists $opts{d} ? $opts{d} : '';
my $table_s = join( "|", @ARGV);

print "USE $database;\n\n" if (exists $opts{d});

open DUMPFILE, '<', $filename;
my $printthis = 0;

while (<DUMPFILE>) {
    $printthis = (/\`($table_s)\`/) ? 1 : 0 if (/-- Table structure for table/);
    print if $printthis;
}

