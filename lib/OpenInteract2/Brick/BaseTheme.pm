package OpenInteract2::Brick::BaseTheme;

use strict;
use base qw( OpenInteract2::Brick );
use OpenInteract2::Exception;

my %INLINED_SUBS = (
    'base_theme-2.13.zip' => 'BASE_THEME213ZIP',
);

sub get_name {
    return 'base_theme';
}

sub get_resources {
    return (
        'base_theme-2.13.zip' => [ 'pkg base_theme-2.13.zip', 'no' ],
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

OpenInteract2::Brick::BaseTheme - Base-64 encoded OI2 package 'base_theme-2.13.zip' shipped with distribution

=head1 SYNOPSIS

  oi2_manage create_website --website_dir=/path/to/site

=head1 DESCRIPTION

Are you sure you even need to be reading this? If you are just looking
to install a package just follow the instructions from the SYNOPSIS.

Still here? This class holds the Base64-encoded versions of package
file "base_theme-2.13.zip" shipped with OpenInteract2. Once you decode them you
should store them as a ZIP file and then read them in with
Archive::Zip or some other utility.

A typical means to do this is:

 my $brick = OpenInteract2::Brick->new( 'base_theme' );

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


=item B<base_theme-2.13.zip>


=back

=head1 COPYRIGHT

Copyright (c) 2005 Chris Winters. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHORS


Chris Winters E<lt>chris@cwinters.comE<gt>


=cut


sub BASE_THEME213ZIP {
    return <<'SOMELONGSTRING';
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
2E1a4gD09Wyd4Q1b9MymArOE5ojwHfQE49oZBVN92yTx1gWiA6fBhvYyDPWuAmkHxL1Byh6IKyxt
+Was4WlZLxUJrTXXlODUbB0p90VJOxTvg5Uv025BTAOZlbz9RtLwrEfB1XnaHe/6BFOIcQ7+FVmt
iWiVRJ8rMtpTgXVSbd9yHoPGuopoHjpm9zCBHrPfzBXHq/s5FvFUZHkBJ0ZuSQBnDVBqj7VmHESl
rNCKpPqMqSnhlIkPQyvcNltxxIR355BpoKJGPIG/RSuMrCpnXK8f3RAD6jJaLND7ITmGnPXD3vBU
J3z8H1BLAwQUAAAACAAHq3kuCe45kx8AAAAdAAAAKgAAAGJhc2VfdGhlbWUtMi4xMy9zdHJ1Y3Qv
dGhlbWVfZ2VuZXJhdG9yLnNxbHMOcnUMcVVwd/VzDXIM8Q9SyM+ML8lIzU2NL04tBABQSwMEFAAA
AAgAEbVKMJQyhOJCAAAASAAAAB0AAABiYXNlX3RoZW1lLTIuMTMvTUFOSUZFU1QuU0tJUItJcg4L
jkniqlPhisvPNIrPTcxLTE/Vy8lPV+GK0cvPSQFRSYnZECo5u7QAqNDX0c/TzTU4JEaPK64kt4Ar
Lp4LAFBLAwQUAAAACAAHq3kufESlhx4AAAAcAAAAKQAAAGJhc2VfdGhlbWUtMi4xMy9zdHJ1Y3Qv
dGhlbWVfc2VxdWVuY2Uuc3Fscw5ydQxxVQh2DQx19XN2VcjPjC/JSM1NjS9OLQQAUEsDBBQAAAAI
AAereS6Mla5TIwAAACEAAAAuAAAAYmFzZV90aGVtZS0yLjEzL3N0cnVjdC90aGVtZV9wcm9wX3Nl
cXVlbmNlLnNxbHMOcnUMcVUIdg0MdfVzdlXIz4wvyUjNTY0vKMoviC9OLQQAUEsDBBQAAAAIAIEC
UjDLCXqZ0wAAAHYBAAApAAAAYmFzZV90aGVtZS0yLjEzL2RhdGEvaW5zdGFsbF9zZWN1cml0eS5k
YXSNjj9rAzEMxff7FBoKXg5SSoZyJYWOnTo023EY19alDj7LkXUJoeS75/6FBrpUg5Aeer+nh4y2
Zy9n2EANBQD8gO8SsWg5J4S5Nq+g6GuPVlRZTEpOlLK2weR8d/ORML5HQTZWnqrqc2HfTK3H4DSx
Q/411XA4rWAmzRnaO8iWhvSpT+tC0gGPGGAFzYIUNjG3xJ122Jo+yIxUN6eCBi7Tbf3nvTcrnmJV
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
wgAAAAICAAApAAAAYmFzZV90aGVtZS0yLjEzL2NvbmYvc3BvcHNfdGhlbWVfcHJvcC5pbmmVkTEO
wjAMRXefImdgrNQDMMHAVlWWmxhhVJISByRuTxqgtFIHyBa//yI7btKJLzzEMLRge1I131Ob3cB+
6xNHsmlTVYcxu89ZECVjFlE4CvdupYRO1IY7x7H0YAVxuMjWZuoBxYF4G/PVp3fqJSlfb+wto6cL
FykIFg+LmDn4gOKVY1p/OOPb4CjxX3gdjRJ0pIyJup6XRoHUCy0/80eY+3/Ae8pZoHihO7NNONHa
lJWY/ceDZprJnEiRWljb4Xy4J1BLAwQUAAAACAAHq3kuwGri8IcAAAAFAQAALAAAAGJhc2VfdGhl
bWUtMi4xMy9zdHJ1Y3QvdGhlbWVfcHJvcF9vcmFjbGUuc3Fscw5ydQxxVQhxdPJxVSjJSM1NjS8o
yi9Q0OCC8ECc+MwUBYXMvBKFvHwgLs3J0YFKgiVAAE0SbAIclCUWJWckFhlpGBtoIqsqS8wpTcVU
ZWoAUgZRkpJanFyUWVCSmZ+HS0lBUWZuYlGlQnZqJVCJBqqrNYEKSvMyCxH2aMBdrgNxpiaXJhcA
UEsDBBQAAAAIAAereS7cMoJYmAAAAPgAAAAlAAAAYmFzZV90aGVtZS0yLjEzL3N0cnVjdC90aGVt
ZV9wcm9wLnNxbFWOsQqDMBiEd5/iXwIJOBT6BFYyFFopkqWTBA0Yqkn8m0h9+0Ytam+7u4/j8pJn
goPILjcOvlW9qhxaBzRZ3Wwq3QAQci3ykt95IQhJf+3SzDq0lXg+OCFgrAcTui6yy+KmUWLdSqTn
EztCo+yC2iCvPj6GjXrXqJ3X1uyhQ91LnOClphjS/6MsAsHoYd+i29d0fcISlnwBUEsDBBQAAAAI
AAereS6bodrTeQAAANkAAAAnAAAAYmFzZV90aGVtZS0yLjEzL3N0cnVjdC90aGVtZV9vcmFjbGUu
c3Fscw5ydQxxVQhxdPJxVSjJSM1NVdDggjDiM1MUwCAzr0QhLx+IS3NydICSmSU5qQowUJZYlJyR
WGSkYWqgiawqJbU4uSizoCQzPw9VFUgZRElBYlEq0GgFrLYkF6WmZJZg2GKErL8oMzexqFIhO7US
qEQD4WpNLk0uAFBLAwQUAAAACAAHq3kumBmGKoICAAA7BgAAKwAAAGJhc2VfdGhlbWUtMi4xMy9k
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
tlIXxNR1oxIS6hfdXkYVheAEayExsdMNVey379oOENIWyIOT2Pccn3vutZkf/PYjAneMJINEkMwP
RMd1Rw/DQcKFH8eu+zQjc9I1jFMwB1MX1G+Tze0XaDfPoOM4Fy3nrNW+BOfcdT675xcQ+8EsXUL/
LwNT4r6nQDWbL2iaQBoCbgBhmoGYUQ5MizCMnBPgIqOB6KrviY/D4k/9Y3nQQGXmIfWu+7P/OBrc
3UIPOMtoIsL6SW3arDmd6YkNC/ORvFCO0lyVkwm9f9Cqj6efGuOmerXkNvMlXD19vR72R4BPD+pg
CWUGX8SWbcCbRy97LEuZipFiJcmo//Cjf/sNebYkHieLnCTBUWy7wVCIq90MhpoT0Sl6ERPofYFf
a6Seepe/zL0nrKT8Wa6xSE2rTQprDkHoZAspdqWycrLU+6RFJMHyijQ7qP8oOhW5yyn1SSd5PoGI
CG9Oo0z1KzJiq851774qPnS7DiYncQgNNPzK666na+ucwlRVl7OUcS+Ifc5l0lalVVV7qgqu8UUO
CD8af4+QDUdGRJ4l6O64JMXGvy3xc9dYbfPEA5cHiJEtKIr8ChJtlvVBeEixwap+2PIlcBRLRnbM
oaGMUdNkgYmoNkPZBUVpW1M18qtuxJVGr9RIYl6huY/2UbDoAFxZeY3Nso+FTqos5G3s5gRIe3Vw
ybWpL/yyYRuQVdyMnr5KMM6yK5P6ApEr1cqRIM+oWL5DvGFYxyi8Qre7xn9QSwECFAMUAAAACAAH
q3ku7F7XmpIAAADUAAAAKgAAAAAAAAABAAAAJIEAAAAAYmFzZV90aGVtZS0yLjEzL3N0cnVjdC90
aGVtZV9pbnRlcmJhc2Uuc3FsUEsBAhQDFAAAAAgAB6t5Lqus+OaSAAAA1AAAACAAAAAAAAAAAQAA
ACSB2gAAAGJhc2VfdGhlbWUtMi4xMy9zdHJ1Y3QvdGhlbWUuc3FsUEsBAhQDFAAAAAgA7gJSMPO5
JWKoCQAAQyQAACgAAAAAAAAAAQAAACSBqgEAAGJhc2VfdGhlbWUtMi4xMy90ZW1wbGF0ZS90aGVt
ZV9mb3JtLnRtcGxQSwECFAMUAAAACAAHq3kuCe45kx8AAAAdAAAAKgAAAAAAAAABAAAAJIGYCwAA
YmFzZV90aGVtZS0yLjEzL3N0cnVjdC90aGVtZV9nZW5lcmF0b3Iuc3FsUEsBAhQDFAAAAAgAEbVK
MJQyhOJCAAAASAAAAB0AAAAAAAAAAQAAACSB/wsAAGJhc2VfdGhlbWUtMi4xMy9NQU5JRkVTVC5T
S0lQUEsBAhQDFAAAAAgAB6t5LnxEpYceAAAAHAAAACkAAAAAAAAAAQAAACSBfAwAAGJhc2VfdGhl
bWUtMi4xMy9zdHJ1Y3QvdGhlbWVfc2VxdWVuY2Uuc3FsUEsBAhQDFAAAAAgAB6t5LoyVrlMjAAAA
IQAAAC4AAAAAAAAAAQAAACSB4QwAAGJhc2VfdGhlbWUtMi4xMy9zdHJ1Y3QvdGhlbWVfcHJvcF9z
ZXF1ZW5jZS5zcWxQSwECFAMUAAAACACBAlIwywl6mdMAAAB2AQAAKQAAAAAAAAABAAAAJIFQDQAA
YmFzZV90aGVtZS0yLjEzL2RhdGEvaW5zdGFsbF9zZWN1cml0eS5kYXRQSwECFAMUAAAACAABtmIy
ArpD/wEIAACkEgAAFwAAAAAAAAABAAAAJIFqDgAAYmFzZV90aGVtZS0yLjEzL0NoYW5nZXNQSwEC
FAMUAAAACAAco2kyJta0HQwFAADHCgAALgAAAAAAAAABAAAAJIGgFgAAYmFzZV90aGVtZS0yLjEz
L09wZW5JbnRlcmFjdDIvQXBwL0Jhc2VUaGVtZS5wbVBLAQIUAxQAAAAIAAereS5pN8UmwwAAAAwB
AAAmAAAAAAAAAAEAAAAkgfgbAABiYXNlX3RoZW1lLTIuMTMvZGF0YS9pbnN0YWxsX3RoZW1lLmRh
dFBLAQIUAxQAAAAIAAereS6Tle2aJAAAACIAAAAvAAAAAAAAAAEAAAAkgf8cAABiYXNlX3RoZW1l
LTIuMTMvc3RydWN0L3RoZW1lX3Byb3BfZ2VuZXJhdG9yLnNxbFBLAQIUAxQAAAAIAMcGTTArGnzo
tgEAAL8DAAAoAAAAAAAAAAEAAAAkgXAdAABiYXNlX3RoZW1lLTIuMTMvdGVtcGxhdGUvdGhlbWVf
bGlzdC50bXBsUEsBAhQDFAAAAAgAB6t5LkkMMoadAAAAAAEAAC8AAAAAAAAAAQAAACSBbB8AAGJh
c2VfdGhlbWUtMi4xMy9zdHJ1Y3QvdGhlbWVfcHJvcF9pbnRlcmJhc2Uuc3FsUEsBAhQDFAAAAAgA
NrlxMtBFGBXICQAA5h8AAC0AAAAAAAAAAQAAACSBViAAAGJhc2VfdGhlbWUtMi4xMy9PcGVuSW50
ZXJhY3QyL0FjdGlvbi9UaGVtZS5wbVBLAQIUAxQAAAAIAGUKhDHT6mXwlgEAAJ0EAAAuAAAAAAAA
AAEAAAAkgWkqAABiYXNlX3RoZW1lLTIuMTMvbXNnL2Jhc2VfdGhlbWUtbWVzc2FnZXMtZW4ubXNn
UEsBAhQDFAAAAAgAA7ZiMiTamrm6AQAAFgMAABsAAAAAAAAAAQAAACSBSywAAGJhc2VfdGhlbWUt
Mi4xMy9wYWNrYWdlLmluaVBLAQIUAxQAAAAIAIytfy56tCF4wgAAAAICAAApAAAAAAAAAAEAAAAk
gT4uAABiYXNlX3RoZW1lLTIuMTMvY29uZi9zcG9wc190aGVtZV9wcm9wLmluaVBLAQIUAxQAAAAI
AAereS7AauLwhwAAAAUBAAAsAAAAAAAAAAEAAAAkgUcvAABiYXNlX3RoZW1lLTIuMTMvc3RydWN0
L3RoZW1lX3Byb3Bfb3JhY2xlLnNxbFBLAQIUAxQAAAAIAAereS7cMoJYmAAAAPgAAAAlAAAAAAAA
AAEAAAAkgRgwAABiYXNlX3RoZW1lLTIuMTMvc3RydWN0L3RoZW1lX3Byb3Auc3FsUEsBAhQDFAAA
AAgAB6t5Lpuh2tN5AAAA2QAAACcAAAAAAAAAAQAAACSB8zAAAGJhc2VfdGhlbWUtMi4xMy9zdHJ1
Y3QvdGhlbWVfb3JhY2xlLnNxbFBLAQIUAxQAAAAIAAereS6YGYYqggIAADsGAAArAAAAAAAAAAEA
AAAkgbExAABiYXNlX3RoZW1lLTIuMTMvZGF0YS9pbnN0YWxsX3RoZW1lX3Byb3AuZGF0UEsBAhQD
FAAAAAgA8rViMiHl0yYLAQAA5QIAAB8AAAAAAAAAAQAAACSBfDQAAGJhc2VfdGhlbWUtMi4xMy9j
b25mL2FjdGlvbi5pbmlQSwECFAMUAAAACABvu3Mv938pYz8BAAC5AgAAJAAAAAAAAAABAAAAJIHE
NQAAYmFzZV90aGVtZS0yLjEzL2NvbmYvc3BvcHNfdGhlbWUuaW5pUEsBAhQDFAAAAAgANrlxMvUd
33oaBwAAUBEAACYAAAAAAAAAAQAAACSBRTcAAGJhc2VfdGhlbWUtMi4xMy9PcGVuSW50ZXJhY3Qy
L1RoZW1lLnBtUEsBAhQDFAAAAAgAa6JcMsHFMcznAAAAiQIAABgAAAAAAAAAAQAAACSBoz4AAGJh
c2VfdGhlbWUtMi4xMy9NQU5JRkVTVFBLAQIUAxQAAAAIADa5cTJPDiYsPgIAAPYFAAAxAAAAAAAA
AAEAAAAkgcA/AABiYXNlX3RoZW1lLTIuMTMvT3BlbkludGVyYWN0Mi9TUUxJbnN0YWxsL1RoZW1l
LnBtUEsFBgAAAAAbABsA+AgAAE1CAAAAAA==

SOMELONGSTRING
}
