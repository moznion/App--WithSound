#!perl

use strict;
use warnings;
use utf8;
use FindBin;
use File::Spec::Functions qw/catfile/;

use App::WithSound;

use Test::More tests => 1;

# TODO Do you have an idea about more effective method to test?
subtest 'Playback mp3 rightly' => sub {
    my $app = App::WithSound->new( undef, undef );
    my $mp3 = catfile( $FindBin::Bin, 'resource', 'dummy_success.mp3' );
    is $app->_play_mp3_in_child($mp3), 1;    # 1: success
};

done_testing;
