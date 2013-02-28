#!perl

use strict;
use warnings;
use utf8;

use App::WithSound;

use Test::More tests => 2;

my $app;

subtest 'Environment variables are undefined' => sub {
    $app = App::WithSound->new( undef, \%ENV );
    $app->_load_sound_paths_from_env;
    is $app->{success_sound_path}, undef,
      'success_sound_path should be undefined';
    is $app->{failure_sound_path}, undef,
      'failure_sound_path should be undefined';
};

subtest 'Environment variables are specified' => sub {
    $ENV{WITH_SOUND_SUCCESS} = 'foo';
    $ENV{WITH_SOUND_FAILURE} = 'bar';
    $app = App::WithSound->new( undef, \%ENV );
    $app->_load_sound_paths_from_env;
    is $app->{success_sound_path}, 'foo', 'success_sound_path should be "foo"';
    is $app->{failure_sound_path}, 'bar', 'failure_sound_path should be "bar"';
};

done_testing;
