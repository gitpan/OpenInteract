#!/usr/bin/perl

use strict;
use Apache2 ();
use Apache2::OpenInteract2;
use CGI;
use Log::Log4perl;
use OpenInteract2::Config::Base;
use OpenInteract2::Constants qw( :log );
use OpenInteract2::Context;

CGI->compile( ':all' );

my $BASE_CONFIG_FILE = '[% website_dir %]/conf/base.conf';

{
    Log::Log4perl::init( '[% website_dir %]/conf/log4perl.conf' );
    my $base_config = OpenInteract2::Config::Base->new(
                              { filename => $BASE_CONFIG_FILE } );
    my $ctx = OpenInteract2::Context->create(
                    $base_config, { temp_lib_create => 'create' } );
    $ctx->assign_request_type( 'apache2' );
    $ctx->assign_response_type( 'apache2' );
}

1;
