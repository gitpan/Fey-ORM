package Fey::Meta::Role::FromSelect;
BEGIN {
  $Fey::Meta::Role::FromSelect::VERSION = '0.33';
}

use strict;
use warnings;
use namespace::autoclean;

use Moose::Role;
use Moose::Util::TypeConstraints;

has select => (
    is       => 'ro',
    required => 1,
    does     => 'Fey::Role::SQL::ReturnsData',
);

has bind_params => (
    is  => 'ro',
    isa => 'CodeRef',
);

has is_multi_column => (
    is      => 'ro',
    isa     => 'Bool',
    default => 0,
);

sub _make_sub_from_select {
    my $class        = shift;
    my $select       = shift;
    my $bind_sub     = shift;
    my $is_multi_col = shift;

    die 'The select parameter must be do the Fey::Role::SQL::ReturnsData role'
        unless blessed $select
            && $select->can('does')
            && $select->does('Fey::Role::SQL::ReturnsData');

    if (@_) {
        return $class->_make_default_from_select_with_type(
            $select,
            $bind_sub,
            $is_multi_col,
            shift,
        );
    }
    else {
        return $class->_make_default_from_select_without_type(
            $select,
            $bind_sub,
            $is_multi_col
        );
    }
}

sub _make_default_from_select_with_type {
    my $class        = shift;
    my $select       = shift;
    my $bind_sub     = shift;
    my $is_multi_col = shift;
    my $type         = shift;

    my $wantarray = 0;
    $wantarray = 1
        if defined $type
            && find_type_constraint($type)->is_a_type_of('ArrayRef');

    my $select_meth
        = $is_multi_col ? 'selectall_arrayref' : 'selectcol_arrayref';

    return sub {
        my $self = shift;

        my $dbh = $self->_dbh($select);

        my @select_p = (
            $select->sql($dbh), {},
            $bind_sub ? $self->$bind_sub() : ()
        );

        my $return = $dbh->$select_meth(@select_p)
            or return;

        return $wantarray ? $return : $return->[0];
    };
}

sub _make_default_from_select_without_type {
    my $class        = shift;
    my $select       = shift;
    my $bind_sub     = shift;
    my $is_multi_col = shift;

    my $select_meth
        = $is_multi_col ? 'selectall_arrayref' : 'selectcol_arrayref';

    return sub {
        my $self = shift;

        my $dbh = $self->_dbh($select);

        my @select_p = (
            $select->sql($dbh), {},
            $bind_sub ? $self->$bind_sub() : ()
        );

        my $return = $dbh->$select_meth(@select_p)
            or return;

        return wantarray ? @{$return} : $return->[0];
    };
}

1;

__END__
=pod

=head1 NAME

Fey::Meta::Role::FromSelect

=head1 VERSION

version 0.33

=head1 AUTHOR

  Dave Rolsky <autarch@urth.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Dave Rolsky.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

