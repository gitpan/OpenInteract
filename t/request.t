# -*-perl-*-

# $Id: request.t,v 1.3 2003/08/21 15:42:09 lachoy Exp $

use strict;
use lib 't/';
require 'utils.pl';
use Test::More  tests => 49;

require_ok( 'OpenInteract2::Request' );

{
    eval { OpenInteract2::Request->new };
    like( $@, qr/^Before creating an OpenInteract2::Request object/,
          'Call to create object failed before implementation type set' );
    eval { OpenInteract2::Request->set_implementation_type( 'foo' ) };
    ok( $@, 'Call to set invalid implementation type failed' );
}

my $ctx = initialize_context();

{
    my $initial_impl_type = OpenInteract2::Request->get_implementation_type;
    is( $initial_impl_type, 'cgi',
        'Initial implementation type set from context/initialization' );
    OpenInteract2::Request->set_implementation_type( 'lwp' );
    is( OpenInteract2::Request->get_implementation_type, 'lwp',
        'Implementation type set' );
    OpenInteract2::Request->set_implementation_type( $initial_impl_type );
    my $request = OpenInteract2::Request->new;
    isa_ok( $request, 'OpenInteract2::Request::CGI',
            'New request created of correct type' );
}

{
    my $request = OpenInteract2::Request->new;
    is( $request->param( 'bar' ), undef,
        'Nonexistent parameter value returned' );
    is( $request->param_toggled( 'bar' ), 'no',
        '...toggled value returned' );
    is( $request->param_date( 'bar' ), undef,
        '...date value returned' );
    is( $request->param_datetime( 'bar' ), undef,
        '...datetime value returned' );

    my $p1 = eval { $request->param( foo => 'bar' ) };
    ok( ! $@, 'Single value parameter set' );
    is( $p1, 'bar',
         '...correct value returned from set' );
    is( $request->param( 'foo' ), 'bar',
        '...correct value returned from get' );
    is( $request->param_toggled( 'foo' ), 'yes',
        '...toggled value returned' );
    is( $request->param_date( 'foo' ), undef,
        '...date value returned' );
    is( $request->param_datetime( 'foo' ), undef,
        '...datetime value returned' );

    my @words =  qw( fee fi fo );
    my @p2 = eval { $request->param( words => \@words ) };
    ok( ! $@, 'Multiple value parameter set' );
    eq_array( \@p2, \@words,
              '...correct values returned from set in list context' );
    my $p3 = eval { $request->param( words => \@words ) };
    eq_array( $p3, \@words,
              '...correct values returned from set in scalar context' );
    my @p4 = $request->param( 'words' );
    eq_array( \@p4, \@words,
              '...correct values returned from get in list context' );
    my $p5 = $request->param( 'words' );
    eq_array( $p5, \@words,
              '...correct values returned from get in scalar context' );
    is( $request->param_toggled( 'words' ), 'yes',
        '...toggled value returned' );
    is( $request->param_date( 'words' ), undef,
        '...date value returned' );
    is( $request->param_datetime( 'words' ), undef,
        'datetime value returned' );

    eval {
        $request->param( 'baz_year', 1999 );
        $request->param( 'baz_month', 12 );
        $request->param( 'baz_day', 31 );
    };
    ok( ! $@, 'Individual date values set' );
    my $date1 = $request->param_date( 'baz' ) ;
    isa_ok( $date1, 'DateTime',
            'Date value returned as object' );
    is( $date1->year, 1999,
        '...with correct year' );
    is( $date1->month, 12,
        '...with correct month' );
    is( $date1->day, 31,
        '...with correct day' );

    eval {
        $request->param( 'zaz_year', 2020 );
        $request->param( 'zaz_month', 1 );
        $request->param( 'zaz_day', 13 );
        $request->param( 'zaz_hour', 14 );
        $request->param( 'zaz_minute', 35 );
    };
    ok( ! $@, 'Individual date time values set' );
    my $date2 = $request->param_date( 'zaz' ) ;
    isa_ok( $date2, 'DateTime',
            'Date value returned as object' );
    is( $date2->year, 2020,
        '...with correct year' );
    is( $date2->month, 1,
        '...with correct month' );
    is( $date2->day, 13,
        '...with correct day' );

    my $date3 = $request->param_datetime( 'zaz' );
    isa_ok( $date3, 'DateTime',
            'Date time value returned as object' );
    is( $date3->year, 2020,
        '...with correct year' );
    is( $date3->month, 1,
        '...with correct month' );
    is( $date3->day, 13,
        '...with correct day' );
    is( $date3->hour, 14,
        '...with correct hour' );
    is( $date3->minute, 35,
        '...with correct minute' );

    $request->param( 'yaz_date', '2000-04-08' );
    my $date4 = eval { $request->param_date( 'yaz_date', '%Y-%m-%d' ) };
    ok( ! $@, 'Created date from single parameter value and format' );
    isa_ok( $date4, 'DateTime',
            'Date time from format value returned as object' );
    is( $date4->year, 2000,
        '...with correct year' );
    is( $date4->month, 4,
        '...with correct month' );
    is( $date4->day, 8,
        '...with correct day' );

    $request->param( 'maz_datetime', '2000-04-08 5:30 pm' );
    my $date5 = eval { $request->param_datetime( 'maz_datetime', '%Y-%m-%d %I:%M %p' ) };
    ok( ! $@, 'Created date/time with single parameter value and format' );
    isa_ok( $date5, 'DateTime',
            'Date time from format value returned as object' );
    is( $date5->year, 2000,
        '...with correct year' );
    is( $date5->month, 4,
        '...with correct month' );
    is( $date5->day, 8,
        '...with correct day' );
    is( $date5->hour, 17,
        '...with correct hour' );
    is( $date5->minute, 30,
        '...with correct minute' );
}

initialize_request({ url => '/NothingDoing/' });

{
    my $request_current = OpenInteract2::Request->get_current();
    my $ctx_current     = $ctx->request;
    ok( $request_current == $ctx_current,
        'Same object returned from context and request as current' );
}
