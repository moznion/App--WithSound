#!perl

use strict;
use warnings;
use utf8;
use File::Spec::Functions qw/catfile/;

use App::WithSound;

BEGIN {
    use Test::More tests => 2;
}

my $app = App::WithSound->new( undef, undef );

subtest 'Through' => sub {
    my $path = catfile( $ENV{HOME}, 'foo', 'bar' );
    is $app->_expand_path($path), $path;
};

subtest 'Expand path' => sub {
    my $path   = catfile( '~/',       'baz', 'foobar' );
    my $expect = catfile( $ENV{HOME}, 'baz', 'foobar' );
    is $app->_expand_path($path), $expect;
};

done_testing;
