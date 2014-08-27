use strict;
use warnings;
use Test::More;
use Test::Warnings;
use FindBin qw/$Bin/;
use lib "$Bin/lib";
use Catalyst::Test 'TestApp';
use Test::Fatal;

{
    my $res = request('/');
    is( $res->content, "Error:\ 'error'", 'error has been handled by catch_errors().' );
}

{
    my $res = request('/http_exception/');
    is( $res->code, 400, 'we do not break HTTP::Exception. (code)' );
    is( $res->content, "http_exception foobar", 'we do not break HTTP::Exception. (status_message)' );
}

{
    no warnings 'redefine';
    local *Catalyst::finalize_error = sub {
        my $c = shift;
        my @errors = @{ $c->error };
        is( scalar @errors, 2, 'there should be two error in $c->error' );
        is( $errors[0], "Rethrowing\ 'rethrow_error_1'", '1st error has been rethrown.' );
        is( $errors[1], "Rethrowing\ 'rethrow_error_2'", '2nd error has been rethrown.' );
    };
    my $res = request('/rethrow/');
}


eval {
    package FailController;
    use Moose;
    BEGIN { extends 'Catalyst::Controller' }
    with 'CatalystX::CatchError';
    sub end : Private { }
    no Moose;
    1;
};
like(
    $@,
    qr/CatalystX::CatchError'\ requires\ the\ method\ 'catch_errors'\ to\ be\ implemented\ by\ 'FailController'/xms,
    "found error msg (required method catch_errors not implemented).",
);

done_testing;
