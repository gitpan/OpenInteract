package OpenInteract2::Session;

# $Id: Session.pm,v 1.10 2003/06/11 02:43:31 lachoy Exp $

use strict;
use Data::Dumper             qw( Dumper );
use OpenInteract2::Constants qw( :log SESSION_COOKIE );
use OpenInteract2::Context   qw( CTX DEBUG LOG DEPLOY_URL );
use OpenInteract2::Exception qw( oi_error );

$OpenInteract2::Session::VERSION = sprintf("%d.%02d", q$Revision: 1.10 $ =~ /(\d+)\.(\d+)/);

sub create {
    my ( $class, $session_id ) = @_;
    my $session_config = CTX->server_config->{session_info};
    my @validation_errors = $class->_validate_config( $session_config );
    if ( scalar @validation_errors ) {
        LOG( LERROR, join( "\n", @validation_errors ) );
        oi_error "Errors in session configuration: ",
                 join( "\n", @validation_errors );
    }

    my $session = eval {
        $class->_create_session( $session_config, $session_id )
    };
    if ( $@ ) {
        LOG( LERROR, "Error fetching session with ID [$session_id]: $@" );
        OpenInteract2::Cookie->expire( SESSION_COOKIE );
        oi_error $@;
    }
    DEBUG && LOG( LDEBUG, "Retrieved session w/keys ",
                          join( ', ', keys %{ $session } ) );

    if ( $session_id ) {

        # Check to see if we should expire the session

        unless ( $class->is_session_valid( $session ) ) {
            DEBUG && LOG( LINFO, "Session is expired; clearing out." );
            eval { tied( %{ $session } )->delete() };
            if ( $@ ) {
                LOG( LWARN, "Caught error trying to remove expired session: $@\n",
                            "Continuing without problem since this just means",
                            "you'll have a stale session in your datastore" );
            }
            return {};
        }
    }
    else {
        $session->{is_new}++;
    }
    return $session;
}


sub is_session_valid {
    my ( $class, $session ) = @_;
    return 1 unless ( $session->{timestamp} );
    my $expires_in = CTX->server_config->{session_info}{expires_in};
    return 1 unless ( $expires_in > 0 );
    my $last_refresh = ( time - $session->{timestamp} ) / 60;
    return 1 unless ( $last_refresh > $expires_in );
    DEBUG && LOG( LINFO, "Session has expired. Last refresh was ",
                         "[", sprintf( '%5.2f', $last_refresh ) , "] minutes ago at ",
                         "[", scalar localtime( $session->{timestamp} ) , "]",
                         "and threshold is [", $expires_in, "] minutes" );
    return undef;
}


sub save {
    my ( $class, $session ) = @_;

    if ( tied %{ $session } ) {
        my %useful_session_keys = map { $_ => 1 } keys %{ $session };
        delete $useful_session_keys{_session_id};
        delete $useful_session_keys{is_new};
        if ( ref $session->{_oi_cache} and
                 scalar keys %{ $session->{_oi_cache} } == 0 ) {
            delete $useful_session_keys{_oi_cache};
        }
        if ( scalar keys %useful_session_keys > 0 ) {
            my $is_new = $session->{is_new};
            delete $session->{is_new};
            $class->_save_session( $session, $is_new );
        }
        else {
            DEBUG && LOG( LDEBUG, "Tied session found, not saving since ",
                                  "it doesn't have useful info" );
        }
    }
    elsif ( ref $session eq 'HASH' ) {
        if ( scalar keys %{ $session } ) {
            DEBUG && LOG( LINFO, "Create new session with data from hashref" );
            my $new_session = $class->_create_session;
            if ( $new_session ) {
                foreach my $key ( keys %{ $session } ) {
                    $new_session->{ $key } = $session->{ $key };
                }
                $class->_save_session( $new_session, 1 );
            }
            else {
                LOG( LERROR, "No value returned from _create_session; ",
                             "this shouldn't happen..." );
            }
        }
        else {
            DEBUG && LOG( LINFO, "No data yet set to session hashref, ",
                                 "skip save" );
            return 1;
        }
    }
    else {
        LOG( LWARN, "No session reference returned from request. ",
                    "This should not happen...." );
    }
    return 1;
}



sub _save_session {
    my ( $class, $session, $is_new ) = @_;
    $session->{timestamp} = time;
    DEBUG && LOG( LDEBUG, "Saving tied session [New? $is_new] with keys ",
                          join( ", ", keys %{ $session } ) );
    my $session_id = $session->{_session_id};
    untie %{ $session };
    if ( $is_new ) {
        DEBUG && LOG( LINFO, "Sending cookie for new session" );
        my $expiration = $class->_get_expiration( $session );
        OpenInteract2::Cookie->create(
                              { name    => SESSION_COOKIE,
                                value   => $session_id,
                                path    => DEPLOY_URL,
                                expires => $expiration,
                                HEADER  => 'yes' });
    }
}

# If the session key 'expiration' is defined then use that, even if
# the value in the session is blank or undef. This allows you to set
# sessions that expire when the browser is closed when a user requests
# (see OpenInteract2::Auth).

sub _get_expiration {
    my ( $class, $session ) = @_;
    my ( $expiration );
    if ( exists $session->{expiration} ) {
        $expiration = $session->{expiration};
        DEBUG && LOG( LINFO, "Expiration for new session manually ",
                             "set to [$expiration]" );
        delete $session->{expiration};
    }
    else {
        $expiration = CTX->server_config->{session_info}{expiration};
        DEBUG && LOG( LINFO, "Expiration for new session set to default ",
                             "from config [$expiration]" );
    }
    return $expiration;
}

########################################
# OVERRIDE

sub _create_session  { return undef }
sub _validate_config { return () }

1;

__END__

=head1 NAME

OpenInteract2::Session - Implement session handling in the framework

=head1 SYNOPSIS

 # Creating a session is done in OpenInteract2::Request
 
 use OpenInteract2::Constants qw( SESSION_COOKIE );
 ...
 
 my $session_id = $self->cookie( SESSION_COOKIE );
 my $session_class = CTX->server_config->{session_info}{class};
 my $session = $session_class->create( $session_id );
 $request->session( $session );
 
 # Access the data the session from any handler
 
 my $session = CTX->request->session;
 $session->{my_stateful_data} = "oogle boogle";
 $session->{favorite_colors}{red} += 5;
 
 # And from any template you can use the OI template plugin (see
 # OpenInteract2::ContentGenerator::TT2Plugin)
 
 <p>The weight of your favorite colors are:
 [% FOREACH color = keys OI.session.favorite_colors %]
   * [% color %] -- [% OI.session.favorite_colors.color %]
 [% END %]
 
 # Saving a session is done in OpenInteract2::Response
 
 OpenInteract2::Session->save( CTX->request->session );

=head1 DESCRIPTION

Sessions are a fundamental part of OpenInteract, and therefore session
handling is fairly transparent. We rely on
L<Apache::Session|Apache::Session> to do the heavy-lifting for us.

This handler has two public methods: C<create()> and C<save()>. Guess
in which order they are meant to be called?

This class also requires you to implement a subclass that overrides
the _create_session method with one that returns a valid
L<Apache::Session|Apache::Session> tied hashref. OpenInteract provides
L<OpenInteract2::Session::DBI|OpenInteract2::Session::DBI> for DBI
databases,
L<OpenInteract2::Session::SQLite|OpenInteract2::Session::SQLite> for
SQLite databases, and ,
L<OpenInteract2::Session::File|OpenInteract2::Session::File> using the
filesystem. Implementations using other media are left as an exercise
for the reader. (More below.)

You can create sessions that will expire if not used in a specified
amount of time by setting the C<session_info.expires_in> server
configuration key. See the description below in L<CONFIGURATION> for
more information.

=head1 METHODS

B<create( [ $session_id ] )>

Get the session_id and fetch a session for this ID. If an ID is
unsupplied the implementation should create an empty but still active
session for us.

If no session ID is supplied we set the 'is_new' key in the session
supplied by the implemntation so that C<save()> knows to send a
cookie.

Returns: tied hashref if session implementation ran correctly, normal
hashref if not.

B<save()>

Persist (create or update) the session for later. If the 'is_new' key
was set in the session by the C<create()> method we also use
L<OpenInteract2::Cookie|OpenInteract2::Cookie> to create a new cookie
and put it in the response. The expiration for the generated cookie is
pulled from the session itself (using the key 'expiration') or the
value set in the server configuration key 'session_info.expiration'.

If either is set the method will remove the 'is_new' and 'expiration'
keys from the session.

This method will not serialize the session if it is empty.

=head1 CONFIGURATION

The following configuration keys are used:

=over 4

=item *

B<session_info.class> (REQUIRED)

Specifies the OpenInteract2 session implementation to use. This class
is C<require>d at startup in
L<OpenInteract2::Setup#require_session_classes>.

=item *

B<session_info.impl_class> (optional)

Specifies the L<Apache::Session|Apache::Session> session
implementation to use. While not strictly optional every OpenInteract2
session implementation does demand it. This class is C<require>d at
startup in L<OpenInteract2::Setup#require_session_classes>.

=item *

B<session_info.expiration> (optional)

Used by C<save()> when creating a new session to set the time a
session cookie lasts on the user's browser. See L<CGI|CGI> for an
explanation of the relative date strings accepted.

=item *

B<session_info.expires_in> (optional)

Used to set the time (in number of minutes) greater than which a
session will expire due to inactivity. This is a server-side setting
and is exclusive of the C<expiration> setting above.

=back

=head1 SUBCLASSING

Creating your own session implementation is fairly easy. You must:

=over 4

=item *

Subclass L<OpenInteract2::Session|OpenInteract2::Session>

=item *

Implement C<_validate_config()>

=item *

Implement C<create_session()>

=back

=head2 Validating Your Configuration

Before a session is created you have the opportunity to check your
configuration and ensure all parameters are set as required. The only
argument you get is the server configuration settings under
'session_info'.

To indicate errors return a list of messages and they'll be passed
along to the proper authorities. Here's an example:

 sub _validate_config {
     my ( $class, $session_config ) = @_;
     my @errors = ();
     unless ( $session_config->{params}{doodad} ) {
         push @errors, "Session parameter 'doodad' must be set";
     }
     unless ( $session_config->{impl_class} ) {
         push @errors, "You must define a session implementation in " .
                       "server configuration key 'session_info.impl_class'";
     }
     return @errors;
 }

If errors are returned from C<_validate_config> the session is never
materialized, C<_create_session> is never called.

=head2 Creating a Session

Like C<_validate_config> the C<_create_session> method is given the
session information from the server configuration. It's also given a
session ID for which the implementation should retrieve the data. If
you've written a validation routine you can assume the session
configuration is ok.

The C<_create_session> method should either throw an exception or
return a tied hashref, nothing else. If no session ID is passed in the
method should create a tied hashref without any data besides the
generated session ID.

Here's a generic example:

 sub _create_session {
     my ( $class, $session_config, $session_id ) = @_;
     my $impl_class = $session_config->{impl_class};
     my $session_params = $session_config->{params};
     my %session = ();
     tie %session, $impl_class, $session_id, $session_params;
     return \%session;
 }

It's fine the C<tie> call dies -- the caller will catch the error and
be able to move on properly.

=head1 BUGS

None known.

=head1 SEE ALSO

L<Apache::Session|Apache::Session>

L<OpenInteract2::Constants|OpenInteract2::Constants> where the
C<SESSION_COOKIE> is defined.

L<OpenInteract2::ContentGenerator::TT2Plugin|OpenInteract2::ContentGenerator::TT2Plugin>:
makes the session hash information available to the template

C<OpenInteract2::Cookie> -- routines for parsing, creating, setting
cookie information so we can match up users with session information

=head1 COPYRIGHT

Copyright (c) 2001-2003 Chris Winters. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHORS

Chris Winters E<lt>chris@cwinters.comE<gt>
