
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  "build_requires" => {
    "Module::Build" => "0.3601"
  },
  "configure_requires" => {
    "File::ShareDir::Install" => "0.03",
    "Module::Build" => "0.3601"
  },
  "dist_abstract" => "RWSTAUNER's Dist::Zilla config",
  "dist_author" => [
    "Randy Stauner <rwstauner\@cpan.org>"
  ],
  "dist_name" => "Dist-Zilla-PluginBundle-Author-RWSTAUNER",
  "dist_version" => "4.100",
  "license" => "perl",
  "module_name" => "Dist::Zilla::PluginBundle::Author::RWSTAUNER",
  "recommends" => {
    "Devel::Cover" => "1.00",
    "Dist::Zilla::App::Command::cover" => 0,
    "Dist::Zilla::Plugin::DualBuilders" => "1.001",
    "Dist::Zilla::Plugin::TaskWeaver" => "0.101620",
    "Dist::Zilla::Plugin::Test::PodSpelling" => 2
  },
  "recursive_test_files" => 1,
  "requires" => {
    "Data::Section" => 0,
    "Dist::Zilla" => "4.300032",
    "Dist::Zilla::Plugin::Authority" => "1.005",
    "Dist::Zilla::Plugin::AutoPrereqs" => 0,
    "Dist::Zilla::Plugin::Bootstrap::lib" => 0,
    "Dist::Zilla::Plugin::Bugtracker" => 0,
    "Dist::Zilla::Plugin::CheckChangesHasContent" => "0.006",
    "Dist::Zilla::Plugin::CheckExtraTests" => 0,
    "Dist::Zilla::Plugin::CheckMetaResources" => 0,
    "Dist::Zilla::Plugin::CheckPrereqsIndexed" => 0,
    "Dist::Zilla::Plugin::ConfirmRelease" => 0,
    "Dist::Zilla::Plugin::ContributorsFromGit" => "0.005",
    "Dist::Zilla::Plugin::ExecDir" => 0,
    "Dist::Zilla::Plugin::GatherDir" => 0,
    "Dist::Zilla::Plugin::GenerateFile" => 0,
    "Dist::Zilla::Plugin::Git::Describe" => 0,
    "Dist::Zilla::Plugin::Git::Init" => 0,
    "Dist::Zilla::Plugin::Git::NextVersion" => 0,
    "Dist::Zilla::Plugin::GithubMeta" => "0.10",
    "Dist::Zilla::Plugin::InstallRelease" => "0.006",
    "Dist::Zilla::Plugin::License" => 0,
    "Dist::Zilla::Plugin::MakeMaker" => 0,
    "Dist::Zilla::Plugin::Manifest" => 0,
    "Dist::Zilla::Plugin::ManifestSkip" => 0,
    "Dist::Zilla::Plugin::MetaConfig" => 0,
    "Dist::Zilla::Plugin::MetaJSON" => 0,
    "Dist::Zilla::Plugin::MetaNoIndex" => "1.10113",
    "Dist::Zilla::Plugin::MetaProvides::Package" => "1.14000001",
    "Dist::Zilla::Plugin::MetaYAML" => 0,
    "Dist::Zilla::Plugin::MinimumPerl" => "1.003",
    "Dist::Zilla::Plugin::NextRelease" => 0,
    "Dist::Zilla::Plugin::OurPkgVersion" => "0.002",
    "Dist::Zilla::Plugin::PkgVersion" => 0,
    "Dist::Zilla::Plugin::PodWeaver" => 0,
    "Dist::Zilla::Plugin::Prepender" => "1.112280",
    "Dist::Zilla::Plugin::PruneCruft" => 0,
    "Dist::Zilla::Plugin::PruneFiles" => 0,
    "Dist::Zilla::Plugin::Readme" => 0,
    "Dist::Zilla::Plugin::ReadmeAnyFromPod" => "0.120120",
    "Dist::Zilla::Plugin::Repository" => "0.16",
    "Dist::Zilla::Plugin::Run" => "0.014",
    "Dist::Zilla::Plugin::Run::AfterMint" => 0,
    "Dist::Zilla::Plugin::ShareDir" => 0,
    "Dist::Zilla::Plugin::TemplateModule" => 0,
    "Dist::Zilla::Plugin::Test::ChangesHasContent" => "0.006",
    "Dist::Zilla::Plugin::Test::PodSpelling" => 0,
    "Dist::Zilla::Plugin::Test::ReportPrereqs" => "0.004",
    "Dist::Zilla::Plugin::TestRelease" => 0,
    "Dist::Zilla::Plugin::UploadToCPAN" => 0,
    "Dist::Zilla::PluginBundle::Git" => "2.004",
    "Dist::Zilla::PluginBundle::TestingMania" => "0.019",
    "Dist::Zilla::Role::MintingProfile::ShareDir" => 0,
    "Dist::Zilla::Role::PluginBundle::Config::Slicer" => 0,
    "Dist::Zilla::Role::PluginBundle::Easy" => 0,
    "Dist::Zilla::Role::PluginBundle::PluginRemover" => 0,
    "Dist::Zilla::Stash::PodWeaver" => "1.005",
    "Git::Wrapper" => 0,
    "List::Util" => 0,
    "Moose" => 0,
    "Moose::Util::TypeConstraints" => "1.01",
    "MooseX::AttributeShortcuts" => 0,
    "Pod::Elemental::Transformer::List" => 0,
    "Pod::Weaver" => "3.101633",
    "Pod::Weaver::Config::Assembler" => 0,
    "Pod::Weaver::Plugin::Encoding" => 0,
    "Pod::Weaver::Plugin::StopWords" => "1.005",
    "Pod::Weaver::Plugin::Transformer" => 0,
    "Pod::Weaver::Plugin::WikiDoc" => 0,
    "Pod::Weaver::PluginBundle::CorePrep" => 0,
    "Pod::Weaver::Section::Authors" => 0,
    "Pod::Weaver::Section::Collect" => 0,
    "Pod::Weaver::Section::Contributors" => 0,
    "Pod::Weaver::Section::Generic" => 0,
    "Pod::Weaver::Section::Leftovers" => 0,
    "Pod::Weaver::Section::Legal" => 0,
    "Pod::Weaver::Section::Name" => 0,
    "Pod::Weaver::Section::Region" => 0,
    "Pod::Weaver::Section::Support" => "1.005",
    "Pod::Weaver::Section::Version" => 0,
    "YAML::Tiny" => 0,
    "perl" => "5.006",
    "strict" => 0,
    "warnings" => 0
  },
  "script_files" => [],
  "share_dir" => {
    "dist" => "share",
    "module" => {
      "Dist::Zilla::MintingProfile::Author::RWSTAUNER" => "share/profiles"
    }
  },
  "test_requires" => {
    "Dist::Zilla::Role::Plugin" => 0,
    "Dist::Zilla::Role::Releaser" => 0,
    "ExtUtils::MakeMaker" => 0,
    "File::Find" => 0,
    "File::Spec::Functions" => 0,
    "File::Temp" => 0,
    "Path::Class" => 0,
    "Test::DZil" => 0,
    "Test::File::ShareDir" => 0,
    "Test::More" => "0.96"
  }
);


unless ( eval { Module::Build->VERSION(0.4004) } ) {
  my $tr = delete $module_build_args{test_requires};
  my $br = $module_build_args{build_requires};
  for my $mod ( keys %$tr ) {
    if ( exists $br->{$mod} ) {
      $br->{$mod} = $tr->{$mod} if $tr->{$mod} > $br->{$mod};
    }
    else {
      $br->{$mod} = $tr->{$mod};
    }
  }
}

my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
