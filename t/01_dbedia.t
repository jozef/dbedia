#!/usr/bin/perl

use strict;
use warnings;

#use Test::More 'no_plan';
use Test::More tests => 5;
use Test::Differences;
use Test::Exception;

use FindBin qw($Bin);
use lib "$Bin/lib";

BEGIN {
    use_ok ( 'dbedia' ) or exit;
}

exit main();

sub main {
    my $dbedia = dbedia->new( base_uri => 'file://'.$Bin.'/dbedia/' );
    isa_ok($dbedia, 'dbedia');
    
    $dbedia->clear_cache;

    my $brands_models = $dbedia->get('brandsModels.json');
    is(ref $brands_models, 'HASH', 'brandsModels.json has HASH');
    ok(keys %{$brands_models}, 'with some brands');
    ok(scalar @{$brands_models->{'Apple'}}, 'with some models');

	return 0;
}

