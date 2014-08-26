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

has 'catch_error_method' => (
    is      => 'ro',
    isa     => 'Str',
    default => 'catch_error',
);

sub BUILD { }
after BUILD => sub {
    my $self = shift;

    if ( !$self->can($self->catch_error_method) ) {
        die "method '" . $self->catch_error_method . "' not found.";
    }
};

before 'end' => sub {
    my ( $self, $c ) = @_;
    if ( $c->has_errors ) {
        my @errors = @{ $c->error };
        $c->clear_errors;
        $c->forward( $self->action_for($self->catch_error_method), \@errors );
    }
};

1;
