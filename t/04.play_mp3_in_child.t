#!perl

use strict;
use warnings;
use utf8;
use FindBin;
use File::Spec::Functions qw/catfile/;
use Audio::Play::MPG123;

use App::WithSound;

BEGIN {
    use Test::More tests => 1;
    use Test::MockObject::Extends;
}

my $player      = Audio::Play::MPG123->new;
my $player_mock = Test::MockObject::Extends->new($player);
my $app         = App::WithSound->new( undef, \%ENV );
$app->_sound_player($player);

my $mp3_file_path = catfile( $FindBin::Bin, 'resource', 'dummy_success.mp3' );

$player_mock->mock(
    "load",
    sub {
        my ( $self, $mp3 ) = @_;
        is $mp3, $mp3_file_path, "Playback '$mp3' rightly.";
        $self->{state} = 0;
        return $self->{state};
    }
);

subtest 'Playback mp3 rightly' => sub {
    is $app->_play_mp3_in_child($mp3_file_path), 1;    # 1: success
};

done_testing;
