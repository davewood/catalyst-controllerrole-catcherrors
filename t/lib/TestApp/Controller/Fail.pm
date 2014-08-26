package TestApp::Controller::Fail;
use Moose;

BEGIN { extends 'Catalyst::Controller' }
with 'CatalystX::CatchError';

sub index : Path Args(0) {
    my ( $self, $c ) = @_;
    $c->res->body("index");
    $c->error('foobarbaz');
    $c->error('foobarbaz2');
}

sub catch_error : Private {
    my ( $self, $c, @errors ) = @_;
    for my $error (@errors) {
        $c->error("Rethrowing '$error'");
    }
}

sub end : Private {}

no Moose;
1;
