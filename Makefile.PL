
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "A Fey-based ORM (If you like SQL, you might like Fey::ORM)",
  "AUTHOR" => "Dave Rolsky <autarch\@urth.org>",
  "BUILD_REQUIRES" => {},
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "Fey-ORM",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "Fey::ORM",
  "PREREQ_PM" => {
    "Class::Load" => 0,
    "Class::MOP::Method::Generated" => 0,
    "Devel::GlobalDestruction" => 0,
    "Exception::Class" => 0,
    "Fey" => "0.39",
    "Fey::DBIManager" => "0.07",
    "Fey::Exceptions" => 0,
    "Fey::Literal::Function" => 0,
    "Fey::Placeholder" => 0,
    "Fey::SQL" => 0,
    "Fey::Table" => 0,
    "List::AllUtils" => 0,
    "List::Util" => 0,
    "Moose" => "1.15",
    "Moose::Exporter" => 0,
    "Moose::Meta::Attribute" => 0,
    "Moose::Meta::Class" => 0,
    "Moose::Meta::Method" => 0,
    "Moose::Meta::Method::Constructor" => 0,
    "Moose::Role" => 0,
    "Moose::Util::MetaRole" => 0,
    "Moose::Util::TypeConstraints" => 0,
    "MooseX::ClassAttribute" => "0.24",
    "MooseX::Params::Validate" => 0,
    "MooseX::SemiAffordanceAccessor" => 0,
    "MooseX::StrictConstructor" => "0.13",
    "MooseX::Types" => 0,
    "MooseX::Types::Combine" => 0,
    "MooseX::Types::Moose" => 0,
    "Object::ID" => 0,
    "Scalar::Util" => 0,
    "Sub::Exporter" => 0,
    "Try::Tiny" => 0,
    "base" => 0,
    "namespace::autoclean" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "TEST_REQUIRES" => {
    "Exporter" => 0,
    "Fey::FakeDBI" => 0,
    "Fey::Literal::String" => 0,
    "Fey::Test" => "0.05",
    "Test::Fatal" => 0,
    "Test::More" => "0.88",
    "lib" => 0
  },
  "VERSION" => "0.46",
  "test" => {
    "TESTS" => "t/*.t t/Class/*.t t/Object/*.t t/Object/Iterator/*.t t/Object/Iterator/FromSelect/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  my $tr = delete $WriteMakefileArgs{TEST_REQUIRES};
  my $br = $WriteMakefileArgs{BUILD_REQUIRES};
  for my $mod ( keys %$tr ) {
    if ( exists $br->{$mod} ) {
      $br->{$mod} = $tr->{$mod} if $tr->{$mod} > $br->{$mod};
    }
    else {
      $br->{$mod} = $tr->{$mod};
    }
  }
}

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



