package TestApp::Controller::Root;
use Moose;

BEGIN { extends 'Catalyst::Controller' }
with 'CatalystX::CatchError';
__PACKAGE__->config( namespace => '' );

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;
    $c->res->body("index");
    $c->error('foobarbaz');
}

sub catch_error : Private {
    my ( $self, $c, @errors ) = @_;
    my $error = pop(@errors);
    $c->res->body("Error: '$error'");
}
no Moose;
1;
