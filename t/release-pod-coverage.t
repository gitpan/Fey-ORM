
BEGIN {
  unless ($ENV{RELEASE_TESTING}) {
    require Test::More;
    Test::More::plan(skip_all => 'these tests are for release candidate testing');
  }
}

use strict;
use warnings;

use Test::More 0.88;
use Test::Pod::Coverage 1.04;
use Pod::Coverage::Moose;

my %Exclude = map { $_ => 1 } qw(
    Fey::Hash::ColumnsKey
    Fey::Meta::Method::Constructor
    Fey::Meta::Role::FromSelect
    Fey::Meta::Role::Relationship::ViaFK
);

my @mods = grep { !$Exclude{$_} } Test::Pod::Coverage::all_modules();

plan tests => scalar @mods;

my %Trustme = (
    'Fey::ORM::Schema'              => qr/^init_meta$/,
    'Fey::ORM::Table'               => qr/^init_meta$/,
    'Fey::Meta::Method::FromSelect' => qr/^new$/,
);

for my $mod (@mods) {
    my @trustme = qr/^BUILD$/;
    push @trustme, $Trustme{$mod} if $Trustme{$mod};

    pod_coverage_ok(
        $mod, {
            coverage_class => 'Pod::Coverage::Moose',
            trustme        => \@trustme,
        },
        "pod coverage for $mod"
    );
}
