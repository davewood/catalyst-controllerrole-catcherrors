use strict;
use warnings;
use Test::More;
use Test::Warnings;
use FindBin qw/$Bin/;
use lib "$Bin/lib";
use Catalyst::Test 'TestApp';

{
    my $res = request('/');
    is( $res->content, "Error:\ 'foobarbaz'" );
}

done_testing;
