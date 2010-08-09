use ExtUtils::MakeMaker;

$PREREQS = {
    'Test::More'                => 0,
    'YAML'                      => 0,
    'Dancer'                    => 1.1803,
    'Dancer::Plugin::REST'      => 0,
    'DateTime'                  => 0,
    'DateTime::Format::MySQL'   => 0,
    'Plack'                     => 0,
    'Plack::Runner'             => 0
};

WriteMakefile(
    NAME                => 'atoms',
    AUTHOR              => q{YOUR NAME <youremail@example.com>},
    VERSION_FROM        => 'lib/atoms.pm',
    ABSTRACT            => 'YOUR APPLICATION ABSTRACT',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => $PREREQS,
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'atoms-*' },
);
