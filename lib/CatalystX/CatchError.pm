package CatalystX::CatchError;

use Moose::Role;

requires qw/ end /;

# ABSTRACT: custom error handling in your controller.

=head1 SYNOPSIS
    package MyApp::Controller::Root;
    with 'CatalystX::CatchError';

    sub catch_error : Private {
        my ($self, $c, @errors) = @_;
        # stuff
    }

=head1 DESCRIPTION

=cut

before 'end' => sub {
    my ( $self, $c ) = @_;
    if ( $c->has_errors ) {
        if ( $self->can('catch_error') ) {
            $c->forward( $self->action_for('catch_error'), [ @{ $c->error } ] );
            $c->clear_errors;
        }
        else {
            die "method 'catch_error' not found.";
        }
    }
};

1;
