package OpenInteract;

# $Id: OpenInteract.pm,v 1.7 2001/08/13 05:10:47 lachoy Exp $

use strict;
use Apache::Constants qw( :common :remotehost );
use Data::Dumper      qw( Dumper );

@OpenInteract::ISA     = ();
$OpenInteract::VERSION = sprintf("%d.%02d", q$Revision: 1.7 $ =~ /(\d+)\.(\d+)/);

# Generic separator used in display

my $SEP = '=' x 30;

# Keep track of what's been require'd

my %REQ = ();


sub handler {
    my ( $apache ) = @_;

    # Create the big cheese object (aka, "Big R") and populate with some
    # basic info

    my $R = eval { _setup_request( $apache ) };
    if ( $@ ) {
        _send_html( $apache, $@ );
        return OK;
    }
    $R->DEBUG && $R->scrib( 1, "\n\n$SEP\nRequest started:", scalar localtime( $R->{time} ), "\n",
                               "path: (", $apache->parsed_uri->path, ") PID: ($$)" );

    # Go through all of our important steps -- we setup the basic
    # environment, generate the content and run additional routines after
    # the content has completed for tracking (session, cookies, etc.)
    #
    # If there is a problem with a routine it will die with the
    # appropriate Apache constant (usually OK) and if we find it we force
    # it to numeric context and return it.

    my ( $page );
    eval {
        _setup_apache( $R, $apache );
        _setup_cache( $R );
        _parse_uri( $R );
        _find_action_handler( $R );
        _setup_cookies_and_session( $R );
        _setup_authentication( $R );
        _setup_theme( $R );
        $page = _run_content_handler( $R );
        _finish_cookies_and_session( $R );
    }; 
    if ( $@ ) {
        warn " --EXITED WITH ERROR from main handler eval block\nError: $@\n";
        return _bail( $@ );
    }

    if ( $R->{page}->{send_file} ) { _send_static_file( $R ) }
    else                           { _send_html( $apache, $page, $R ) }

    _cleanup( $R );
    return OK;
}

sub _bail {
    my ( $msg ) = @_;
    $msg = $msg + 0;
    return $msg;
}


# Setup the OpenInteract::Request object

sub _setup_request {
    my ( $apache ) = @_;

    # Read the stash class from our httpd.conf and grab the config
    # object

    my $STASH_CLASS = $apache->dir_config( 'StashClass' );
    unless ( $REQ{ $STASH_CLASS } ) {
        eval "require $STASH_CLASS";
        die "Cannot require stash class ($STASH_CLASS)!\n" if ( $@ );
        $REQ{ $STASH_CLASS }++;
    }
    my $C = $STASH_CLASS->get_stash( 'config' );
    unless ( ref $C and scalar keys %{ $C } ) {
        die "Cannot find configuration object from stash class ($STASH_CLASS). Cannot continue!";
    }

    # Create the base request object that contains other objects and
    # info

    my $REQUEST_CLASS = $C->{request_class};
    unless ( $REQ{ $REQUEST_CLASS } ) {
        eval "require $REQUEST_CLASS";
        die "Cannot require request class ($REQUEST_CLASS)!\n" if ( $@ );
        $REQ{ $REQUEST_CLASS }++;
    }
    my $R = $REQUEST_CLASS->instance;
    $R->{stash_class} = $STASH_CLASS;
    $R->{pid}         = $$;
    $R->{time}        = time;
    return $R;
}


# The Apache::Request subclasses the main Apache object and has
# additional methods to parse GET/POST data, including file
# uploads. Stash this object then get the server name and remote IP
# address -- if you're using a proxy, be sure that this has been
# passed from the front end server using mod_proxy_add_forward

sub _setup_apache {
    my ( $R, $apache ) = @_;
    my $apr = Apache::Request->new( $apache );
    $R->stash( 'apache', $apr );

    my $srv = $apr->server;
    $R->{server_name} = $srv->server_hostname;
    $R->DEBUG && $R->scrib( 1, "Server hostname set to $R->{server_name}" );

    $R->{remote_host} = $apr->connection->remote_ip();
    $R->DEBUG && $R->scrib( 1, "Request coming from $R->{remote_host}" );
    return undef;
}


# Create the cache object if we're supposed to

sub _setup_cache {
    my ( $R ) = @_;
    my $C = $R->CONFIG;
    if ( ! $R->cache and $C->{cache_info}->{data}->{use} ) {   
        my $cache_class = $C->{cache_info}->{data}->{class};
        $R->DEBUG && $R->scrib( 1, "Using cache and setting up with ($cache_class)" );
        my $cache = $cache_class->new( { config => $C } );
        $R->stash( 'cache', $cache );
    }
    return undef;
}


# Parse the URL into pieces, stroing everything relevant in
# $R->{path}. Also find the 'action' specified in the URL -- we use
# this to find a handler in the action table. Note that if the first
# item is actually a directive (such as 'Popup'), then we shift it off
# and it in $R->{ui}->{directive} so the UI handler knows it's
# around. After we do this the $R->{path}->{current} should be
# consistent, with the action as the first member.

sub _parse_uri {
    my ( $R ) = @_;

    # Get the Apache::URI object and put it in $R 

    # TODO: Do we EVER retrieve the URI object from the stash? Why put it there?

    my $apache = $R->apache;
    my $u = $apache->parsed_uri;
    $R->stash( 'uri', $u );

    # Get the path info from the URL and put it in $R; we save it twice
    # so we can shift items from one and still keep the original; we
    # also get the action name from the first item in the path

    my $location = $apache->location;
    my $path = $u->path;
    $R->DEBUG && $R->scrib( 1, "Original path: ($path)" );
    if ( $location ne '/' ) {
        $path =~ s/^$location//;
        $R->{path}->{location} = $location;
        $R->DEBUG && $R->scrib( 1, "Modified path by removing ($location): ($path)" );
    }
    my @choices = split /\//, $path;
    shift @choices;
    $R->DEBUG && $R->scrib( 1, "Items in the path: ", join( " // ", @choices ) );
    my @full_choices       = @choices;
    $R->{path}->{current}  = \@choices;
    $R->{path}->{full}     = \@full_choices;

    # If the first item is a directive, remove it and save it for the ui
    # handler; otherwise it's as if it never existed

    if ( $R->CONFIG->{page_directives}->{ $R->{path}->{current}->[0] } ) {
        $R->{ui}->{directive} = shift @{ $R->{path}->{current} };   
        $path = '/' . join( '/', @{ $R->{path}->{current} } );
    }
    $R->{ui}->{action} = $R->{path}->{current}->[0];
    $R->DEBUG && $R->scrib( 1, "Action found from URL: $R->{ui}->{action}" );

    # Note that $path might have been modified if the first item was a
    # directive

    $R->{path}->{original} = $path;
    $R->{path}->{original} .=  '?' . $u->query  if ( $u->query );
    $R->DEBUG && $R->scrib( 1, "Original path/query string set to: $R->{path}->{original}" );
    return undef;
}


# Match up the URL path to the UI action (Conductor) and store the
# relevant information in $R

sub _find_action_handler {
    my ( $R ) = @_;
    ( $R->{ui}->{class}, $R->{ui}->{method} ) = $R->lookup_conductor( $R->{ui}->{action} ); 
    unless ( $R->{ui}->{class} ) {
        $R->scrib( 0, " Conductor not found; displaying oops page." );
        eval { $R->throw({ code       => 301,
                           type       => 'file',
                           user_msg   => "Bad URL",
                           system_msg => "Cannot find conductor for $R->{ui}->{action}",
                           extra      => { url => $R->{path}->{original} } }) };
        if ( $@ ) {
            _send_html( $R->apache, $@, $R );
            die OK . "\n";
        }
    }
    $R->DEBUG && $R->scrib( 1, "Found $R->{ui}->{class} // $R->{ui}->{method} for conductor" );
    return undef;
}


sub _setup_cookies_and_session {
    my ( $R ) = @_;
    warn "trying to setup cookies/session\n";
    eval {
        $R->DEBUG && $R->scrib( 2, "Trying to use cookie class: ", $R->cookies );
        $R->cookies->parse;
        $R->DEBUG && $R->scrib( 2, "Cookies in:", Dumper( $R->{cookie}->{in} ) );
        $R->DEBUG && $R->scrib( 2, "Trying to use session class: ", $R->session );
        $R->session->parse;
    };
    if ( $@ ) { 
        _send_html( $R->apache, $@, $R );
        die OK . "\n";
    }
    return undef;
}


sub _finish_cookies_and_session {
    my ( $R ) = @_;
    eval {
        $R->session->save;
        $R->cookies->bake;
        $R->DEBUG && $R->scrib( 2, "Cookies out:", 
                                   join(" // ", map { $_->name . ' = ' . $_->value } 
                                                    values %{ $R->{cookie}->{out} } ) );
    };
    if ( $@ ) {
        _send_html( $R->apache, $@, $R );
        die OK . "\n";
    }
    return undef;
}


# Call the various user/group authentication routines

sub _setup_authentication {
    my ( $R ) = @_;
    unless ( $R->auth ) {
        my $error_msg = "Authentication cannot be setup! Please ensure 'auth' is setup in your " .
                        "server configuration under 'system_alias'";
        _send_html( $R->apache, $error_msg, $R );
        die OK . "\n";
    }
    eval {
        $R->auth->user;
        $R->auth->group;
    };
    if ( $@ ) {
        _send_html( $R->apache, $@, $R );
        die OK . "\n";
    }
    return undef;
}


# Create the theme used; note that logged-in users can choose 
# their own, but anonymous users have to stick with 'main'. Each
# UI handler (conductor) can decide what to do with the object, but
# for now we won't try to fetch all the properties or anything

sub _setup_theme {
    my ( $R ) = @_;
    my $C = $R->CONFIG;
    $R->{theme} = ( $R->{auth}->{user} and $R->{auth}->{user}->{theme_id} )
                    ? eval { $R->{auth}->{user}->theme }
                    : eval { $R->theme->fetch( $C->{default_objects}->{theme} ) };
    if ( $@ ) {
        my $ei = SPOPS::Error->get;
        OpenInteract::Error->set( $ei );
        $R->throw({ code => 404 });
        $R->scrib( 0, "Error! Cannot retrieve theme! ( Class: ", $R->theme, ")",
                      "with error ($@ / $ei->{system_msg}) Help!" );
        my $error_msg = <<THEMERR;
Fundamental part of OpenInteract (themes) not functioning; please contact the
system administrator (<a href="mailto:$C->{admin_email}">$C->{admin_email}</a>).
THEMERR
        _send_html( $R->apache, $error_msg, $R );
        die OK . "\n";
    }
    return undef;
}


# Runs the content handler -- this should either return the full page
# ready for display or put the information into $R necessary to send a
# static (non-HTML) file

sub _run_content_handler {
    my ( $R ) = @_;
    my ( $ui_class, $ui_method ) = ( $R->{ui}->{class}, $R->{ui}->{method} );
    $R->DEBUG && $R->scrib( 1, "Trying the conductor: <<$ui_class/$ui_method>>" );
    return $ui_class->$ui_method();
}


# Send a static (non-html/text) file to the user; note that the
# content type should already have been set -- normally this is done
# automatically by Apache, particularly if the URL ends with a known
# filetype

sub _send_static_file {
    my ( $R ) = @_;
    my $static_file = $R->{page}->{send_file};
    my $fh = Apache->gensym;
    eval { open( $fh, $static_file ) || die $!; };
    if ( $@ ) {
        $R->scrib( 0, "Cannot open static file from filesystem ($static_file): $@" );
        return NOT_FOUND;
    }
    $R->apache->send_http_header( $R->{page}->{content_type} );
    $R->apache->send_fd( $fh );
    close( $fh );
}


# Send plain html (or text) to the browser

sub _send_html {
    my ( $apache, $content, $R ) = @_;
    $R ||= {};
    my $content_type = $R->{page}->{content_type} || $apache->content_type || 'text/html';
    $content_type = ( $content_type eq 'httpd/unix-directory' ) ? 'text/html' : $content_type;
    $apache->send_http_header( $content_type );
    $apache->print( $content );
}


# Do any necessary cleanup -- logging, remove stash entries, etc.

sub _cleanup {
    my ( $R ) = @_;
    $R->DEBUG && $R->scrib( 2, "\n\nErrors: ", Dumper( $R->error_object->report ), "\n\n" );
    $R->error->clear;
    $R->error_object->clear_listing;
    $R->DEBUG && $R->scrib( 1, "Request done at", scalar localtime , "from $R->{remote_host}\n$SEP\n" );

    # Ask the Request object to cleanup all its objects and finish

    $R->finish_request;
    return undef;
}

1;

__END__

=pod

=head1 NAME

OpenInteract - mod_perl handler to process all OpenInteract requests

=head1 DESCRIPTION

This documentation is for the OpenInteract Apache content handler. For
general information about OpenInteract, see L<OpenInteract::Intro>.

This content handler creates the L<OpenInteract::Request> object and
farms requests out to all the relevant handlers -- cookies, session,
authentication, themes, etc.

We walk through a number of steps here. They are probably self-evident
by checking out the code, but just to be on the safe side:

=over 4

=item *

Retrieve the StashClass from the Apache config

=item *

Grab the Config object from the StashClass

=item *

Create/retrieve the request object.

=item *

Create the C<Apache::Request> object

=item *

Create the config (if it is not already around)

=item *

Create the cache object if we are supposed to use it

=item *

Parse the URL and decide which conductor (UI) should take care of the
request

=item *

Get the cookies

=item *

Recreate the session if possible

=item *

Authenticate the user

=item *

Get the groups the user belongs to

=item *

Create the theme

=item *

Retrieve the page from the conductor

=item *

Save the session

=item *

Bake the cookies (put them into outgoing headers)

=item *

Send the http header(s)

=item *

Send the content

=item *

Cleanup

=back

=head1 NOTES

If you get an error with something like:

Can't locate object method "cookies" via package "OpenInteract::Request"
at /usr/lib/perl5/site_perl/5.6.1/OpenInteract.pm line 226.

This likely means that the C<OpenInteract::Request::setup_aliases()>
wasn't run. Typically this is run in the PerlChildInitHandler when an
Apache child is first created. This points to a larger problem if it
is not run. (What exactly is that larger problem? Still working on
that...)

=head1 TO DO

Nothing known

=head1 BUGS

None known

=head1 COPYRIGHT

Copyright (c) 2001 intes.net, inc.. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHORS

Chris Winters <chris@cwinters.com>

=cut