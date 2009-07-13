#!/usr/bin/perl

use strict;
use warnings;

#use Test::More 'no_plan';
use Test::More tests => 8;
use Test::Exception;
use LWP::Simple 'get';

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

    my $brands_models = $dbedia->get('brandsModels.json.gz');
    is(ref $brands_models, 'HASH', 'brandsModels.json.gz has HASH');
    ok(keys %{$brands_models}, 'with some brands');
    ok(scalar @{$brands_models->{'Apple'}}, 'with some models');

    my $info = $dbedia->get('info.txt');
    is($info, 'if you say so'."\n", 'get someting else then json');

    # try online tests
    my $content = get('http://dbedia.com/');
    SKIP: {
        skip "not online", 2
            if not $content;

        my $dbedia_ol = dbedia->new();
        $dbedia_ol->clear_cache;

        my $build = $dbedia_ol->get('build.json');
        is(ref $build, 'HASH', 'got has of build.json');
        ok($build->{'build_time'}, 'should contain build time');
    }

	return 0;
}

