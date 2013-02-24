use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'App::WithSound',
    license             => 'artistic2',
    dist_author         => 'moznion <moznion@gmail.com>',
    dist_version_from   => 'lib/App/WithSound.pm',
    requires => {
        'Test::More' => 0,
        'version'    => 0,
    },
    add_to_cleanup      => [ 'App-WithSound-*' ],
);

$builder->create_build_script();
