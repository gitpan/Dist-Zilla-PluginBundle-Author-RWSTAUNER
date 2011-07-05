
use strict;
use warnings;

use 5.006;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  'ABSTRACT' => 'RWSTAUNER\'s Dist::Zilla config',
  'AUTHOR' => 'Randy Stauner <rwstauner@cpan.org>',
  'BUILD_REQUIRES' => {
    'Dist::Zilla::Role::Plugin' => '0',
    'Dist::Zilla::Role::Releaser' => '0',
    'File::Find' => '0',
    'File::Temp' => '0',
    'ExtUtils::MakeMaker' => '6.30',
    'Test::DZil' => '0',
    'Test::More' => '0.96'
  },
  'CONFIGURE_REQUIRES' => {
    'ExtUtils::MakeMaker' => '6.30'
  },
  'DISTNAME' => 'Dist-Zilla-PluginBundle-Author-RWSTAUNER',
  'EXE_FILES' => [],
  'LICENSE' => 'perl',
  'NAME' => 'Dist::Zilla::PluginBundle::Author::RWSTAUNER',
  'PREREQ_PM' => {
    'Dist::Zilla' => '4.200005',
    'Dist::Zilla::Plugin::Authority' => '1.004',
    'Dist::Zilla::Plugin::Bootstrap::lib' => '0',
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
    'Dist::Zilla::Plugin::PodWeaver' => '0',
    'Dist::Zilla::Plugin::Prepender' => '1.100960',
    'Dist::Zilla::Plugin::ReportVersions::Tiny' => '1.01',
    'Dist::Zilla::Plugin::Repository' => '0.16',
    'Dist::Zilla::Plugin::TaskWeaver' => '0.101620',
    'Dist::Zilla::PluginBundle::Basic' => '0',
    'Dist::Zilla::PluginBundle::Git' => '1.110500',
    'Dist::Zilla::PluginBundle::TestingMania' => '0.010',
    'Dist::Zilla::Role::PluginBundle::Easy' => '0',
    'Dist::Zilla::Stash::PodWeaver' => '1.001000',
    'List::Util' => '0',
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
    'YAML::Tiny' => '0'
  },
  'VERSION' => '3.104',
  'test' => {
    'TESTS' => 't/*.t'
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



