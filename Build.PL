
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  'build_requires' => {
    'Dist::Zilla::Role::Plugin' => '0',
    'Dist::Zilla::Role::Releaser' => '0',
    'File::Find' => '0',
    'File::Temp' => '0',
    'Module::Build' => '0.3601',
    'Test::DZil' => '0',
    'Test::More' => '0.96'
  },
  'configure_requires' => {
    'Module::Build' => '0.3601'
  },
  'dist_abstract' => 'RWSTAUNER\'s Dist::Zilla config',
  'dist_author' => [
    'Randy Stauner <rwstauner@cpan.org>'
  ],
  'dist_name' => 'Dist-Zilla-PluginBundle-Author-RWSTAUNER',
  'dist_version' => '3.100',
  'license' => 'perl',
  'module_name' => 'Dist::Zilla::PluginBundle::Author::RWSTAUNER',
  'recommends' => {},
  'recursive_test_files' => 1,
  'requires' => {
    'Dist::Zilla' => '4.200005',
    'Dist::Zilla::Plugin::Authority' => '1.004',
    'Dist::Zilla::Plugin::Bugtracker' => '0',
    'Dist::Zilla::Plugin::CheckChangesHasContent' => '0.003',
    'Dist::Zilla::Plugin::CheckExtraTests' => '0',
    'Dist::Zilla::Plugin::DualBuilders' => '1.001',
    'Dist::Zilla::Plugin::Git::NextVersion' => '0',
    'Dist::Zilla::Plugin::GithubMeta' => '0.10',
    'Dist::Zilla::Plugin::InstallRelease' => '0.006',
    'Dist::Zilla::Plugin::MetaNoIndex' => '1.101130',
    'Dist::Zilla::Plugin::MetaProvides::Package' => '1.11044404',
    'Dist::Zilla::Plugin::MinimumPerl' => '0.02',
    'Dist::Zilla::Plugin::NextRelease' => '0',
    'Dist::Zilla::Plugin::PkgVersion' => '0',
    'Dist::Zilla::Plugin::PodSpellingTests' => '0',
    'Dist::Zilla::Plugin::PodWeaver' => '0',
    'Dist::Zilla::Plugin::Prepender' => '1.100960',
    'Dist::Zilla::Plugin::ReportVersions::Tiny' => '1.01',
    'Dist::Zilla::Plugin::Repository' => '0.16',
    'Dist::Zilla::Plugin::TaskWeaver' => '0.101620',
    'Dist::Zilla::Plugin::Test::Pod::No404s' => '0',
    'Dist::Zilla::PluginBundle::Basic' => '0',
    'Dist::Zilla::PluginBundle::Git' => '1.110500',
    'Dist::Zilla::PluginBundle::TestingMania' => '0.010',
    'Dist::Zilla::Role::PluginBundle::Easy' => '0',
    'Dist::Zilla::Stash::PodWeaver' => '1.001000',
    'Moose' => '0',
    'Pod::Elemental' => '0.102360',
    'Pod::Elemental::Transformer::List' => '0',
    'Pod::Weaver' => '3.101632',
    'Pod::Weaver::Config::Assembler' => '0',
    'Pod::Weaver::Plugin::StopWords' => '1.001005',
    'Pod::Weaver::Plugin::Transformer' => '0',
    'Pod::Weaver::Plugin::WikiDoc' => '0',
    'Pod::Weaver::PluginBundle::Default' => '0',
    'Pod::Weaver::Section::Support' => '1.001',
    'perl' => '5.006'
  },
  'script_files' => []
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
