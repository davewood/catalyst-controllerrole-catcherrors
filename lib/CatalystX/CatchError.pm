package CatalystX::CatchError;

use Moose::Role;

requires qw/ catch_errors end /;

# ABSTRACT: custom error handling in your controller.

=head1 SYNOPSIS
    package MyApp::Controller::Root;
    with 'CatalystX::CatchError';

    sub catch_error : Private {
        my ($self, $c, @errors) = @_;
        # stuff
    }

=head1 DESCRIPTION
By default L<Catalyst|Catalyst::Runtime> renders a HTML page if it encounters an error.
One usecase where this is problematic is you create a REST API using
L<Catalyst::Action::REST>. If you apply the CatalystX::CatchError role
to your controller you can provide a method that receives an array of
all errors that occurred during the request and do with them whatever
you want.
If you do not want to catch an error you have to rethrow it.
CatalystX::CatchError passes a copy of the errors to your method and clears
the original ones.

=cut

before 'end' => sub {
    my ( $self, $c ) = @_;
    if ( $c->has_errors ) {
        my @errors = @{ $c->error };
        $c->clear_errors;
        $c->forward( $self->action_for('catch_errors'), \@errors );
    }
};

1;
