#!perl

use strict;
use warnings;
use utf8;
use FindBin;
use File::Spec::Functions qw/catfile/;

use App::WithSound;

BEGIN {
    use Test::More tests => 2;
    use Test::Exception;
}

my ( $app, $rc_file );

subtest 'Load configurations from the config file.' => sub {
    $rc_file = catfile( $FindBin::Bin, 'resource', '.with-soundrc-to-test' );
    $app = App::WithSound->new( $rc_file, \%ENV );
    $app->_load_sound_paths_from_config;
    is $app->{success_sound_path}, 'foo', 'success_sound_path should be "foo"';
    is $app->{failure_sound_path}, 'bar', 'failure_sound_path should be "bar"';
};

subtest 'The config file does not exist' => sub {
    $rc_file = catfile( $FindBin::Bin, 'resource', '.dummyrc' );
    $app = App::WithSound->new( $rc_file, \%ENV );
    dies_ok { $app->_load_sound_paths_from_config };
};

done_testing;
