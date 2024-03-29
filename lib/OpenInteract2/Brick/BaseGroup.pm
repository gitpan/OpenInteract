package OpenInteract2::Brick::BaseGroup;

use strict;
use base qw( OpenInteract2::Brick );
use OpenInteract2::Exception;

my %INLINED_SUBS = (
    'base_group-2.20.zip' => 'BASE_GROUP220ZIP',
);

sub get_name {
    return 'base_group';
}

sub get_resources {
    return (
        'base_group-2.20.zip' => [ 'pkg base_group-2.20.zip', 'no' ],
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

OpenInteract2::Brick::BaseGroup - Base-64 encoded OI2 package 'base_group-2.20.zip' shipped with distribution

=head1 SYNOPSIS

  oi2_manage create_website --website_dir=/path/to/site

=head1 DESCRIPTION

Are you sure you even need to be reading this? If you are just looking
to install a package just follow the instructions from the SYNOPSIS.

Still here? This class holds the Base64-encoded versions of package
file "base_group-2.20.zip" shipped with OpenInteract2. Once you decode them you
should store them as a ZIP file and then read them in with
Archive::Zip or some other utility.

A typical means to do this is:

 my $brick = OpenInteract2::Brick->new( 'base_group' );

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


=item B<base_group-2.20.zip>


=back

=head1 COPYRIGHT

Copyright (c) 2005 Chris Winters. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHORS


Chris Winters E<lt>chris@cwinters.comE<gt>


=cut


sub BASE_GROUP220ZIP {
    return <<'SOMELONGSTRING';
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
/wdMBKcaw1VQbrAWW4JJhKquA76JA1uMBFWZWKHpIYU2nha/EQK4r1zLRcUni8dwOPoGpRuV+Tvo
5Gvde9aP6R2BvKExuiGl3ztSuVi13E5q+0i0RWVFV+5OmjtHbv+MXlRIicaKgcNO4WbQJBYuu2q9
WHHaVPZmlarjgR+p4MhbLb8yczhbhq7cDSGmGXPTqtRYhbo0JE0aHT3UTX1iGjvR9+lHHPwBUEsD
BBQAAAAIAMxmdi5o1QU/IgAAACAAAAAtAAAAYmFzZV9ncm91cC0yLjIwL3N0cnVjdC9zeXNfZ3Jv
dXBfc2VxdWVuY2Uuc3Fscw5ydQxxVQh2DQx19XN2VcjPjC+uLI5PL8ovLYgvTi0EAFBLAwQUAAAA
CADMZnYuq/3Lw2YAAACYAAAAKQAAAGJhc2VfZ3JvdXAtMi4yMC9zdHJ1Y3Qvc3lzX2dyb3VwX3Vz
ZXIuc3Fscw5ydQxxVQhxdPJxVSiuLI5PL8ovLYgvLU4tUtDgUoDwMlMUwEBV1T3IPzTA0yU+JDLA
VVVVIS+/RCGvNCdHh0sBpAOuEKgyNNg1CKvCgqLM3MSiSoXs1EqgQg24FTpwIzS5NLkAUEsDBBQA
AAAIACygcjAn1PCT/wAAACwDAAApAAAAYmFzZV9ncm91cC0yLjIwL2RhdGEvaW5zdGFsbF9zZWN1
cml0eS5kYXSl0c9LwzAUB/B7/4p3EHIZTMWDTCZ4kp08eCwlZMnryEiT7CW1DPF/d0vbrcMqVXMI
5Mf7vG/IVUBZk457WEIOGQC8g668o8jj3iO0Y/kIzK23KCObZWkneOcDl0aEMLjz4tGubEQSMt4u
Fq+d3ReVGo3ijhTSuSiHXTOHVmp7cK0gSHfonua07CRu8A0NzKHoyEjChtJRxRWWojaxJdlJYjNg
PcOggI9UmH/J+kyu9ofL/WCh9kibi13WHLXGkTmyN12ICZav10ZLPtQurbv/WZv0Sh2RC1Vpezq8
n86OVP854pj1+4hPMmpnzzy7HvQY/ZHvI06yfogIWfGQfQJQSwMEFAAAAAgAAVRxMi0YVgynCQAA
LxYAABcAAABiYXNlX2dyb3VwLTIuMjAvQ2hhbmdlc5VYa2/byhH9XP+KCdBc2oUt86GHzQTudWIn
1a1ju5aNi34SKHIt7Q1F8nLJOPr3PTNLSlToFG2QAJKyOzN75syZ2X1Q37TReUYrbaq83NBzXtJd
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
Cg1XeinvdF5rpf103czRwV/FKBK6ts05Kx+IK4palI9D26RPd7CcBJ2jWODnQuzOxKbr9i+PuzXt
uoc6paGkow2yTrqFvZ2CI4gUIiViwZr4HupS6QaQDchIYKjH2Qmk0YZABrKV8Z9OwZMXKiwKnPwM
GhkIk3UnoG+h2qbsfjyBjlQ0PMBCsNhIhWHKcH7m6kRjFmRR95acSbVpRhYQX6+1575NwYe0/oCy
bAvrSEHzA1BLAwQUAAAACADMZnYuLZ+kg3AAAACcAAAAJAAAAGJhc2VfZ3JvdXAtMi4yMC9zdHJ1
Y3Qvc3lzX2dyb3VwLnNxbHMOcnUMcVUIcXTycVUoriyOTy/KLy1Q0OBSADPiM1MUwEBV1dPPOcjV
19UvRFVVh0shLzE3VQEOyhKLkjMSizSMDTQV8vJLFPJKc3JAivJLUosxFBmZmmrCVBQUZeYmFlUq
ZKdWAlVoICzV5NLkAgBQSwMEFAAAAAgAzGZ2Lk76FNxlAAAAnQAAACsAAABiYXNlX2dyb3VwLTIu
MjAvc3RydWN0L3N5c19ncm91cF9vcmFjbGUuc3Fscw5ydQxxVQhxdPJxVSiuLI5PL8ovLVDQ4FIA
M+IzUxTAIDOvRCEvH4hLc3J0uBTyEnNTFeCgLLEoOSOxyEjD2EATRVV+SWoxpiojU1NNmJKCoszc
xKJKhezUSqASDYStmlyaXABQSwMEFAAAAAgAAVRxMsSXul74BQAA/hQAAC0AAABiYXNlX2dyb3Vw
LTIuMjAvT3BlbkludGVyYWN0Mi9BY3Rpb24vR3JvdXAucG3NWHtP20gQ/z+fYhTSJuhCeN3pJCMQ
HKUIqT0QXE8nNZXl2JOwxfa63jWFS3Of/WZ214mdB23a3sOgAN55/2ZmZ8iC8C4YIVxmmF6kGvMg
1HuedxJqIVPPO89lkR00GhvQuog8MH/2sqR7D7u93V3Y29n5aXtnf3v3Z9jd93b2vb19UO9TOHvI
oNVoFApB6VyE+sD8Pgjo48PHziptpzJJZHoSRQ2oPk9SvxAqi4PHNTjeZFGgcQ2Ga0zkPcKmdeKV
HHkeffyYYR5XZbBjI9R+LEcjzEvyOcmnMlU6SLUy5B7RribU+KCd3NPf/ijpbq4ur2487wbDIsd5
/V6M9xjPkb7RIhb6kWBsPQWz5/1+dn1zcfkrHILKcpHqYaf5LOo929mLml340LrGe6GY3oLfgsO/
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
kpbQT5DGtUwgoB2xgPcjoynZyVXVtAts9RcwtseHgMx1Jh+QVKVdpjjzW0LqSTDX1W70cd5PP85j
U1hrSvq2Vu3w8PHctwWXApZcjGi+/v6FL/5fOFqk2iExb3Os/R63jfFSkMyOFsbWKRiSB0Hd8gkF
nFdSwzWdYg6b4B1Lgx9QSwECFAMUAAAACAAgdnEyCB0UiBACAAAwBQAALgAAAAAAAAABAAAAJIEA
AAAAYmFzZV9ncm91cC0yLjIwL21zZy9iYXNlX2dyb3VwLW1lc3NhZ2VzLW5vLm1zZ1BLAQIUAxQA
AAAIADW5cTI1UO45qQUAAFERAAAxAAAAAAAAAAEAAAAkgVwCAABiYXNlX2dyb3VwLTIuMjAvT3Bl
bkludGVyYWN0Mi9TUUxJbnN0YWxsL0dyb3VwLnBtUEsBAhQDFAAAAAgA87RKMJQyhOJCAAAASAAA
AB0AAAAAAAAAAQAAACSBVAgAAGJhc2VfZ3JvdXAtMi4yMC9NQU5JRkVTVC5TS0lQUEsBAhQDFAAA
AAgA7KpMMNDnuZs/AgAABAYAACoAAAAAAAAAAQAAACSB0QgAAGJhc2VfZ3JvdXAtMi4yMC90ZW1w
bGF0ZS9ncm91cF9kZXRhaWwudG1wbFBLAQIUAxQAAAAIAMxmdi5o1QU/IgAAACAAAAAtAAAAAAAA
AAEAAAAkgVgLAABiYXNlX2dyb3VwLTIuMjAvc3RydWN0L3N5c19ncm91cF9zZXF1ZW5jZS5zcWxQ
SwECFAMUAAAACADMZnYuq/3Lw2YAAACYAAAAKQAAAAAAAAABAAAAJIHFCwAAYmFzZV9ncm91cC0y
LjIwL3N0cnVjdC9zeXNfZ3JvdXBfdXNlci5zcWxQSwECFAMUAAAACAAsoHIwJ9Twk/8AAAAsAwAA
KQAAAAAAAAABAAAAJIFyDAAAYmFzZV9ncm91cC0yLjIwL2RhdGEvaW5zdGFsbF9zZWN1cml0eS5k
YXRQSwECFAMUAAAACAABVHEyLRhWDKcJAAAvFgAAFwAAAAAAAAABAAAAJIG4DQAAYmFzZV9ncm91
cC0yLjIwL0NoYW5nZXNQSwECFAMUAAAACADjq0wweir+OtQBAADtAwAAKAAAAAAAAAABAAAAJIGU
FwAAYmFzZV9ncm91cC0yLjIwL3RlbXBsYXRlL2dyb3VwX2xpc3QudG1wbFBLAQIUAxQAAAAIANup
yDDzF17tTwMAAPgJAAAoAAAAAAAAAAEAAAAkga4ZAABiYXNlX2dyb3VwLTIuMjAvdGVtcGxhdGUv
Z3JvdXBfZm9ybS50bXBsUEsBAhQDFAAAAAgA07wjL68Ys+chAQAAZQIAACQAAAAAAAAAAQAAACSB
Qx0AAGJhc2VfZ3JvdXAtMi4yMC9jb25mL3Nwb3BzX2dyb3VwLmluaVBLAQIUAxQAAAAIAByjaTKT
Cz92GQQAAHoIAAAuAAAAAAAAAAEAAAAkgaYeAABiYXNlX2dyb3VwLTIuMjAvT3BlbkludGVyYWN0
Mi9BcHAvQmFzZUdyb3VwLnBtUEsBAhQDFAAAAAgAAVRxMk+mWYUOAQAAsgEAABsAAAAAAAAAAQAA
ACSBCyMAAGJhc2VfZ3JvdXAtMi4yMC9wYWNrYWdlLmluaVBLAQIUAxQAAAAIAMxmdi4tn6SDcAAA
AJwAAAAkAAAAAAAAAAEAAAAkgVIkAABiYXNlX2dyb3VwLTIuMjAvc3RydWN0L3N5c19ncm91cC5z
cWxQSwECFAMUAAAACADMZnYuTvoU3GUAAACdAAAAKwAAAAAAAAABAAAAJIEEJQAAYmFzZV9ncm91
cC0yLjIwL3N0cnVjdC9zeXNfZ3JvdXBfb3JhY2xlLnNxbFBLAQIUAxQAAAAIAAFUcTLEl7pe+AUA
AP4UAAAtAAAAAAAAAAEAAAAkgbIlAABiYXNlX2dyb3VwLTIuMjAvT3BlbkludGVyYWN0Mi9BY3Rp
b24vR3JvdXAucG1QSwECFAMUAAAACACrVu4wVFoZ/loBAACxAwAAKQAAAAAAAAABAAAAJIH1KwAA
YmFzZV9ncm91cC0yLjIwL2NvbmYvbGRhcF9zcG9wc19ncm91cC5pbmlQSwECFAMUAAAACADItWIy
ZtZmc/oAAABTAgAAHwAAAAAAAAABAAAAJIGWLQAAYmFzZV9ncm91cC0yLjIwL2NvbmYvYWN0aW9u
LmluaVBLAQIUAxQAAAAIAAFUcTL2KqnkzgEAAPkEAAAuAAAAAAAAAAEAAAAkgc0uAABiYXNlX2dy
b3VwLTIuMjAvbXNnL2Jhc2VfZ3JvdXAtbWVzc2FnZXMtZW4ubXNnUEsBAhQDFAAAAAgAzGZ2LhtM
JXAjAAAAIQAAAC4AAAAAAAAAAQAAACSB5zAAAGJhc2VfZ3JvdXAtMi4yMC9zdHJ1Y3Qvc3lzX2dy
b3VwX2dlbmVyYXRvci5zcWxQSwECFAMUAAAACABOolwyuvBhV9QAAAD2AQAAGAAAAAAAAAABAAAA
JIFWMQAAYmFzZV9ncm91cC0yLjIwL01BTklGRVNUUEsFBgAAAAAVABUA9wYAAGAyAAAAAA==

SOMELONGSTRING
}

