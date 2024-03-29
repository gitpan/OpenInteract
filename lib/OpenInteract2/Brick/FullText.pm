package OpenInteract2::Brick::FullText;

use strict;
use base qw( OpenInteract2::Brick );
use OpenInteract2::Exception;

my %INLINED_SUBS = (
    'full_text-2.61.zip' => 'FULL_TEXT261ZIP',
);

sub get_name {
    return 'full_text';
}

sub get_resources {
    return (
        'full_text-2.61.zip' => [ 'pkg full_text-2.61.zip', 'no' ],
    );
}

sub load {
    my ( $self, $resource_name ) = @_;
    my $inline_sub_name = $INLINED_SUBS{ $resource_name };
    unless ( $inline_sub_name ) {
        OpenInteract2::Exception->throw(
            "Resource name '$resource_name' not found ",
            "in ", ref( $self ), "; cannot load content." );
    }
    return $self->$inline_sub_name();
}

OpenInteract2::Brick->register_factory_type( get_name() => __PACKAGE__ );

=pod

=head1 NAME

OpenInteract2::Brick::FullText - Base-64 encoded OI2 package 'full_text-2.61.zip' shipped with distribution

=head1 SYNOPSIS

  oi2_manage create_website --website_dir=/path/to/site

=head1 DESCRIPTION

Are you sure you even need to be reading this? If you are just looking
to install a package just follow the instructions from the SYNOPSIS.

Still here? This class holds the Base64-encoded versions of package
file "full_text-2.61.zip" shipped with OpenInteract2. Once you decode them you
should store them as a ZIP file and then read them in with
Archive::Zip or some other utility.

A typical means to do this is:

 my $brick = OpenInteract2::Brick->new( 'full_text' );

 # there's only one resource in this brick...
 my ( $pkg_name ) = $brick->list_resources;
 my $pkg_info = $brick->load_resource( $pkg_name );
 my $pkg_file = OpenInteract2::Util->decode_base64_and_store(
     \$pkg_info->{content}
 );

 # $pkg_file now references a file on the filesystem that you can
 # manipulate as normal

These resources are associated with OpenInteract2 version 1.99_06.


=head2 Resources

You can grab resources individually using the names below and
C<load_resource()> and C<copy_resources_to()>, or you can copy all the
resources at once using C<copy_all_resources_to()> -- see
L<OpenInteract2::Brick> for details.

=over 4


=item B<full_text-2.61.zip>


=back

=head1 COPYRIGHT

Copyright (c) 2005 Chris Winters. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHORS


Chris Winters E<lt>chris@cwinters.comE<gt>


=cut


sub FULL_TEXT261ZIP {
    return <<'SOMELONGSTRING';
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
uPRRm1iRvuUZnof64xRNooWfWJdPWImPsFbr8blm12qYOC9IiryUaDHyRGkm43h0cRbHjB1nyNMu
XAz/GDH2ygYQLhBCPrDFZnTdxDqSLcfy5XLY4s6+XUwuZ+MZjfXg5YL56Un2Z77r7z3GJlNoVMat
Gw4LbjIwGUrZ7HtgvC8LbWEy/jr6OBvPRy+wXsv+Hfy63LPR7HQ6vpyPJxeMhYlD8ypZoaAuKg28
LKVIuFf5+Xa0GU1gxu+QPV+P4ahRLEHmEcwzQf8MlFxbWROzFHPaQlYHvGIJWbEi1dlPVHdLJHiB
W7TP1st6oxw4F7ZO4Up0btxQNpqKnJ61pKASiWly61Cetj0dBoKh+hQtLi5lTVwII8DzBc3FneDe
n/oYbUX8eHVO/b5wvGu077b2+QTOJu6B9a+NW1Ws1FPUbDSC4ZcZOXw5emPn/fuGfbAFOZ1cfpuO
zz/PGTstylqLm8xCI2m691+XWFk0kUI6q0Il9DIZSgnexzixUN9hSgX5rkix0FzXjv1SI2laLO2K
azx0bYeEK4pIhXvFLSqaVWGdym3f51Qsa0aGikTUoSE83/SehKc3gaQAg3L5RH94Nf88mZJup5mm
nF9drdrA6EjaQeJMJ8kq2CJq2+johlj/B1BLAwQUAAAACACLpLswQebrDnsAAACtAAAAKQAAAGZ1
bGxfdGV4dC0yLjYxL3N0cnVjdC9mdWxsX3RleHRfaW5kZXguc3Fscw5ydQxxVQhxdPJxVUgrzcmJ
L0mtKInPzEtJrVDQ4FJIA7JTFGBAVdXTzznI1dfVLyQ+JDLAVVVVIS+/RCEPqE+HS6EktSgXrlSh
LLEoOSOxSMPYQBNZUX5ycmkRXFFmXgmyZEFRZm5iUaVCdmolUFIDYrsOxGBNLk0AUEsDBBQAAAAI
ADSluzD1BbtcIQAAAB8AAAA4AAAAZnVsbF90ZXh0LTIuNjEvc3RydWN0L2Z1bGxfdGV4dF9pbmRl
eF9jbGFzc19zZXF1ZW5jZS5zcWxzDnJ1DHFVCHYNDHX1c3ZVyM+MTyvNySlJrSiJL04tBABQSwME
FAAAAAgAN7lxMgBC2aRRCAAAxRcAADEAAABmdWxsX3RleHQtMi42MS9PcGVuSW50ZXJhY3QyL0Fj
dGlvbi9TaXRlU2VhcmNoLnBtnVjrU+PIEf+uv6LDek8m+AF7m1Qi1j44YO9ctQsUcEm2Qko1SGN7
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
KROHosENPk9xhwYHO30dwkXlQTAaSnX1jflRvw8XH0fo4ePbF7bp7y+c99ZGLoc3X24HH34dIwXV
fKndMGwmR/Sl+8R5NZHkOOGETKIILrBMTsYgCNhYHngaVfnkYqIZkhYfM80JwcwumOanrsBULc1T
QV+1cWWj/Yuo2EH2FioV2RKph0tsyv3m7MDBsLEizMANXT1hDc+zTfoXn8a/Dm+xnV7ONPr87BAy
0H+b215CR+fJwp9Rc+i/nWLW/wdQSwMEFAAAAAgAkKJcMs3zobz0AAAAWwIAABcAAABmdWxsX3Rl
eHQtMi42MS9NQU5JRkVTVI2Qy07DMBBF9/mXxhJ/UB6VLCgPpXvLdaapizOeeiZS+HtM2qZAKLCz
5xxfX/tma7EBLpbzR724q1bjoqzu9XNB1r3aBkqPvnARN8o68RHPe6ZIbDZdCEagF9NaIo/NILTc
qJHMWmDOUTwDLDMpnghQo0DKkVdqkb1V1pbH89ReEDTW0ENSt9d6Ks2HdqryAhXY5LY/KERj1pRW
Lw8aWWwIXyR2yZMoW9cmrnfghI1E4z+qlBROmIcrP40ldU7OX3AkvL+ETMwtAvxmuGCZ/xT+G2QY
9h2gO5gCLQUrcHpIAu6CcCl5PIHr2H8D4vHNHOhA3gFQSwECFAMUAAAACABFulsyDfpH1wcDAACV
BwAAKwAAAAAAAAABAAAAJIEAAAAAZnVsbF90ZXh0LTIuNjEvdGVtcGxhdGUvc2VhcmNoX3Jlc3Vs
dHMudG1wbFBLAQIUAxQAAAAIAMWkuzCIsRtRZwAAAJ8AAAAwAAAAAAAAAAEAAAAkgVADAABmdWxs
X3RleHQtMi42MS9zdHJ1Y3QvZnVsbF90ZXh0X2luZGV4X29yYWNsZS5zcWxQSwECFAMUAAAACAA3
uXEyIePJYUABAAAwAgAALwAAAAAAAAABAAAAJIEFBAAAZnVsbF90ZXh0LTIuNjEvT3BlbkludGVy
YWN0Mi9GdWxsVGV4dE1hcHBpbmcucG1QSwECFAMUAAAACABws8Qwcovybr4AAACoAQAALwAAAAAA
AAABAAAAJIGSBQAAZnVsbF90ZXh0LTIuNjEvY29uZi9zcG9wc19mdWxsX3RleHRfbWFwcGluZy5p
bmlQSwECFAMUAAAACAActUowlDKE4kIAAABIAAAAHAAAAAAAAAABAAAAJIGdBgAAZnVsbF90ZXh0
LTIuNjEvTUFOSUZFU1QuU0tJUFBLAQIUAxQAAAAIAFykuzBeDCD8hwAAAMYAAAAvAAAAAAAAAAEA
AAAkgRkHAABmdWxsX3RleHQtMi42MS9zdHJ1Y3QvZnVsbF90ZXh0X2luZGV4X2NsYXNzLnNxbFBL
AQIUAxQAAAAIAJWkXDIpkdyzcQsAAPYaAAAWAAAAAAAAAAEAAAAkge0HAABmdWxsX3RleHQtMi42
MS9DaGFuZ2VzUEsBAhQDFAAAAAgAHaNpMhrGaoj+BgAAWw8AACwAAAAAAAAAAQAAACSBkhMAAGZ1
bGxfdGV4dC0yLjYxL09wZW5JbnRlcmFjdDIvQXBwL0Z1bGxUZXh0LnBtUEsBAhQDFAAAAAgA6LTH
MHVtzQPfAAAA3AEAACwAAAAAAAAAAQAAACSB2hoAAGZ1bGxfdGV4dC0yLjYxL21zZy9mdWxsX3Rl
eHQtbWVzc2FnZXMtZW4ubXNnUEsBAhQDFAAAAAgAN7lxMmGQMlQoDgAAFSkAADMAAAAAAAAAAQAA
ACSBAxwAAGZ1bGxfdGV4dC0yLjYxL09wZW5JbnRlcmFjdDIvRnVsbFRleHRJbmRleGVyL0RCSS5w
bVBLAQIUAxQAAAAIAJekXDKrvcgSCwEAALEBAAAaAAAAAAAAAAEAAAAkgXwqAABmdWxsX3RleHQt
Mi42MS9wYWNrYWdlLmluaVBLAQIUAxQAAAAIAKUDxjCKZv+qHwIAAOkEAAAzAAAAAAAAAAEAAAAk
gb8rAABmdWxsX3RleHQtMi42MS9PcGVuSW50ZXJhY3QyL1NRTEluc3RhbGwvRnVsbFRleHQucG1Q
SwECFAMUAAAACACVvcYwCVGlfzEBAAC/AgAAKAAAAAAAAAABAAAAJIEvLgAAZnVsbF90ZXh0LTIu
NjEvdGVtcGxhdGUvdGlueV9zZWFyY2gudG1wbFBLAQIUAxQAAAAIAIJIey4LBjDp2AMAAAMIAAAl
AAAAAAAAAAEAAAAkgaYvAABmdWxsX3RleHQtMi42MS9zY3JpcHQvc2VhcmNoX2luZGV4LnBsUEsB
AhQDFAAAAAgAi6S7MEHm6w57AAAArQAAACkAAAAAAAAAAQAAACSBwTMAAGZ1bGxfdGV4dC0yLjYx
L3N0cnVjdC9mdWxsX3RleHRfaW5kZXguc3FsUEsBAhQDFAAAAAgANKW7MPUFu1whAAAAHwAAADgA
AAAAAAAAAQAAACSBgzQAAGZ1bGxfdGV4dC0yLjYxL3N0cnVjdC9mdWxsX3RleHRfaW5kZXhfY2xh
c3Nfc2VxdWVuY2Uuc3FsUEsBAhQDFAAAAAgAN7lxMgBC2aRRCAAAxRcAADEAAAAAAAAAAQAAACSB
+jQAAGZ1bGxfdGV4dC0yLjYxL09wZW5JbnRlcmFjdDIvQWN0aW9uL1NpdGVTZWFyY2gucG1QSwEC
FAMUAAAACAB0pLswjiDh3X0AAADHAAAANgAAAAAAAAABAAAAJIGaPQAAZnVsbF90ZXh0LTIuNjEv
c3RydWN0L2Z1bGxfdGV4dF9pbmRleF9jbGFzc19vcmFjbGUuc3FsUEsBAhQDFAAAAAgAirTEMPnZ
+1zdAAAA/AEAAB4AAAAAAAAAAQAAACSBaz4AAGZ1bGxfdGV4dC0yLjYxL2NvbmYvYWN0aW9uLmlu
aVBLAQIUAxQAAAAIAE2/xTCGkFMHvAAAAE4BAAAnAAAAAAAAAAEAAAAkgYQ/AABmdWxsX3RleHQt
Mi42MS90ZW1wbGF0ZS9zZWFyY2hfYm94LnRtcGxQSwECFAMUAAAACACCSHsuBJKC+C8HAACAEAAA
LQAAAAAAAAABAAAAJIGFQAAAZnVsbF90ZXh0LTIuNjEvc2NyaXB0L2FkZF9vYmplY3RzX3RvX2lu
ZGV4LnBsUEsBAhQDFAAAAAgAkKJcMs3zobz0AAAAWwIAABcAAAAAAAAAAQAAACSB/0cAAGZ1bGxf
dGV4dC0yLjYxL01BTklGRVNUUEsFBgAAAAAWABYAhAcAAChJAAAAAA==

SOMELONGSTRING
}

