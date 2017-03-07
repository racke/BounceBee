use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'BounceBee',
    AUTHOR           => q{Stefan Hornburg (Racke) <racke@linuxia.de>},
    VERSION_FROM     => 'lib/BounceBee.pm',
    ABSTRACT_FROM    => 'lib/BounceBee.pm',
    LICENSE          => 'artistic_2',
    PL_FILES         => {},
    EXE_FILES        => ['bin/bounce-bee'],
    MIN_PERL_VERSION => 5.006,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
    },
    PREREQ_PM => {
        # OO
        'Moo' => 2,
        'Type::Tiny' => 0,

        # File tools
        'Path::Tiny' => 0,

        # Sisimai (for "delivered" reason)
        'Sisimai' => '4.16.0',
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'BounceBee-*' },
    META_MERGE        => {
        resources => {
            repository  => 'https://github.com/racke/BounceBee.git',
            bugtracker => 'https://github.com/racke/BounceBee/issues',
            IRC => 'irc://irc.freenode.net/#interchange',
        },
    },

);
