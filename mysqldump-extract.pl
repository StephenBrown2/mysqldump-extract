#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;

my $file;
my $db;
my @table;

GetOptions( 'd|database=s' => \$db,
            'f|file=s' => \$file,
            't|table|tables=s{,}' => \@table);

foreach (@ARGV) {
    die "Usage: $0 -f file [-d database] [-t table [table]...]\n" if (/-/ or !$file);
}

unless (defined $file) {
    print "Must specify a file to extract from.\n";
    exit;
}

unless (defined $db or scalar @table) {
    print "Must specify a database or at least one table to extract.\n";
    exit;
}

my $filename = $file;
my $database = defined $db ? $db : '';
my $table_s = (scalar @table) ? join( "|", @table) : '.*';

open DUMPFILE, '<', $filename or die "Could not open $filename.\n";
my $printthis = 0;
my $dbmatch = 0;

print "USE $database;\n\n" if (defined $database) && ($database ne '');

print &db_in_file . "\n";

#while (<DUMPFILE>) {
#    if (my ($match) = ($_ =~ /-- Host:[\s\w]*Database:\s*(\w+)$/)) {
#        if ($database ne $match) {
#            print "This is a dump file for $match, not the database specified ($database).\n";
#            exit;
#        } else {
#        }
#    }
#    $printthis = (/\`($database)\`/) ? 1 : 0 if ( defined $database and /-- Current Database:/ );
#    $printthis = (/\`($table_s)\`/) ? 1 : 0 if ( scalar @table and /-- Table structure for table/ );
#    print if $printthis;
#}

sub db_in_file {
    my $match;
    while (<DUMPFILE>) {
        last if (($match) = (/-- Host:[\s\w]*Database:\s*(\w*)$/));
    }
    return ($match ne '' ? $match : 'multi');
}
