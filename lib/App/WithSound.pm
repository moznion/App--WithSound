package App::WithSound;

use warnings;
use strict;
our $VERSION = '1.0.0';

use Carp;
use Audio::Play::MPG123;
use Config::Simple;

sub new {
    my ( $class, $config_file_path, $env ) = @_;
    bless {
        config_file_path   => $config_file_path,
        env                => $env,
        success_sound_path => undef,
        failure_sound_path => undef,
    }, $class;
}

sub run {
    my ( $self, @argv ) = @_;
    unless (@argv) {
        croak 'Usage: $ with-sound [command] ([argument(s)])' . "\n";
    }

    my $retval = system(@ARGV);
    $retval = 1 if $retval > 255;

    $self->_play_sound($retval);
    return $retval;
}

sub _load_sound_paths_from_env {
    my ($self) = @_;
    if ( $self->{env}->{WITH_SOUND_SUCCESS} ) {
        $self->{success_sound_path} = $self->{env}->{WITH_SOUND_SUCCESS};
    }
    if ( $self->{env}->{WITH_SOUND_FAILURE} ) {
        $self->{failure_sound_path} = $self->{env}->{WITH_SOUND_FAILURE};
    }
    $self;
}

sub _load_sound_paths_from_config {
    my ($self) = @_;

    # Not exists config file.
    unless ( -f $self->{config_file_path} ) {
        die "[ERROR] Please put config file in '@[$self->config_file_path]'\n";
    }
    my $config = Config::Simple->new( $self->{config_file_path} );
    $self->{success_sound_path} = $config->param('SUCCESS');
    $self->{failure_sound_path} = $config->param('FAILURE');
    $self;
}

sub _load_sound_paths {
    my ($self) = @_;
    $self->_load_sound_paths_from_config;

    # load from env after config so environment variables are prior to config
    $self->_load_sound_paths_from_env;

    $self->{success_sound_path} = $self->_expand_path($self->{success_sound_path});
    $self->{failure_sound_path} = $self->_expand_path($self->{failure_sound_path});
    $self;
}

sub _play_mp3_in_child {
    my ( $self, $mp3_file_path ) = @_;
    my $player = Audio::Play::MPG123->new;
    $player->load($mp3_file_path);
    $player->poll(1) until $player->state == 0;
}

sub _play_mp3 {
    my ( $self, $mp3_file_path, $status ) = @_;

    # not exists mp3 file
    unless ( -f $mp3_file_path ) {
        warn "[WARNING] Sound file not found for $status. : $mp3_file_path";
        return;
    }

    my $pid = fork;
    die "fork failed." unless defined $pid;

    if ( $pid == 0 ) {

        # child process
        $self->_play_mp3_in_child($mp3_file_path);
        exit;
    }
    $self;
}

sub _play_sound {
    my ( $self, $command_retval ) = @_;

    $self->_load_sound_paths;
    if ( $command_retval == 0 ) {

        # success
        $self->_play_mp3( $self->{success_sound_path}, 'success' );
    }
    else {
        # failure
        $self->_play_mp3( $self->{failure_sound_path}, 'failure' );
    }
    $self;
}

sub _expand_path {
    my ( $self, $path ) = @_;

    $path =~ s!^~/!$ENV{HOME}/!;
    return $path;
}

1;
__END__

=encoding utf8

=head1 NAME

App::WithSound - Execute commands with sound


=head1 VERSION

This document describes App::WithSound version 1.0.0


=head1 AUTHOR

moznion  C<< <moznion@gmail.com> >>

Shinpei Maruyma C<< shinpeim[at]gmail.com> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2013, moznion C<< <moznion@gmail.com> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
