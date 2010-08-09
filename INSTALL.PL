require 'Makefile.PL';
my @MODULES = ();

system 'cpan -if ' . join ' ', keys %{$PREREQS};