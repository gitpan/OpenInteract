# $Id: utils.pl,v 1.51 2004/05/22 17:40:04 lachoy Exp $

use strict;
use Data::Dumper             qw( Dumper );
use File::Basename           qw( basename );
use File::Path               qw();
use File::Spec::Functions    qw( :ALL );
use IO::File;
use Log::Log4perl            qw( :levels );
use OpenInteract2::Context   qw( CTX );
use OpenInteract2::Config::Ini;
use OpenInteract2::Log;
use OpenInteract2::Manage;
use OpenInteract2::Setup;
use Test::More;

my $WEBSITE_CREATE_THRESHOLD = 60 * 60;      # 60 minutes
my ( $TEST_DIR );

$Data::Dumper::Indent = 1;

my ( $log );

BEGIN {
    $log = OpenInteract2::Log->init_file( 'oi2_tests.log', $INFO );
    $log->info( "Starting test run" );
}

END {
    $log->info( "Finished test run" );
}

sub main::LOG {
     return $log;
}

# Dump out a reference

sub main::barf {
    my ( $ref ) = @_;
    warn Dumper( $ref ), "\n";
}

sub main::get_package_versions {
    return (
         base            => '2.10',
         base_box        => '2.11',
         base_error      => '2.10',
         base_group      => '2.11',
         base_page       => '2.21',
         base_security   => '2.13',
         base_template   => '3.11',
         base_theme      => '2.09',
         base_user       => '2.27',
         comments        => '1.10',
         full_text       => '2.09',
         lookup          => '2.04',
         news            => '2.13',
         object_activity => '2.11',
         system_doc      => '2.05',
         whats_new       => '2.04',
   );
}

########################################
# CUSTOM COMPARISONS

sub main::compare_urls {
    my ( $url_base, $query_base, $url_created, $desc ) = @_;
    my ( $path_created, $query_created ) = split /\?/, $url_created, 2;
    is( $path_created, $url_base,
        "$desc: base paths match" );
    my %query_map = map { split( '=', $_ ) }
                        split( '&amp;', $query_created );
    is_deeply( \%query_map, $query_base,
               "$desc: query strings match" );
}

########################################
# TESTING DIRECTIRIES

# Returns a FULL path to the current directory

sub main::get_current_dir {
    return rel2abs( curdir );
}

# Get the base testing directory - assume we're either in the
# distribution root or in the testing directory...

sub main::get_test_dir {
    return $TEST_DIR if ( $TEST_DIR );
    my $cwd = get_current_dir();
    my $test_dir = ( $cwd =~ m|\bt$| ) ? $cwd : catdir( $cwd, 't' );
    return $TEST_DIR = $test_dir;
}

# Directory with all of our files to use for tests

sub main::get_use_dir {
    return catdir( get_test_dir(), 'use' );
}

sub main::get_tmp_dir {
    return catdir( get_test_dir(), '_tmp' );
}

# Get the base website directory for testing

sub main::get_test_site_dir {
    return catdir( get_tmp_dir(), 'site' );
}

sub main::get_test_site_db_file {
    catfile( get_tmp_dir(), 'oi2test.db' );
}

# Get the base directory for our test package

sub main::get_test_package_dir {
    return catdir( get_test_dir(), 'test_pkg' );
}

# This should be the parent of the test directory...

sub main::get_source_dir {
    my $test_dir = get_test_dir();
    my @dirs = splitdir( $test_dir );
    pop @dirs;
    return catdir( @dirs );
}


sub main::rmtree {
    return File::Path::rmtree( [ @_ ] );
}

sub main::mkpath {
    return File::Path::mkpath( [ @_ ] );
}

########################################
# TEST FILE LOCATOR

sub main::get_use_file {
    my ( $filename, $type ) = @_;
    return get_test_file( [ 'use', $filename ], $type );
}

# Uses:
#   $absolute_filename = get_test_file( 'this/that/base.conf', 'name' );
#   $filehandle = get_test_file( 'this/that/base.conf', 'filehandle' );
#   $content = get_test_file( 'this/that/base.conf', 'content' );

sub main::get_test_file {
    my ( $filename, $type ) = @_;
    unless ( ref $filename eq 'ARRAY' ) {
        $filename = [ $filename ];
    }
    $type ||= 'content';
    my $full_filename = catfile( get_test_dir(),
                                             @{ $filename } );
    if ( $type eq 'name' ) {
        return $full_filename;
    }

    my $file = IO::File->new( $full_filename )
                    || die "Failed to read '$filename': $!";
    if ( $type eq 'filehandle' ) {
        return $file;
    }
    elsif ( $type eq 'content' ) {
        local $/ = undef;
        my $content = <$file>;
        close( F );
        return $content
    }
    die "Invalid type to 'get_test_file()': $type\n";
}


########################################
# WEBSITE INSTALL/CONTEXT INIT

sub main::install_website {
    my $source_dir  = get_source_dir();
    my $website_dir = get_test_site_dir();
    my $is_recent = _is_recent_website( $website_dir );

    eval {
        require SPOPS::DBI::SQLite;
    };
    if ( $@ ) {
        die "Failed to require SQLite module: $@";
    }

    eval {
        require Apache::Session::File;
        require OpenInteract2::SessionManager::File;
    };
    if ( $@ ) {
        die "Failed to require file session modules: $@";
    }

    if ( -d $website_dir and $is_recent ) {
        return $website_dir;
    }
    elsif ( ! -d $website_dir ) {
        warn "\nTesting website does not exist so I'll create one.\n",
             "This may take a while...\n";
    }
    elsif ( ! $is_recent ) {
        warn "\nTesting website exists but it's too old so I'll create one.\n",
             "This may take a while...\n";
    }
    if ( -d $website_dir ) {
        LOG()->debug( "Removing existing dir '$website_dir'" );
        rmtree( $website_dir );
        my $db_file = get_test_site_db_file();
        LOG()->debug( "Removing existing db file '$db_file'" );
        unlink( $db_file );
    }
    my $tmp_dir = get_tmp_dir();
    unless ( -d $tmp_dir ) {
        LOG()->debug( "Creating temp dir '$tmp_dir'" );
        mkdir( $tmp_dir, 0777 );
    }

    # let any errors bubble up
    my $manage = OpenInteract2::Manage->new( 'create_website',
                                             { website_dir => $website_dir,
                                               source_dir  => $source_dir } );
    LOG()->debug( "Created management task for creating website" );
    $manage->execute;
    LOG()->debug( "Executed management task ok" );

    _write_website_check_file();
    _modify_server_config();

    CTX->setup({ skip => 'activate spops' });
    OpenInteract2::Manage->new( 'install_sql',
                                { website_dir => $website_dir,
                                  package     => [ 'SYSTEM' ] } )
                         ->execute;
    OpenInteract2::Setup->activate_spops_classes;
    return $website_dir;
}

sub _is_recent_website {
    my ( $website_dir ) = @_;
    my $check_recent_file = _get_website_check_file();
    return 0 unless ( -f $check_recent_file );
    my $mtime = (stat $check_recent_file)[9];
    return 0 if ( time - $mtime > $WEBSITE_CREATE_THRESHOLD );
    return 1;
}

sub _write_website_check_file {
    my $check_recent = _get_website_check_file();
    open( RECENT, '>', $check_recent )
                    || die "Cannot open file to check whether site is recently installed: $!";
    print RECENT qq(Placeholder file so we know what time this testing website\n),
                 qq(was created -- if it's too old we'll create a new one.);
    close( RECENT );
}

sub _get_website_check_file {
    return catfile( get_tmp_dir(), '_site_time' );
}

# Write out SQLite information so that the Context gets read in
# properly (SPOPS classes need this); use file-based sessions and
# write the appropriate directories

sub _modify_server_config {
    my $site_dir = get_test_site_dir();
    my $config_file = catfile( $site_dir, 'conf', 'server.ini' );
    my $db_file = get_test_site_db_file();
    my $ini = OpenInteract2::Config::Ini->new({ filename => $config_file });
    $ini->{datasource}{main}{spops}       = 'SPOPS::DBI::SQLite';
    $ini->{datasource}{main}{driver_name} = 'SQLite';
    $ini->{datasource}{main}{dsn}         = "dbname=$db_file";
    $ini->{session_info}{class}           = 'OpenInteract2::SessionManager::File';
    $ini->{session_info}{impl_class}      = 'Apache::Session::File';

    my $session_dir = catdir( $site_dir, 'cache', 'session' );
    File::Path::mkpath( $session_dir );
    $ini->{session_info}{params}{Directory} = $session_dir;
    my $lock_dir = catdir( $site_dir, 'cache', 'session_lock' );
    File::Path::mkpath( $lock_dir );
    $ini->{session_info}{params}{LockDirectory} = $lock_dir;

    $ini->write_file;
}

sub main::initialize_context {
    install_website();
    unless ( CTX ) {
        OpenInteract2::Context->create(
                    { website_dir => get_test_site_dir() });
    }
    return CTX;
}

sub main::initialize_request {
    my ( $request_props, $response_props ) = @_;
    unless ( CTX ) {
        initialize_context();
    }
    CTX->assign_response_type( 'standalone' );
    CTX->assign_request_type( 'standalone' );
    my $rsp = OpenInteract2::Response->new( $response_props );
    my $req = OpenInteract2::Request->new( $request_props );
    return $req;
}


########################################
# TRACK DIRS/FILES

sub count_dirs {
    my ( $dir ) = @_;
    my @dirs = _get_dirs( $dir );
    return scalar @dirs;
}

sub first_dir {
    my ( $dir ) = @_;
    my @dirs = _get_dirs( $dir );
    return $dirs[0];
}

sub last_dir {
    my ( $dir ) = @_;
    my @dirs = _get_dirs( $dir );
    return $dirs[-1];
}

sub count_files {
    my ( $dir ) = @_;
    my @files = _get_files( $dir );
    return scalar @files;
}

sub first_file {
    my ( $dir ) = @_;
    my @files = _get_files( $dir );
    return $files[0];
}

sub last_file {
    my ( $dir ) = @_;
    my @files = _get_files( $dir );
    return $files[-1];
}

sub _get_dirs {
    my ( $dir ) = @_;
    return grep { -d catdir( $dir, $_ ) }
           _get_entries_in_dir( $dir );
}

sub _get_files {
    my ( $dir ) = @_;
    return grep { -f catfile( $dir, $_ ) }
                _get_entries_in_dir( $dir );
}

sub _get_entries_in_dir {
    my ( $dir ) = @_;
    opendir( ENTRIES, $dir )
                    || die "Cannot open directory '$dir': $!";
    my @entries = grep ! /^(\.|\.\.)$/, readdir( ENTRIES );
    closedir( ENTRIES );
    return sort @entries;
}
