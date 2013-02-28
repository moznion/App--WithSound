use strict;
use warnings;
use Module::Build;

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
    },
    configure_requires => { 'Module::Build' => '0.40' },
    requires           => {
        perl                    => '5.008001',
        'Audio::Play::MPG123'   => '0.63',
        'Config::Simple'        => '4.58',
        'File::Spec::Functions' => '3.40',
        'File::Path::Expand'    => '1.02',
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
