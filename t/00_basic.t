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
    is( $res->content, "Error:\ 'foobarbaz'" );
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
        "controller died saying that 'catch_error_bar' method wasn't found.",
    );
}

done_testing;
