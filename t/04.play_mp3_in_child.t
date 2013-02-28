#!perl

use strict;
use warnings;
use utf8;
use FindBin;
use File::Spec::Functions qw/catfile/;
use Audio::Play::MPG123;

use App::WithSound;

use Test::More tests => 1;
use Test::MockObject::Extends;

subtest 'Playback mp3 rightly' => sub {
    my $app = App::WithSound->new( undef, \%ENV );

    my $player      = Audio::Play::MPG123->new;
    my $player_mock = Test::MockObject::Extends->new($player);

    my $mp3 =
      catfile( $FindBin::Bin, 'resource', 'dummy_success.mp3' );
    $player_mock->mock(
        "load",
        sub {
            my ( $self, $mp3_given ) = @_;
            is $mp3_given, $mp3, "Playback '$mp3_given' rightly.";
            $self->{state} = 0;
            return $self->{state};
        }
    );

    $app->_sound_player($player);

    is $app->_play_mp3_in_child($mp3), 1;    # 1: success
};

done_testing;
