package OpenInteract2::Brick::SystemDoc;

use strict;
use base qw( OpenInteract2::Brick );
use OpenInteract2::Exception;

my %INLINED_SUBS = (
    'system_doc-2.10.zip' => 'SYSTEM_DOC210ZIP',
);

sub get_name {
    return 'system_doc';
}

sub get_resources {
    return (
        'system_doc-2.10.zip' => [ 'pkg system_doc-2.10.zip', 'no' ],
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

OpenInteract2::Brick::SystemDoc - Base-64 encoded OI2 package 'system_doc-2.10.zip' shipped with distribution

=head1 SYNOPSIS

  oi2_manage create_website --website_dir=/path/to/site

=head1 DESCRIPTION

Are you sure you even need to be reading this? If you are just looking
to install a package just follow the instructions from the SYNOPSIS.

Still here? This class holds the Base64-encoded versions of package
file "system_doc-2.10.zip" shipped with OpenInteract2. Once you decode them you
should store them as a ZIP file and then read them in with
Archive::Zip or some other utility.

A typical means to do this is:

 my $brick = OpenInteract2::Brick->new( 'system_doc' );

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


=item B<system_doc-2.10.zip>


=back

=head1 COPYRIGHT

Copyright (c) 2005 Chris Winters. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHORS


Chris Winters E<lt>chris@cwinters.comE<gt>


=cut


sub SYSTEM_DOC210ZIP {
    return <<'SOMELONGSTRING';
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
H8RrLTlHXbHVTORenI0+Dk4RR79Ll5vVmq5pn+iidI+kLUxCjuMI6qwAGK80GpOLGg1q0NX92RhR
iRX9blaCnnAgrjiPmIRa6YS4W0fw77rq2JGAftfN3NHKESlQ/FI2pfs8H08IEd0tK2UATavOHhjP
iEf0R3OfR7O59qmruo+1etBRSyTBqeJNbV08rCP2IWUPw5mgjV7gdHPwFh/EO4pXhFqdBvU2vMfT
ISSnQz5NAeOuh9EsHEMNAO16zRyXWB3kMUydX7SqQ57B0JzM1fuqhFYzhexYVdGjo4QxGj6JntEA
Tgckjd68LTjmHGpmArX9FO4YIWj566LAcRmzguIlEHDChIUJxixEQ2nJxau4rKXoiOM6uwj/CLy8
oUcn49k3wdkfDD9fnX/4OMI4597Kt2fzEKqTGr1RPmrQa2Xoz307gH/a5LOgCSdoeEEWYFXBfu9e
JM2ILoUde+yb/oouh6c+wxjn03Bp+qwDKx4J2D5DxKFvj6OQgR0S4lYcYXia0uxQvKeLkzkgx6JI
3ArMIPaVHVK5TsGf/ANT9IpSNAsRzrpOqE9o6HiylLAnfHHWnYW69m9QSwMEFAAAAAgAL7VKMJQy
hOJCAAAASAAAAB0AAABzeXN0ZW1fZG9jLTIuMTAvTUFOSUZFU1QuU0tJUItJcg4LjkniqlPhisvP
NIrPTcxLTE/Vy8lPV+GK0cvPSQFRSYnZECo5u7QAqNDX0c/TzTU4JEaPK64kt4ArLp4LAFBLAwQU
AAAACADuYcguLQ6tqHEAAACNAAAAHwAAAHN5c3RlbV9kb2MtMi4xMC9jb25mL2FjdGlvbi5pbmmL
Lq4sLknNTclPjuVKzkksLlaAAlsF/4LUPM+8ktSixOQSIysrx+SSzPw8K6tgsAaX/GSuzOL44tTk
0qJUiPrK1GKuksTi7PiU1LTE0pwSoFBOZnEJF1c03A4FsPrMkspYLhdXN8dQnxCYZUGuji5cAFBL
AwQUAAAACACTs8cwll8s6NMAAAB1AQAAKQAAAHN5c3RlbV9kb2MtMi4xMC9kYXRhL2luc3RhbGxf
c2VjdXJpdHkuZGF0lY49SwQxEIb7/RVvIaRZOBELOTlBuMbKwnJZQkxmj0g2E5NZj0X87+7XoWBl
iiEzzPO8c1XIDtnLiAMaVAA+4fvEWbSMibC+wwMUv76RFVVXy6QkTkXbYEr5tfOcKD5FoWys3Oz3
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
U8Kl1Lytg2471p1103wxjsWs0m3f6U7DhwbWMrBqy71HePPoM4JdLhyA//V3EHvmuvTvfKge8zpQ
axjS9PBmYjqp4FdfXdBDCcWNAXdDrPiVJZtIOYyp2XREw2gKYtaGagfFGntBs7GbQhs5UvDt2w/v
QLaXaSKtktow8c2Azgc8ZTvBzux1twtpdo0F+xpMefT3m1Zh9Gww/Pmq9+79DW4sXeSWxOuTBv+W
dtTkH9TobAbSoo/mGpVPp8DJLFNMTjJ7lMw35n0xjsYZ3lBMxmbII5VO9QqXc0x5ujRXisyL+Pc3
3InTdmELJQp0o2nuYcBIQVMoCvgTXM4VF8tQZjE28KvhBpHTD+hcVwBzK0QyGTbhoTeTlQsb7dlk
mfcfUEsBAhQDFAAAAAgAsaRcMtvjRdnTAAAAPwEAABsAAAAAAAAAAQAAACSBAAAAAHN5c3RlbV9k
b2MtMi4xMC9wYWNrYWdlLmluaVBLAQIUAxQAAAAIACKyXDJQ7Ulx/wAAAHcDAAAtAAAAAAAAAAEA
AAAkgQwBAABzeXN0ZW1fZG9jLTIuMTAvdGVtcGxhdGUvc3lzdGVtX2RvY19tZW51LnRtcGxQSwEC
FAMUAAAACAA3uXEyChnTncMJAABwHwAAMQAAAAAAAAABAAAAJIFWAgAAc3lzdGVtX2RvYy0yLjEw
L09wZW5JbnRlcmFjdDIvQWN0aW9uL1N5c3RlbURvYy5wbVBLAQIUAxQAAAAIAC+1SjCUMoTiQgAA
AEgAAAAdAAAAAAAAAAEAAAAkgWgMAABzeXN0ZW1fZG9jLTIuMTAvTUFOSUZFU1QuU0tJUFBLAQIU
AxQAAAAIAO5hyC4tDq2ocQAAAI0AAAAfAAAAAAAAAAEAAAAkgeUMAABzeXN0ZW1fZG9jLTIuMTAv
Y29uZi9hY3Rpb24uaW5pUEsBAhQDFAAAAAgAk7PHMJZfLOjTAAAAdQEAACkAAAAAAAAAAQAAACSB
kw0AAHN5c3RlbV9kb2MtMi4xMC9kYXRhL2luc3RhbGxfc2VjdXJpdHkuZGF0UEsBAhQDFAAAAAgA
dGyEMUT2qkKZAgAAmgcAAC4AAAAAAAAAAQAAACSBrQ4AAHN5c3RlbV9kb2MtMi4xMC9tc2cvc3lz
dGVtX2RvYy1tZXNzYWdlcy1lbi5tc2dQSwECFAMUAAAACAB6slwyvxMXFCMIAADKEgAAFwAAAAAA
AAABAAAAJIGSEQAAc3lzdGVtX2RvYy0yLjEwL0NoYW5nZXNQSwECFAMUAAAACAByvcgwj5lQOjUC
AAAABQAALAAAAAAAAAABAAAAJIHqGQAAc3lzdGVtX2RvYy0yLjEwL3RlbXBsYXRlL21vZHVsZV9s
aXN0aW5nLnRtcGxQSwECFAMUAAAACAAgo2kywLXBdecCAADzBQAALgAAAAAAAAABAAAAJIFpHAAA
c3lzdGVtX2RvYy0yLjEwL09wZW5JbnRlcmFjdDIvQXBwL1N5c3RlbURvYy5wbVBLAQIUAxQAAAAI
ADe5cTK++HgG5gAAAE4BAAA1AAAAAAAAAAEAAAAkgZwfAABzeXN0ZW1fZG9jLTIuMTAvT3Blbklu
dGVyYWN0Mi9TUUxJbnN0YWxsL1N5c3RlbURvYy5wbVBLAQIUAxQAAAAIAF2lXDIBlKOm2QAAAHwB
AAApAAAAAAAAAAEAAAAkgdUgAABzeXN0ZW1fZG9jLTIuMTAvdGVtcGxhdGUvZG9jX2Rpc3BsYXku
dG1wbFBLAQIUAxQAAAAIAGalXDKJNuzctQAAAEkBAAAYAAAAAAAAAAEAAAAkgfUhAABzeXN0ZW1f
ZG9jLTIuMTAvTUFOSUZFU1RQSwECFAMUAAAACAA3uXEy0VFgaboIAABdFAAAKAAAAAAAAAABAAAA
JIHgIgAAc3lzdGVtX2RvYy0yLjEwL09wZW5JbnRlcmFjdDIvUG9kVmlldy5wbVBLBQYAAAAADgAO
AJ8EAADgKwAAAAA=

SOMELONGSTRING
}
