use strict;
use warnings;
use Test::More;
use Catalyst::Test 'TestApp';

my $res = request('/');
like( $res->content, qr/Error:\ 'foobarbaz'/xms );

done_testing;
