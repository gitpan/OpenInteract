package OpenInteract2::Response::LWP;

# $Id: LWP.pm,v 1.22 2005/03/17 14:58:05 sjn Exp $

use strict;
use base qw( OpenInteract2::Response );
use HTTP::Response;
use HTTP::Status             qw( RC_OK RC_FOUND );
use IO::File;
use Log::Log4perl            qw( get_logger );
use OpenInteract2::Constants qw( :log );
use OpenInteract2::Context   qw( CTX );
use OpenInteract2::Exception qw( oi_error );

$OpenInteract2::Response::LWP::VERSION  = sprintf("%d.%02d", q$Revision: 1.22 $ =~ /(\d+)\.(\d+)/);

my ( $log );

my @FIELDS = qw( lwp_response client );
OpenInteract2::Response::LWP->mk_accessors( @FIELDS );

sub init {
    my ( $self, $params ) = @_;
    $self->client( $params->{client} );
    $self->lwp_response( $params->{response} );
    return $self;
}

sub send {
    my ( $self ) = @_;
    $log ||= get_logger( LOG_RESPONSE );

    $log->is_info && $log->info( "Sending LWP response" );
    if ( $self->is_redirect ) {
        $log->is_info
            && $log->info( "Response is redirect, already sent" );
        return;
    }
    $self->content_type( 'text/html' ) unless ( $self->content_type );
    $self->status( RC_OK )             unless ( $self->status );

    $self->save_session;
    $log->is_info && $log->info( "Saved session ok" );

    if ( $self->lwp_response ) {
        $self->lwp_response->code( $self->status );
    }
    else {
        $self->lwp_response( HTTP::Response->new( $self->status ) );
    }
    if ( my $filename = $self->send_file ) {
        $self->set_file_info;
        $self->_set_lwp_headers;
        my $fh = IO::File->new( "< $filename" )
                    || oi_error "Cannot open file '$filename': $!";
        $self->client->send_file( $fh );
        $log->is_info &&
            $log->info( "Sent file '$filename' directly to client" );
    }
    else {
        $self->_set_lwp_headers;
        $self->lwp_response->content(
            ( ref $self->content ) ? ${ $self->content } : $self->content
        );
        if ( my $client = $self->client ) {
            $client->send_response( $self->lwp_response );
            $log->is_info && $log->info( "Sent response ok" );
        }
        else {
            $log->is_info &&
                $log->info( "Set content/headers but did not send content" );
        }
    }
}


sub redirect {
    my ( $self, $url ) = @_;
    $log ||= get_logger( LOG_RESPONSE );

    $self->save_session;

    $url ||= $self->return_url;
    $log->is_info &&
        $log->info( "Got request for redirect to '$url'" );

    my $lwp_response = $self->lwp_response;
    unless ( $lwp_response ) {
        $self->lwp_response( HTTP::Response->new( RC_FOUND ) );
        $lwp_response = $self->lwp_response;
    }
    else {
        $lwp_response->code( RC_FOUND );
    }
    $self->status( RC_FOUND );
    $lwp_response->header( Location => $url );
    $log->is_info &&
        $log->info( "Set 'Location' header to ", $lwp_response->header( 'Location' ) );
    $self->_set_lwp_cookies;
    $log->debug( "Getting ready to send response: ", CTX->dump( $lwp_response ) );
    if ( my $client = $self->client ) {
        $client->send_response( $lwp_response );
    }
    $log->is_info && $log->info( "Sent redirect ok" );
}

sub _set_lwp_headers {
    my ( $self ) = @_;
    $log ||= get_logger( LOG_RESPONSE );

    my $lwp_response = $self->lwp_response;
    $lwp_response->code( $self->status );

    $self->content_type( 'text/html' ) unless ( $self->content_type );

    while ( my ( $name, $value ) = each %{ $self->header } ) {
        if ( ref $value eq 'ARRAY' ) {
            $lwp_response->push_header( $name => $_ ) for ( @{ $value } );
        }
        elsif ( $name eq 'Content-Type' ) {
            $lwp_response->header( $name => $self->content_type_header );
        }
        else {
            $lwp_response->header( $name => $value );
        }
    }
    if ( CTX->server_config->{promote_oi} eq 'yes' ) {
        $lwp_response->header( 'X-Powered-By' => 'OpenInteract ' . CTX->version );
    }
    $log->is_debug && $log->debug( "Set response headers ok" );
    $self->_set_lwp_cookies;
}

sub _set_lwp_cookies {
    my ( $self ) = @_;
    $log ||= get_logger( LOG_RESPONSE );

    for ( @{ $self->cookie } ) {
        $self->lwp_response->push_header( 'Set-Cookie' => $_->as_string );
    }
    $log->is_debug && $log->debug( "Set response cookies ok" );
}

1;

__END__

=head1 NAME

OpenInteract2::Response::LWP - Response handler using LWP

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head1 SEE ALSO

=head1 COPYRIGHT

Copyright (c) 2002-2005 Chris Winters. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHORS

Chris Winters E<lt>chris@cwinters.comE<gt>
