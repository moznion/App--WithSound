use strict;
use warnings;
use Module::Build;
use Carp;

unless ( requires_external_bin('mpg123')
    || requires_external_bin('mpg321')
    || requires_external_bin('afplay') )
{
    print "! Unresolvable missing external dependency.\n";
    print "! Please install 'mpg123' or 'mpg321' seperately and try again.\n";
    print {*STDERR} "! NA: Unable to build distribution on this platform.\n";
    exit 0;
}

my $builder = Module::Build->new(
    name              => 'App-WithSound',
    module_name       => 'App::WithSound',
    script_files      => ['with-sound'],
    license           => 'perl',
    dist_author       => 'moznion <moznion@gmail.com>',
    dist_version_from => 'lib/App/WithSound.pm',
    build_requires    => {
        'Test::More'                => '0.98',
        'Test::MockObject::Extends' => '1.20120301',
        'Test::Warn'                => '0.24',
        'FindBin'                   => 0,
    },
    configure_requires => { 'Module::Build' => '0.40' },
    requires           => {
        perl                    => '5.008001',
        'File::Which'           => '0.05',
        'Config::Simple'        => '4.58',
        'File::Spec::Functions' => '3.40',
        'File::Path::Expand'    => '1.02',
        'IPC::Open3'            => 0,
        'Carp'                  => 0,
    },
    no_index   => { 'directory' => ['inc'] },
    meta_merge => {
        'resources' => {
            'license'    => 'http://dev.perl.org/licenses/',
            'repository' => 'git://github.com/moznion/App--WithSound.git',
        },
    },
    test_files => ( -d '.git' || $ENV{RELEASE_TESTING} ) ? 't/ xt/' : 't/',
    recursive_test_files => 1,
    add_to_cleanup       => ['App-WithSound-*'],
    create_license       => 1,
);

$builder->create_build_script();

# Module::Install::Can
sub can_run {
    my $cmd = shift;
    require ExtUtils::MakeMaker;
    if ( $^O eq 'cygwin' ) {

        # MM->maybe_command is fixed in 6.51_01 for Cygwin.
        ExtUtils::MakeMaker->import(6.52);
    }

    my $_cmd = $cmd;
    return $_cmd if ( -x $_cmd or $_cmd = MM->maybe_command($_cmd) );

    for my $dir ( ( split /$Config::Config{path_sep}/x, $ENV{PATH} ), q{.} ) {
        next if $dir eq q{};
        my $abs = File::Spec->catfile( $dir, $cmd );
        return $abs if ( -x $abs or $abs = MM->maybe_command($abs) );
    }

    return;
} ## end sub can_run

# Module::Install::External
sub requires_external_bin {
    my ( $bin, $version ) = @_;
    if ($version) {
        croak 'requires_external_bin does not support versions yet';
    }

    # Locate the bin
    print "Locating required external dependency bin: $bin...";
    my $found_bin = can_run($bin);
    if ($found_bin) {
        print " found at $found_bin.\n";
        return 1;
    }
    print " missing.\n";
    return 0;
} ## end sub requires_external_bin
