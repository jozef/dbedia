use strict;
use warnings;
use Module::Build;
use 5.010;

my $builder = Module::Build->new(
    module_name         => 'dbedia',
    license             => 'perl',
    dist_author         => 'Jozef Kutej <jkutej@cpan.org>',
    dist_version_from   => 'lib/dbedia.pm',
    requires => {
        'Class::Accessor::Fast' => 0,
        'App::Cache' => 0,
        'Carp'       => 0,
        'JSON::XS'   => 0,
        'IO::Uncompress::Gunzip'
                     => 0,
    },
    build_requires => {
        'Test::More'      => 0,
        'Test::Exception' => 0,
        'LWP::Simple'     => 0,
        'File::Spec'      => 0,
    },
    add_to_cleanup      => [ 'dbedia-*' ],
    create_readme       => 1,
    sign                => 1,
);

$builder->create_build_script();
