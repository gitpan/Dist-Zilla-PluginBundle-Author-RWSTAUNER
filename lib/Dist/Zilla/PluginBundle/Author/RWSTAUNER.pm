# vim: set ts=2 sts=2 sw=2 expandtab smarttab:
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

package Dist::Zilla::PluginBundle::Author::RWSTAUNER;
{
  $Dist::Zilla::PluginBundle::Author::RWSTAUNER::VERSION = '3.107';
}
BEGIN {
  $Dist::Zilla::PluginBundle::Author::RWSTAUNER::AUTHORITY = 'cpan:RWSTAUNER';
}
# ABSTRACT: RWSTAUNER's Dist::Zilla config

use Moose;
use List::Util qw(first); # core
use Dist::Zilla 4.200005;
with 'Dist::Zilla::Role::PluginBundle::Easy';
# Dist::Zilla::Role::DynamicConfig is not necessary: payload is already dynamic

use Dist::Zilla::PluginBundle::Basic (); # use most of the plugins included
use Dist::Zilla::PluginBundle::Git 1.110500 ();
# NOTE: A newer TestingMania might duplicate plugins if new tests are added
use Dist::Zilla::PluginBundle::TestingMania 0.010 ();
use Dist::Zilla::Plugin::Authority 1.005 (); # accepts any non-whitespace + locate_comment
use Dist::Zilla::Plugin::Bugtracker ();
use Dist::Zilla::Plugin::CheckExtraTests ();
use Dist::Zilla::Plugin::CheckChangesHasContent 0.003 ();
use Dist::Zilla::Plugin::DualBuilders 1.001 (); # only runs tests once
use Dist::Zilla::Plugin::Git::NextVersion ();
use Dist::Zilla::Plugin::GithubMeta 0.10 ();
use Dist::Zilla::Plugin::InstallRelease 0.006 ();
#use Dist::Zilla::Plugin::MetaData::BuiltWith (); # FIXME: see comment below
use Dist::Zilla::Plugin::MetaNoIndex 1.101130 ();
use Dist::Zilla::Plugin::MetaProvides::Package 1.11044404 ();
use Dist::Zilla::Plugin::MinimumPerl 0.02 ();
use Dist::Zilla::Plugin::NextRelease ();
use Dist::Zilla::Plugin::OurPkgVersion 0.002 ();
use Dist::Zilla::Plugin::PodWeaver ();
use Dist::Zilla::Plugin::Prepender 1.112280 ();
use Dist::Zilla::Plugin::Repository 0.16 (); # deprecates github_http
use Dist::Zilla::Plugin::ReportVersions::Tiny 1.01 ();
use Dist::Zilla::Plugin::TaskWeaver 0.101620 ();
#use Dist::Zilla::Plugin::Test::Pod::No404s ();
use Pod::Weaver::PluginBundle::Author::RWSTAUNER ();

# don't require it in case it won't install somewhere
my $spelling_tests = eval 'require Dist::Zilla::Plugin::Test::PodSpelling';

# cannot use $self->name for class methods
sub _bundle_name {
  my $class = @_ ? ref $_[0] || $_[0] : __PACKAGE__;
  join('', '@', ($class =~ /^.+::PluginBundle::(.+)$/));
}

# TODO: consider an option for using ReportPhase
sub _default_attributes {
  return {
    auto_prereqs    => [Bool => 1],
    disable_tests   => [Str  => ''],
    fake_release    => [Bool => $ENV{DZIL_FAKERELEASE}],
    # cpanm will choose the best place to install
    install_command => [Str  => 'cpanm -v -i .'],
    is_task         => [Bool => 0],
    placeholder_comments => [Bool => 0],
    releaser        => [Str  => 'UploadToCPAN'],
    skip_plugins    => [Str  => ''],
    skip_prereqs    => [Str  => ''],
    weaver_config   => [Str  => $_[0]->_bundle_name],
    use_git_bundle  => [Bool => 1],
  };
}

sub _generate_attribute {
  my ($self, $key) = @_;
  has $key => (
    is      => 'ro',
    isa     => $self->_default_attributes->{$key}[0],
    lazy    => 1,
    default => sub {
      # if it exists in the payload
      exists $_[0]->payload->{$key}
        # use it
        ?  $_[0]->payload->{$key}
        # else get it from the defaults (for subclasses)
        :  $_[0]->_default_attributes->{$key}[1];
    }
  );
}

{
  # generate attributes
  __PACKAGE__->_generate_attribute($_)
    for keys %{ __PACKAGE__->_default_attributes };
}

# main
sub configure {
  my ($self) = @_;

  my $skip = $self->skip_plugins;
  $skip &&= qr/$skip/;

  my $dynamic = $self->payload;
  # sneak this config in behind @TestingMania's back
  $dynamic->{'CompileTests:fake_home'} = 1
    unless first { /CompileTests\W+fake_home/ } keys %$dynamic;

  $self->_add_bundled_plugins;
  my $plugins = $self->plugins;

  my $i = -1;
  while( ++$i < @$plugins ){
    my $spec = $plugins->[$i] or next;
    # NOTE: $conf retains its reference (modifications alter $spec)
    my ($name, $class, $conf) = @$spec;

    # ignore the prefix (@Bundle/Name => Name) (DZP::Name => Name)
    my ($alias)   = ($name  =~ m#([^/]+)$#);
    my ($moniker) = ($class =~ m#^(?:Dist::Zilla::Plugin(?:Bundle)?::)?(.+)$#);

    # exclude any plugins that match 'skip_plugins'
    if( $skip ){
      # match on full name or plugin class (regexp should use \b not \A)
      if( $name =~ $skip || $class =~ $skip ){
        splice(@$plugins, $i, 1);
        redo;
      }
    }

    # search the dynamic config for anything matching the current plugin
    my $plugin_attr = qr/^(?:$alias|.?$moniker)\W+(\w+)(\W*)$/;
    while( my ($key, $val) = each %$dynamic ){
      # match keys like Plugin::Name:attr and PlugName/attr@
      next unless
        my ($attr, $over) = ($key =~ $plugin_attr);

      # if its already an arrayref
      if( ref(my $current = $conf->{$attr}) eq 'ARRAY' ){
        # overwrite if specified, otherwise append
        $val = $over ? [$val] : [@$current, $val];
      }
      # modify original
      $conf->{$attr} = $val;
    }
  };
  if ( $ENV{DZIL_BUNDLE_DEBUG} ) {
    eval {
      require YAML::Tiny; # dzil requires this
      $self->log( YAML::Tiny::Dump( $self->plugins ) );
    };
    warn $@ if $@;
  }
}

sub _add_bundled_plugins {
  my ($self) = @_;

  $self->log_fatal("you must not specify both weaver_config and is_task")
    if $self->is_task and $self->weaver_config ne $self->_bundle_name;

  $self->add_plugins(

  # provide version
    #'Git::DescribeVersion',
    'Git::NextVersion',

  # gather and prune
    $self->_generate_manifest_skip,
    qw(
      GatherDir
      PruneCruft
      ManifestSkip
    ),
    # not necessary in the released distribution
    [ PruneFiles => 'PruneBuilderFiles'  => { match => '^(dist|weaver).ini$' } ],
    # this is just for github
    [ PruneFiles => 'PruneRepoMetaFiles' => { match => '^(README.pod)$' } ],
    # Devel::Cover db does not need to be packaged with distribution
    [ PruneFiles => 'PruneDevelCoverDatabase' => { match => '^(cover_db)$' } ],

  # munge files
    [
      Authority => {
        do_munging     => 1,
        do_metadata    => 1,
        locate_comment => $self->placeholder_comments,
      }
    ],
    [
      NextRelease => {
        # w3cdtf
        time_zone => 'UTC',
        format => q[%-9v %{yyyy-MM-dd'T'HH:mm:ss'Z'}d],
      }
    ],
    ($self->placeholder_comments ? 'OurPkgVersion' : 'PkgVersion'),
    [
      Prepender => {
        # don't prepend to tests
        skip => '^x?t/.+',
      }
    ],
    ( $self->is_task
      ?  'TaskWeaver'
      # TODO: detect weaver.ini and skip 'config_plugin'?
      : [ 'PodWeaver' => { config_plugin => $self->weaver_config } ]
    ),

  # generated distribution files
    qw(
      License
      Readme
    ),
    # @APOCALYPTIC: generate MANIFEST.SKIP ?

  # metadata
    'Bugtracker',
    # won't find git if not in repository root (!-e ".git")
    'Repository',
    # overrides [Repository] if repository is on github
    'GithubMeta',
  );

  $self->add_plugins(
    [ AutoPrereqs => $self->config_slice({ skip_prereqs => 'skip' }) ]
  )
    if $self->auto_prereqs;

  $self->add_plugins(
#   [ 'MetaData::BuiltWith' => { show_uname => 1 } ], # currently DZ::Util::EmulatePhase causes problems
    [
      MetaNoIndex => {
        # could use grep { -d $_ } but that will miss any generated files
        directory => [qw(corpus examples inc share t xt)],
        namespace => [qw(Local t::lib)],
        'package' => [qw(DB)],
      }
    ],
    [   # AFTER MetaNoIndex
      'MetaProvides::Package' => {
        meta_noindex => 1
      }
    ],

    qw(
      MinimumPerl
      MetaConfig
      MetaYAML
      MetaJSON
    ),

# I prefer to be explicit about required versions when loading, but this is a handy example:
#    [
#      Prereqs => 'TestMoreWithSubtests' => {
#        -phase => 'test',
#        -type  => 'requires',
#        'Test::More' => '0.96'
#      }
#    ],

  # build system
    qw(
      ExecDir
      ShareDir
      MakeMaker
      ModuleBuild
      DualBuilders
    ),

  # generated t/ tests
    qw(
      ReportVersions::Tiny
    ),

  # generated xt/ tests
    # Test::Pod::Spelling::CommonMistakes ?
      #Test::Pod::No404s # removed since it's rarely useful
  );
  if ( $spelling_tests ) {
    $self->add_plugins('Test::PodSpelling');
  }
  else {
    $self->log("Test::PodSpelling Plugin failed to load.  Pleese dunt mayke ani misteaks.\n");
  }

  $self->add_bundle(
    '@TestingMania' => $self->config_slice({ disable_tests => 'disable' })
  );

  $self->add_plugins(
  # manifest: must come after all generated files
    'Manifest',

  # before release
    qw(
      CheckExtraTests
      CheckChangesHasContent
      TestRelease
      ConfirmRelease
    ),

  );

  # release
  my $releaser = $self->fake_release ? 'FakeRelease' : $self->releaser;
  # ignore releaser if it's set to empty string
  $self->add_plugins($releaser)
    if $releaser;

  # defaults: { tag_format => '%v', push_to => [ qw(origin) ] }
  $self->add_bundle( '@Git' )
    if $self->use_git_bundle;

  $self->add_plugins(
    [ InstallRelease => { install_command => $self->install_command } ]
  )
    if $self->install_command;

}

# As of Dist::Zilla 4.102345 pluginbundles don't have log and log_fatal methods
foreach my $method ( qw(log log_fatal) ){
  unless( __PACKAGE__->can($method) ){
    no strict 'refs'; ## no critic (NoStrict)
    *$method = $method =~ /fatal/
      ? sub { die($_[1]) }
      : sub { warn("[${\$_[0]->_bundle_name}] $_[1]") };
  }
}

sub _generate_manifest_skip {
  # include a default MANIFEST.SKIP for the tests and/or historical reasons
  return [
    GenerateFile => 'GenerateManifestSkip' => {
      filename => 'MANIFEST.SKIP',
      is_template => 1,
      content => <<'EOF_MANIFEST_SKIP',

\B\.git\b
\B\.gitignore$
^[\._]build
^blib/
^(Build|Makefile)$
\bpm_to_blib$
^MYMETA\.

EOF_MANIFEST_SKIP
    }
  ];
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;


__END__
=pod

=for :stopwords Randy Stauner ACKNOWLEDGEMENTS RWSTAUNER's PluginBundle PluginBundles
DAGOLDEN RJBS dists ini arrayrefs releaser cpan testmatrix url annocpan
anno bugtracker rt cpants kwalitee diff irc mailto metadata placeholders

=head1 NAME

Dist::Zilla::PluginBundle::Author::RWSTAUNER - RWSTAUNER's Dist::Zilla config

=head1 VERSION

version 3.107

=head1 SYNOPSIS

  # dist.ini

  [@Author::RWSTAUNER]

=head1 DESCRIPTION

This is an Author
L<Dist::Zilla::PluginBundle|Dist::Zilla::Role::PluginBundle::Easy>
that I use for building my dists.

This Bundle was heavily influenced by the bundles of
L<RJBS|Dist::Zilla::PluginBundle::RJBS> and
L<DAGOLDEN|Dist::Zilla::PluginBundle::DAGOLDEN>.

=for Pod::Coverage configure
log log_fatal

=head1 CONFIGURATION

Possible options and their default values:

  auto_prereqs   = 1  ; enable AutoPrereqs
  disable_tests  =    ; corresponds to @TestingMania:disable
  fake_release   = 0  ; if true will use FakeRelease instead of 'releaser'
  install_command = cpanm -v -i . (passed to InstallRelease)
  is_task        = 0  ; set to true to use TaskWeaver instead of PodWeaver
  placeholder_comments = 0 ; use '# VERSION' and '# AUTHORITY' comments
  releaser       = UploadToCPAN
  skip_plugins   =    ; default empty; a regexp of plugin names to exclude
  skip_prereqs   =    ; default empty; corresponds to AutoPrereqs:skip
  weaver_config  = @Author::RWSTAUNER

The C<fake_release> option also respects C<$ENV{DZIL_FAKERELEASE}>.

The C<release> option can be set to an alternate releaser plugin
or to an empty string to disable adding a releaser.
This can make it easier to include a plugin that requires configuration
by just ignoring the default releaser and including your own normally.

B<Note> that you can also specify attributes for any of the bundled plugins.
This works like L<Dist::Zilla::Role::Stash::Plugins> except that the role is
not actually used (and there is no stash) because PluginBundles already have
a dynamic configuration.
The option should be the plugin name and the attribute separated by a colon
(or a dot, or any other non-word character(s)).

For example:

  [@Author::RWSTAUNER]
  AutoPrereqs:skip = Bad::Module

B<Note> that this is different than

  [@Author::RWSTAUNER]
  [AutoPrereqs]
  skip = Bad::Module

which will load the plugin a second time.
The first example actually alters the plugin configuration
as it is included by the Bundle.

String (or boolean) attributes will overwrite any in the Bundle:

  [@Author::RWSTAUNER]
  CompileTests.fake_home = 0

Arrayref attributes will be appended to any in the bundle:

  [@Author::RWSTAUNER]
  MetaNoIndex:directory = another-dir

Since the Bundle initializes MetaNoIndex:directory to an arrayref
of directories, C<another-dir> will be appended to that arrayref.

You can overwrite the attribute by adding non-word characters to the end of it:

  [@Author::RWSTAUNER]
  MetaNoIndex:directory@ = another-dir
  ; or MetaNoIndex:directory[] = another-dir

You can use any non-word characters: use what makes the most sense to you.
B<Note> that you cannot specify an attribute more than once
(since the configuration is dynamic
and the Bundle cannot predeclare unknown attributes as arrayrefs).

If your situation is more complicated you can use the C<skip_plugins>
attribute to have the Bundle ignore that plugin
and then you can add it yourself:

  [MetaNoIndex]
  directory = one-dir
  directory = another-dir
  [@Author::RWSTAUNER]
  skip_plugins = MetaNoIndex

=head1 EQUIVALENT F<dist.ini>

This bundle is roughly equivalent to:

  [Git::NextVersion]      ; autoincrement version from last tag

  ; choose files to include (dzil core [@Basic])
  [GatherDir]             ; everything under top dir
  [PruneCruft]            ; default stuff to skip
  [ManifestSkip]          ; custom stuff to skip
  ; use PruneFiles to specifically remove ^(dist.ini)$
  ; use PruneFiles to specifically remove ^(README.pod)$ (just for github)

  ; munge files
  [Authority]             ; inject $AUTHORITY into modules
  do_metadata = 1         ; default
  [NextRelease]           ; simplify maintenance of Changes file
  ; use W3CDTF format for release timestamps (for unambiguous dates)
  time_zone = UTC
  format    = %-9v %{yyyy-MM-dd'T'HH:mm:ss'Z'}d
  [PkgVersion]            ; inject $VERSION (use OurPkgVersion if 'placeholder_comments')
  [Prepender]             ; add header to source code files

  [PodWeaver]             ; munge POD in all modules
  config_plugin = @Author::RWSTAUNER
  ; 'weaver_config' can be set to an alternate Bundle
  ; set 'is_task = 1' to use TaskWeaver instead

  ; generate files
  [License]               ; generate distribution files (dzil core [@Basic])
  [Readme]

  ; metadata
  [Bugtracker]            ; include bugtracker URL and email address (uses RT)
  [Repository]            ; determine git information (if -e ".git")
  [GithubMeta]            ; overrides [Repository] if repository is on github

  [AutoPrereqs]
  ; disable with 'auto_prereqs = 0'

  [MetaNoIndex]           ; encourage CPAN not to index:
  directory = corpus
  directory = examples
  directory = inc
  directory = share
  directory = t
  directory = xt
  namespace = Local
  namespace = t::lib
  package   = DB

  [MetaProvides::Package] ; describe packages included in the dist
  meta_noindex = 1        ; ignore things excluded by above MetaNoIndex

  [MinimumPerl]           ; automatically determine Perl version required

  [MetaConfig]            ; include Dist::Zilla info in distmeta (dzil core)
  [MetaYAML]              ; include META.yml (v1.4) (dzil core [@Basic])
  [MetaJSON]              ; include META.json (v2) (more info than META.yml)

  [Prereqs / TestRequires]
  Test::More = 0.96       ; require recent Test::More (including subtests)

  [ExtraTests]            ; build system (dzil core [@Basic])
  [ExecDir]               ; include 'bin/*' as executables
  [ShareDir]              ; include 'share/' for File::ShareDir

  [MakeMaker]             ; create Makefile.PL
  [ModuleBuild]           ; create Build.PL
  [DualBuilders]          ; only require one of the above two (prefer 'build')

  ; generate t/ and xt/ tests
  [ReportVersions::Tiny]  ; show module versions used in test reports
  [@TestingMania]         ; Lots of dist tests
  [Test::PodSpelling]     ; spell check POD (if installed)

  [Manifest]              ; build MANIFEST file (dzil core [@Basic])

  ; actions for releasing the distribution (dzil core [@Basic])
  [CheckChangesHasContent]
  [TestRelease]           ; run tests before releasing
  [ConfirmRelease]        ; are you sure?
  [UploadToCPAN]
  ; see CONFIGURATION for alternate Release plugin configuration options

  [@Git]                  ; use Git bundle to commit/tag/push after releasing
  [InstallRelease]        ; install the new dist (using 'install_command')

=head1 SEE ALSO

=over 4

=item *

L<Dist::Zilla>

=item *

L<Dist::Zilla::Role::PluginBundle::Easy>

=item *

L<Pod::Weaver>

=back

=head1 SUPPORT

=head2 Perldoc

You can find documentation for this module with the perldoc command.

  perldoc Dist::Zilla::PluginBundle::Author::RWSTAUNER

=head2 Websites

The following websites have more information about this module, and may be of help to you. As always,
in addition to those websites please use your favorite search engine to discover more resources.

=over 4

=item *

Search CPAN

The default CPAN search engine, useful to view POD in HTML format.

L<http://search.cpan.org/dist/Dist-Zilla-PluginBundle-Author-RWSTAUNER>

=item *

RT: CPAN's Bug Tracker

The RT ( Request Tracker ) website is the default bug/issue tracking system for CPAN.

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Dist-Zilla-PluginBundle-Author-RWSTAUNER>

=item *

CPAN Ratings

The CPAN Ratings is a website that allows community ratings and reviews of Perl modules.

L<http://cpanratings.perl.org/d/Dist-Zilla-PluginBundle-Author-RWSTAUNER>

=item *

CPAN Testers

The CPAN Testers is a network of smokers who run automated tests on uploaded CPAN distributions.

L<http://www.cpantesters.org/distro/D/Dist-Zilla-PluginBundle-Author-RWSTAUNER>

=item *

CPAN Testers Matrix

The CPAN Testers Matrix is a website that provides a visual overview of the test results for a distribution on various Perls/platforms.

L<http://matrix.cpantesters.org/?dist=Dist-Zilla-PluginBundle-Author-RWSTAUNER>

=item *

CPAN Testers Dependencies

The CPAN Testers Dependencies is a website that shows a chart of the test results of all dependencies for a distribution.

L<http://deps.cpantesters.org/?module=Dist::Zilla::PluginBundle::Author::RWSTAUNER>

=back

=head2 Bugs / Feature Requests

Please report any bugs or feature requests by email to C<bug-dist-zilla-pluginbundle-author-rwstauner at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Dist-Zilla-PluginBundle-Author-RWSTAUNER>. You will be automatically notified of any
progress on the request by the system.

=head2 Source Code


L<https://github.com/rwstauner/Dist-Zilla-PluginBundle-Author-RWSTAUNER>

  git clone https://github.com/rwstauner/Dist-Zilla-PluginBundle-Author-RWSTAUNER.git

=head1 AUTHOR

Randy Stauner <rwstauner@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Randy Stauner.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

