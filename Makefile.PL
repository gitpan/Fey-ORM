
use strict;
use warnings;



use ExtUtils::MakeMaker 6.31;



my %WriteMakefileArgs = (
  'ABSTRACT' => 'A Fey-based ORM (If you like SQL, you might like Fey::ORM)',
  'AUTHOR' => 'Dave Rolsky <autarch@urth.org>',
  'BUILD_REQUIRES' => {
    'Fey::Test' => '0.05',
    'Test::Exception' => '0',
    'Test::More' => '0.88'
  },
  'CONFIGURE_REQUIRES' => {
    'ExtUtils::MakeMaker' => '6.31'
  },
  'DISTNAME' => 'Fey-ORM',
  'EXE_FILES' => [],
  'LICENSE' => 'perl',
  'NAME' => 'Fey::ORM',
  'PREREQ_PM' => {
    'Devel::GlobalDestruction' => '0',
    'Exception::Class' => '0',
    'Fey' => '0.39',
    'Fey::DBIManager' => '0.07',
    'List::AllUtils' => '0',
    'Moose' => '1.15',
    'MooseX::ClassAttribute' => '0.17',
    'MooseX::SemiAffordanceAccessor' => '0',
    'MooseX::StrictConstructor' => '0.08',
    'MooseX::Types' => '0',
    'Object::ID' => '0',
    'Scalar::Util' => '0',
    'Sub::Exporter' => '0',
    'namespace::autoclean' => '0'
  },
  'VERSION' => '0.41',
  'test' => {
    'TESTS' => 't/*.t t/Class/*.t t/Object/*.t t/Object/Iterator/*.t t/Object/Iterator/FromSelect/*.t'
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



