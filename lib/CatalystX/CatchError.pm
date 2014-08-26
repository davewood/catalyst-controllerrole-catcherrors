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

has 'catch_error_method' => (
    is      => 'ro',
    isa     => 'Str',
    default => 'catch_error',
);

sub BUILD {
    my $self = shift;

    if ( !$self->can($self->catch_error_method) ) {
        die "method '" . $self->catch_error_method . "' not found.";
    }
}

before 'end' => sub {
    my ( $self, $c ) = @_;
    if ( $c->has_errors ) {
        my @errors = @{ $c->error };
        $c->clear_errors;
        $c->forward( $self->action_for($self->catch_error_method), \@errors );
    }
};

1;
