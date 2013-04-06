#!perl
#
# This file is part of Dist-Zilla-PluginBundle-Author-RWSTAUNER
#
# This software is copyright (c) 2010 by Randy Stauner.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#

use strict;
use warnings;

use Test::More tests => 1;

use ExtUtils::MakeMaker;
use File::Spec::Functions;
use List::Util qw/max/;

my @modules = qw(
  Data::Section
  Devel::Cover
  Dist::Zilla
  Dist::Zilla::App::Command::cover
  Dist::Zilla::Plugin::Authority
  Dist::Zilla::Plugin::AutoPrereqs
  Dist::Zilla::Plugin::Bootstrap::lib
  Dist::Zilla::Plugin::Bugtracker
  Dist::Zilla::Plugin::CheckChangesHasContent
  Dist::Zilla::Plugin::CheckExtraTests
  Dist::Zilla::Plugin::CheckMetaResources
  Dist::Zilla::Plugin::CheckPrereqsIndexed
  Dist::Zilla::Plugin::ConfirmRelease
  Dist::Zilla::Plugin::ContributorsFromGit
  Dist::Zilla::Plugin::DualBuilders
  Dist::Zilla::Plugin::ExecDir
  Dist::Zilla::Plugin::GatherDir
  Dist::Zilla::Plugin::GenerateFile
  Dist::Zilla::Plugin::Git::Describe
  Dist::Zilla::Plugin::Git::Init
  Dist::Zilla::Plugin::Git::NextVersion
  Dist::Zilla::Plugin::GithubMeta
  Dist::Zilla::Plugin::InstallRelease
  Dist::Zilla::Plugin::License
  Dist::Zilla::Plugin::MakeMaker
  Dist::Zilla::Plugin::Manifest
  Dist::Zilla::Plugin::ManifestSkip
  Dist::Zilla::Plugin::MetaConfig
  Dist::Zilla::Plugin::MetaJSON
  Dist::Zilla::Plugin::MetaNoIndex
  Dist::Zilla::Plugin::MetaProvides::Package
  Dist::Zilla::Plugin::MetaYAML
  Dist::Zilla::Plugin::MinimumPerl
  Dist::Zilla::Plugin::NextRelease
  Dist::Zilla::Plugin::OurPkgVersion
  Dist::Zilla::Plugin::PkgVersion
  Dist::Zilla::Plugin::PodWeaver
  Dist::Zilla::Plugin::Prepender
  Dist::Zilla::Plugin::PruneCruft
  Dist::Zilla::Plugin::PruneFiles
  Dist::Zilla::Plugin::Readme
  Dist::Zilla::Plugin::ReadmeAnyFromPod
  Dist::Zilla::Plugin::Repository
  Dist::Zilla::Plugin::Run
  Dist::Zilla::Plugin::Run::AfterMint
  Dist::Zilla::Plugin::ShareDir
  Dist::Zilla::Plugin::TaskWeaver
  Dist::Zilla::Plugin::TemplateModule
  Dist::Zilla::Plugin::Test::ChangesHasContent
  Dist::Zilla::Plugin::Test::PodSpelling
  Dist::Zilla::Plugin::Test::ReportPrereqs
  Dist::Zilla::Plugin::TestRelease
  Dist::Zilla::Plugin::UploadToCPAN
  Dist::Zilla::PluginBundle::Git
  Dist::Zilla::PluginBundle::TestingMania
  Dist::Zilla::Role::MintingProfile::ShareDir
  Dist::Zilla::Role::Plugin
  Dist::Zilla::Role::PluginBundle::Config::Slicer
  Dist::Zilla::Role::PluginBundle::Easy
  Dist::Zilla::Role::PluginBundle::PluginRemover
  Dist::Zilla::Role::Releaser
  Dist::Zilla::Stash::PodWeaver
  ExtUtils::MakeMaker
  File::Find
  File::ShareDir::Install
  File::Spec::Functions
  File::Temp
  Git::Wrapper
  List::Util
  Module::Build
  Moose
  Moose::Util::TypeConstraints
  MooseX::AttributeShortcuts
  Path::Class
  Pod::Elemental::Transformer::List
  Pod::Weaver
  Pod::Weaver::Config::Assembler
  Pod::Weaver::Plugin::Encoding
  Pod::Weaver::Plugin::StopWords
  Pod::Weaver::Plugin::Transformer
  Pod::Weaver::Plugin::WikiDoc
  Pod::Weaver::PluginBundle::CorePrep
  Pod::Weaver::Section::Authors
  Pod::Weaver::Section::Collect
  Pod::Weaver::Section::Contributors
  Pod::Weaver::Section::Generic
  Pod::Weaver::Section::Leftovers
  Pod::Weaver::Section::Legal
  Pod::Weaver::Section::Name
  Pod::Weaver::Section::Region
  Pod::Weaver::Section::Support
  Pod::Weaver::Section::Version
  Test::DZil
  Test::File::ShareDir
  Test::More
  YAML::Tiny
  perl
  strict
  warnings
);

# replace modules with dynamic results from MYMETA.json if we can
# (hide CPAN::Meta from prereq scanner)
my $cpan_meta = "CPAN::Meta";
if ( -f "MYMETA.json" && eval "require $cpan_meta" ) { ## no critic
  if ( my $meta = eval { CPAN::Meta->load_file("MYMETA.json") } ) {
    my $prereqs = $meta->prereqs;
    delete $prereqs->{develop};
    my %uniq = map {$_ => 1} map { keys %$_ } map { values %$_ } values %$prereqs;
    $uniq{$_} = 1 for @modules; # don't lose any static ones
    @modules = sort keys %uniq;
  }
}

my @reports = [qw/Version Module/];

for my $mod ( @modules ) {
  next if $mod eq 'perl';
  my $file = $mod;
  $file =~ s{::}{/}g;
  $file .= ".pm";
  my ($prefix) = grep { -e catfile($_, $file) } @INC;
  if ( $prefix ) {
    my $ver = MM->parse_version( catfile($prefix, $file) );
    $ver = "undef" unless defined $ver; # Newer MM should do this anyway
    push @reports, [$ver, $mod];
  }
  else {
    push @reports, ["missing", $mod];
  }
}

if ( @reports ) {
  my $vl = max map { length $_->[0] } @reports;
  my $ml = max map { length $_->[1] } @reports;
  splice @reports, 1, 0, ["-" x $vl, "-" x $ml];
  diag "Prerequisite Report:\n", map {sprintf("  %*s %*s\n",$vl,$_->[0],-$ml,$_->[1])} @reports;
}

pass;

# vim: ts=2 sts=2 sw=2 et:
