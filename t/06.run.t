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

subtest 'Run by success' => sub {
    $ENV{WITH_SOUND_SUCCESS} =
      catfile( $FindBin::Bin, 'resource', 'dummy_success.mp3' );
    $ENV{WITH_SOUND_FAILURE} =
      catfile( $FindBin::Bin, 'resource', 'dummy_failure.mp3' );
    my $rc_file = catfile( $FindBin::Bin, 'resource', '.with-soundrc-to-test' );
    my $app = App::WithSound->new( $rc_file, \%ENV );
    my @args = ( 'perl', '-e', '' );
    is $app->run(@args), 0;
};

done_testing;
