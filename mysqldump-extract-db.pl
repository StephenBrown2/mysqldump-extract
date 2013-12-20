#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Std;

getopts('d:f:', \my %opts);

foreach (@ARGV) {
    die "Usage: $0 -f file -d database\n" if (/-/ or !$opts{f});
}

unless (exists $opts{d} and exists $opts{f}) {
    print "Must specify a file to extract from and a database to extract.";
    exit;
}

my $database = $opts{d};
my $filename = $opts{f};

open DUMPFILE, '<', $filename or die "Could not open $filename";
my $printthis = 1;  # Print the initial header information.
                    # This bit will get flipped if the first database does not match.

while (<DUMPFILE>) {
    print "This is not a multi-database dump file.\n" and exit if /-- Host:[\s\w]*Database:\s*[[:alpha:]]+$/;
    $printthis = (/\`($database)\`/) ? 1 : 0 if (/-- Current Database:/);
    print if $printthis;
}
