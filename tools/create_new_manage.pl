#!/usr/bin/perl

# $Id: create_new_manage.pl,v 1.5 2003/07/03 03:54:58 lachoy Exp $

# create_new_manage.pl
#   Create skeleton module for new management task.

# Usage: create_new_manage.pl type class [ ... class class ]
#        create_new_manage.pl package UnitTest
#        create_new_manage.pl website ExportTheme

# - Creates directory in cwd: OpenInteract/Manage/$Type
# - dies if directory create fails
# - Outputs status to STDERR

use strict;
use File::Path qw( mkpath );

{
    my ( $type, @classes ) = @ARGV;
    unless ( $type =~ /^(package|website)$/ and scalar @classes ) {
        die usage();
    }

    my $uc_type = ucfirst $type;
    my $dest_dir = "OpenInteract2/Manage/$uc_type";
    eval { mkpath( $dest_dir ) };
    die "Could not create [$dest_dir] in cwd: $@" if ( $@ );

    foreach my $class ( @classes ) {
        my $filename = "$dest_dir/$class.pm";
        open( NEW, "> $filename" ) || die $!;
        my $text = sample();
        $text =~ s/%%TYPE%%/$uc_type/g;
        $text =~ s/%%CLASS%%/$class/g;
        print NEW $text;
        close( NEW );
        warn "Created new package [$filename] ok\n";
    }
}

sub usage {
    return <<USAGE;
create_new_manage.pl - Create new management task in current directory

Usage: $0 type task-class task-class task-class ...
Example: $0 package Install Upgrade
  Creates:  OpenInteract2/Manage/Package/Install.pm
  Creates:  OpenInteract2/Manage/Package/Upgrade.pm
Example: $0 website Create ListObjects
  Creates:  OpenInteract2/Manage/Website/Create.pm
  Creates:  OpenInteract2/Manage/Website/ListObjects.pm
USAGE
}

sub sample {
    return <<'SAMPLE';
package OpenInteract2::Manage::%%TYPE%%::%%CLASS%%;

# $Id: create_new_manage.pl,v 1.5 2003/07/03 03:54:58 lachoy Exp $

use strict;
use base qw( OpenInteract2::Manage::%%TYPE%% );
use OpenInteract2::Context qw( CTX DEBUG LOG );
use OpenInteract2::Exception qw( oi_error );

$OpenInteract2::Manage::%%TYPE%%::%%CLASS%%::VERSION = sprintf("%d.%02d", q$Revision: 1.5 $ =~ /(\d+)\.(\d+)/);

sub brief_description {
    return "Describe your task in a sentence or two.";
}

sub get_param_description {
    my ( $self, $param_name ) = @_;
    if ( $param_name eq 'myparam' ) {
        return "This is the description for 'myparam.' Adding a " .
               "description for your parameters makes for a much " .
               "more usable task. Your users will love you!";
    }
    return $self->SUPER::get_param_description( $param_name );
}

sub list_param_require {
    return [];
}

sub list_param_validate {
    return [];
}

sub setup_task {
    my ( $self ) = @_;
}


sub run_task {
    my ( $self ) = @_;
}


sub tear_down_task {
    my ( $self ) = @_;
}

1;

__END__

=head1 NAME

OpenInteract2::Manage::%%TYPE%%::%%CLASS%% - Managment task

=head1 SYNOPSIS

 #!/usr/bin/perl

 use strict;
 use OpenInteract2::Manage;

 my $website_dir = '/home/httpd/mysite';
 my $task = OpenInteract2::Manage->new(
                      'COMMAND', \%PARAMS );
 my @status = $task->execute;
 foreach my $s ( @status ) {
     my $ok_label      = ( $s->{is_ok} eq 'yes' )
                           ? 'OK' : 'NOT OK';
     my $default_label = ( $s->{is_default} eq 'yes' )
                           ? ' (default) ' : '';
     print "Status OK?  $s->{is_ok}\n",
           "$s->{message}\n";
 }

=head1 REQUIRED OPTIONS

=over 4

=item B<option>=value

=back

=head1 STATUS INFORMATION

Each status hashref includes:

=over 4

=item B<is_ok>

Set to 'yes' if the task succeeded, 'no' if not.

=item B<message>

Success/failure message.

=back

=head1 BUGS

None known.

=head1 TO DO

Nothing known.

=head1 SEE ALSO

=head1 COPYRIGHT

Copyright (C) 2003 A. U. Thor. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHORS

A. U. Thor, E<lt>a.u.thor@a.galaxy.far.far.awayE<gt>

SAMPLE
}
