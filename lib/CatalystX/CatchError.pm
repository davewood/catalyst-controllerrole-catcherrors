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

sub BUILD {
    my $self = shift;

    if ( !$self->can('catch_error') ) {
        die "method 'catch_error' not found.";
    }
}

before 'end' => sub {
    my ( $self, $c ) = @_;
    if ( $c->has_errors ) {
        $c->forward( $self->action_for('catch_error'), [ @{ $c->error } ] );
        $c->clear_errors;
    }
};

1;
