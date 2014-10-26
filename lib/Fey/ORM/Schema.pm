package Fey::ORM::Schema;

use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.31';

use Fey::Meta::Class::Schema;
use Fey::Object::Schema;

use Moose 0.98 ();
use Moose::Exporter;
use MooseX::Params::Validate qw( pos_validated_list );

Moose::Exporter->setup_import_methods(
    with_meta => [qw( has_schema )],
    also      => 'Moose'
);

sub init_meta {
    shift;
    my %p = @_;

    return Moose->init_meta(
        %p,
        base_class => 'Fey::Object::Schema',
        metaclass  => 'Fey::Meta::Class::Schema',
    );
}

sub has_schema {
    my $meta = shift;

    my ($schema) = pos_validated_list( \@_, { isa => 'Fey::Schema' } );

    $meta->_associate_schema($schema);
}

1;

__END__

=head1 NAME

Fey::ORM::Schema - Provides sugar for schema-based classes

=head1 SYNOPSIS

  package MyApp::Schema;

  use Fey::ORM::Schema;

  has_schema ...;

  no Fey::ORM::Schema;

=head1 DESCRIPTION

Use this class to associate your class with a schema. It exports a
number of sugar functions to allow you to define things in a
declarative manner.

=head1 EXPORTED FUNCTIONS

This package exports the following functions:

=head2 has_schema($schema)

Given a L<Fey::Schema> object, this method associates that schema with
the calling class.

=head1 AUTHOR

Dave Rolsky, <autarch@urth.org>

=head1 BUGS

See L<Fey::ORM> for details.

=head1 COPYRIGHT & LICENSE

Copyright 2006-2009 Dave Rolsky, All Rights Reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. The full text of the license
can be found in the LICENSE file included with this module.

=cut
