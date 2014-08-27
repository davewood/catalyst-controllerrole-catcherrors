package TestApp::Controller::Root;
use Moose;

BEGIN { extends 'Catalyst::Controller' }
with 'CatalystX::CatchError';
__PACKAGE__->config( namespace => '' );

sub index : Path Args(0) {
    my ( $self, $c ) = @_;
    $c->res->body("index");
    $c->error('error');
}

sub rethrow : Path('rethrow') Args(0) {
    my ( $self, $c ) = @_;
    $c->res->body("index");
    $c->error('rethrow_error_1');
    $c->error('rethrow_error_2');
}

sub catch_error : Private {
    my ( $self, $c, @errors ) = @_;
    for my $error (@errors) {
        if ( $error =~ qr/^rethrow_error_\d+$/xms ) {
            $c->error("Rethrowing '$error'");
        }
        elsif ( $error =~ qr/^error$/xms ) {
            $c->res->body("Error: '$error'");
        }
        else {
            die "Unknown error";
        }
    }
}

sub end : Private { }

no Moose;
1;
