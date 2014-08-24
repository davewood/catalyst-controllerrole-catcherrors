use strict;
use warnings;
use Test::More;
use Catalyst::Test 'TestApp';
use Test::Warnings;

{
    my $res = request('/');
    is( $res->content, "Error:\ 'foobarbaz'" );
}

done_testing;
