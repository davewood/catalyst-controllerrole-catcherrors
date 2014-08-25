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
    sub end : Private { }
    no Moose;
    1;
}

{
    like(
        exception { my $ctl = FailController->new( app => {} ); },
        qr/^method\ 'catch_error'\ not\ found\.\ at/,
        "controller died saying that 'catch_error' method wasn't found.",
    );
}

done_testing;
