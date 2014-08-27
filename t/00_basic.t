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
    is( $res->content, "Error:\ 'error'", 'error has been handled by catch_error().' );
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

{

    package FailController;
    use Moose;
    BEGIN { extends 'Catalyst::Controller' }
    with 'CatalystX::CatchError';
    sub end : Private           { }
    sub catch_error_foo : Private { }
    no Moose;
    1;
}

{
    like(
        exception { my $ctl = FailController->new( app => {} ); },
        qr/^method\ 'catch_error'\ not\ found\.\ at/,
        "controller died saying that 'catch_error' method wasn't found.",
    );
    is(
        exception { my $ctl = FailController->new( catch_error_method => 'catch_error_foo', app => {} ); },
        undef,
        "controller construction did not die.",
    );
    like(
        exception { my $ctl = FailController->new( catch_error_method => 'catch_error_bar', app => {} ); },
        qr/^method\ 'catch_error_bar'\ not\ found\.\ at/,
        "controller died because the configured 'catch_error_method' wasn't found.",
    );
}

done_testing;
