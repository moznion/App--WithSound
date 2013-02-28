#!perl

use strict;
use warnings;
use utf8;
use FindBin;
use File::Spec::Functions qw/catfile/;

use App::WithSound;

use Test::More tests => 2;

my $app;
my $rc_file = catfile( $FindBin::Bin, 'resource', '.with-soundrc-to-test' );

subtest 'Environment variables are undefined' => sub {
    $app = App::WithSound->new( $rc_file, \%ENV );
    $app->_load_sound_paths;
    is $app->{success_sound_path}, 'foo', 'success_sound_path should be "foo"';
    is $app->{failure_sound_path}, 'bar', 'failure_sound_path should be "bar"';
};

subtest 'Environment variables are specified' => sub {
    $ENV{WITH_SOUND_SUCCESS} = 'baz';
    $ENV{WITH_SOUND_FAILURE} = 'foobar';
    $app = App::WithSound->new( $rc_file, \%ENV );
    $app->_load_sound_paths;
    is $app->{success_sound_path}, 'baz', 'success_sound_path should be "baz"';
    is $app->{failure_sound_path}, 'foobar',
      'failure_sound_path should be "foobar"';
};

done_testing;
