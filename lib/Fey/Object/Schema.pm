package Fey::Object::Schema;

use strict;
use warnings;

use MooseX::StrictConstructor;

extends 'Moose::Object';


sub EnableObjectCaches
{
    my $class = shift;

    $_->EnableObjectCache() for $class->_TableClasses();
}

sub DisableObjectCaches
{
    my $class = shift;

    $_->DisableObjectCache() for $class->_TableClasses();
}

sub ClearObjectCaches
{
    my $class = shift;

    $_->ClearObjectCache() for $class->_TableClasses();
}

sub _TableClasses
{
    my $class = shift;

    my $schema = $class->Schema();

    return Fey::Meta::Class::Table->ClassForTable( $schema->tables() );
}

sub RunInTransaction
{
    my $class  = shift;
    my $sub    = shift;
    my $source = shift || $class->DBIManager()->default_source();

    my $in_tran;

    my $dbh = $source->dbh();

    unless ( $source->allows_nested_transactions()
             || $dbh->{AutoCommit} )
    {
        $in_tran = 1;
    }

    my $wantarray = wantarray;

    my @r;

    eval
    {
        $dbh->begin_work()
            unless $in_tran;

        if ( $wantarray )
        {
            @r = $sub->();
        }
        elsif ( defined $wantarray )
        {
            $r[0] = $sub->();
        }
        else
        {
            $sub->();
        }

        $dbh->commit()
            unless $in_tran;
    };

    if ( my $e = $@ )
    {
        $dbh->rollback
            unless $in_tran;
        die $e;
    }

    return unless defined $wantarray;

    return $wantarray ? @r : $r[0];
}

1;

__END__

=head1 NAME

Fey::Object::Schema - Base class for schema-based objects

=head1 SYNOPSIS

  package MyApp::Schema;

  use Fey::ORM::Schema;

  has_schema(...);

=head1 DESCRIPTION

This class is a the base class for all schema-based objects.

=head1 METHODS

This class provides the following methods:

=head2 $class->EnableObjectCaches()

Enables the object class for all of the table classes associated with
this class's schema.

=head2 $class->DisableObjectCaches()

Disables the object class for all of the table classes associated with
this class's schema.

=head2 $class->ClearObjectCaches()

Clears the object class for all of the table classes associated with
this class's schema.

=head2 $class->RunInTransaction( $coderef, $source )

Given a code ref, this method will begin a transaction and execute the
coderef. If the coderef runs normally (no exceptions), it commits,
otherwise it rolls back and rethrows the error.

This method will handle nested transactions gracefully if your
DBMS does not. It doesn't emulate actual partial commits, but it
does prevent DBI from throwing an error.

The second argument can be a C<Fey::DBIManager::Source> object. If no
source is specified, then this method will use the default source.

=head1 AUTHOR

Dave Rolsky, <autarch@urth.org>

=head1 BUGS

See L<Fey::ORM> for details.

=head1 COPYRIGHT & LICENSE

Copyright 2006-2008 Dave Rolsky, All Rights Reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. The full text of the license
can be found in the LICENSE file included with this module.

=cut