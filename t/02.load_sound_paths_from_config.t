#!perl

use strict;
use warnings;
use utf8;
use FindBin;
use File::Spec::Functions qw/catfile/;

use App::WithSound;

use Test::More tests => 2;
use Test::Warn;

my ( $app, $rc_file );

subtest 'Load configurations from the config file.' => sub {
    $rc_file = catfile( $FindBin::Bin, 'resource', '.with-soundrc-to-test' );
    $app = App::WithSound->new( $rc_file, \%ENV );
    $app->_load_sound_paths_from_config;
    is $app->{success_sound_path}, 'foo', 'success_sound_path should be "foo"';
    is $app->{failure_sound_path}, 'bar', 'failure_sound_path should be "bar"';
    is $app->{running_sound_path}, 'baz', 'running_sound_path should be "baz"';
};

subtest 'The config file does not exist' => sub {
    $rc_file = catfile( $FindBin::Bin, 'resource', '.dummyrc' );
    $app = App::WithSound->new( $rc_file, \%ENV );
    warning_like { $app->_load_sound_paths_from_config }
    qr/\[WARNNING\] Please put config file in '$rc_file'/;
};

done_testing;
