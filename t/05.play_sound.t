#!perl

use strict;
use warnings;
use utf8;
use FindBin;
use File::Spec::Functions qw/catfile/;

use App::WithSound;

BEGIN {
    use Test::More;
}

# TODO Do you have an idea about more effective method to test?
subtest 'Playback sound rightly' => sub {
    $ENV{WITH_SOUND_SUCCESS} = catfile($FindBin::Bin, 'resource', 'dummy_success.mp3');
    $ENV{WITH_SOUND_FAILURE} = catfile($FindBin::Bin, 'resource', 'dummy_failure.mp3');
    my $rc_file = catfile($FindBin::Bin, 'resource', '.with-soundrc-to-test');
    my $app = App::WithSound->new( $rc_file, \%ENV );

    is ref($app->_play_sound(0)), 'App::WithSound', 'Playback sound when success';
    is ref($app->_play_sound(1)), 'App::WithSound', 'Playback sound with failure';
};

done_testing;
