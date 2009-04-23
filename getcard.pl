#!/usr/bin/perl

my $card=`/usr/bin/opensc-tool --serial`;
my @validcards;

$card =~ s/\D//g;
print "$card\n";
