#!perl -T

use strict;
use warnings;
use Test::More 0.98;

use Business::ID::BCA qw(parse_bca_account);

my @tests = (
    {args=>{account=>''}             , status=>400, name=>'length 1'},
    {args=>{account=>'123'}          , status=>400, name=>'length 2'},
    {args=>{account=>'60003401011'}  , status=>400, name=>'length 3'},

    {args=>{account=>'6000340101'}   , status=>200, res=>{
        branch_code=>'6000',
        branch_address=>'KCP Soepomo Jln. Prof. Dr. Soepomo 13 Jakarta 021-8309781, 8309794',
        account=>'6000340101',
        account_f=>'6000.34010.1',
        check_digit=>1,
        is_checking=>1,
    }, name=>'ok 1'},
    {args=>{account=>'6000.34010.1'} , status=>200, name=>'ok 2a (nondigits ignored)'},
    {args=>{account=>'6000 34010-1 '}, status=>200, name=>'ok 2b (nondigits ignored)'},

    {args=>{account=>'9999.34010.1', check_known_branches=>1} , status=>400, name=>'check_known_branches=1'},
    # XXX check digit
);

for my $t (@tests) {
    subtest $t->{name} => sub {
        my $res = parse_bca_account(%{$t->{args}});
        is($res->[0], $t->{status}, 'status');
        if ($t->{res}) {
            is_deeply($res->[2], $t->{res}, 'res');
        }
    };
}

done_testing;
