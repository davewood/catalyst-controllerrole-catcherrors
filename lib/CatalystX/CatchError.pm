package CatalystX::CatchError;

use Moose::Role;

requires qw/ catch_errors end /;

# ABSTRACT: custom error handling in your controller.

=head1 SYNOPSIS

    package MyApp::Controller::Root;
    use Moose;
    BEGIN { extends 'Catalyst::Controller' }
    with 'CatalystX::CatchError';

    sub catch_errors : Private {
        my ($self, $c, @errors) = @_;
        # stuff
    }

=head1 DESCRIPTION
If an action throws and error the default behaviour of L<Catalyst|Catalyst::Runtime>
is to render a default error page and set the response code to 500.
One usecase where this is problematic is if you have a REST Controller using
L<Catalyst::Action::REST>. If you apply the C<CatalystX::CatchError> role
to your controller you can provide a C<catch_errors> action that receives an array of
all errors that occurred during the request and do with them whatever you want.
You can even rethrow the error. C<CatalystX::CatchError> passes a copy of the errors
to your method and clears the original ones before calling C<catch_errors>.

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
