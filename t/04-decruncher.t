#########################
use Archive::ByteBoozer qw(:crunch);
use IO::Scalar;
use Test::Deep;
use Test::More tests => 1;
#########################
{
    my @data = (0x00, 0x0d, 0x01, 0x02, 0x03, 0x04, 0x05);
    my $data = join '', map { chr $_ } @data;
    my $in = new IO::Scalar \$data;
    my $out = new IO::Scalar;
    my $start_address = 0x0d00;
    my %params = (source => $in, target => $out, attach_decruncher => $start_address);
    # my %params = (source => $in, target => $out, make_executable => $start_address);
    crunch(%params);
    my $crunched_data = <$out>;
    my @crunched_data = split '', $crunched_data;
    my @expected_data = map { chr $_ } (
        0x01, 0x08, 0x0b, 0x08, 0x00, 0x00, 0x9e, 0x32, 0x30, 0x36, 0x31, 0x00, 0x00, 0x00, 0x78, 0xa9,
        0x34, 0x85, 0x01, 0xa2, 0x3b, 0xbd, 0x1f, 0x08, 0x95, 0x06, 0xca, 0x10, 0xf8, 0x4c, 0x08, 0x00,
        0xf6, 0xff, 0xa0, 0xff, 0xb9, 0x25, 0x08, 0x99, 0x00, 0xff, 0x88, 0xd0, 0xf7, 0xb1, 0x0b, 0x91,
        0x0e, 0xc6, 0x0f, 0xc6, 0x0c, 0xa5, 0x0c, 0xc9, 0x08, 0xb0, 0xe7, 0xb9, 0x5b, 0x08, 0x99, 0x34,
        0x03, 0xc8, 0xd0, 0xf7, 0xa0, 0x02, 0xb1, 0x06, 0x99, 0x03, 0x00, 0x88, 0x10, 0xf8, 0x18, 0xa9,
        0x03, 0x65, 0x06, 0x85, 0x06, 0x90, 0x02, 0xe6, 0x07, 0x4c, 0x34, 0x03, 0x20, 0xb8, 0x03, 0x08,
        0xa9, 0x01, 0x20, 0xb8, 0x03, 0x90, 0x06, 0x20, 0xb8, 0x03, 0x2a, 0x10, 0xf5, 0x28, 0xb0, 0x18,
        0x85, 0x02, 0xa0, 0x00, 0xb1, 0x06, 0x91, 0x04, 0xc8, 0xc4, 0x02, 0xd0, 0xf7, 0xa2, 0x02, 0x20,
        0xdd, 0x03, 0xc8, 0xf0, 0xd7, 0x38, 0xb0, 0xd7, 0x69, 0x00, 0xf0, 0x4c, 0x85, 0x02, 0xc9, 0x03,
        0xa9, 0x00, 0x85, 0x08, 0x85, 0x09, 0x2a, 0x20, 0xb8, 0x03, 0x2a, 0x20, 0xb8, 0x03, 0x2a, 0xaa,
        0xbc, 0xec, 0x03, 0x20, 0xb8, 0x03, 0x26, 0x08, 0x26, 0x09, 0x88, 0xd0, 0xf6, 0x8a, 0xca, 0x29,
        0x03, 0xf0, 0x08, 0xe6, 0x08, 0xd0, 0xe9, 0xe6, 0x09, 0xd0, 0xe5, 0x38, 0xa5, 0x04, 0xe5, 0x08,
        0x85, 0x08, 0xa5, 0x05, 0xe5, 0x09, 0x85, 0x09, 0xb1, 0x08, 0x91, 0x04, 0xc8, 0xc4, 0x02, 0xd0,
        0xf7, 0xa2, 0x00, 0x20, 0xdd, 0x03, 0x30, 0x84, 0xa9, 0x37, 0x85, 0x01, 0x58, 0x4c, 0x00, 0x0d,
        0x06, 0x03, 0xd0, 0x20, 0x48, 0x98, 0x48, 0xa0, 0x00, 0xb1, 0x06, 0xe6, 0x06, 0xd0, 0x02, 0xe6,
        0x07, 0x38, 0x2a, 0x85, 0x03, 0xa9, 0x05, 0xe6, 0x01, 0x8d, 0x20, 0xd0, 0x8c, 0x20, 0xd0, 0xc6,
        0x01, 0x68, 0xa8, 0x68, 0x60, 0x18, 0x98, 0x75, 0x04, 0x95, 0x04, 0x90, 0x02, 0xf6, 0x05, 0xca,
        0xca, 0x10, 0xf2, 0x60, 0x04, 0x02, 0x02, 0x02, 0x05, 0x02, 0x02, 0x03, 0x58, 0x00, 0x0d, 0xbf,
        0x01, 0x02, 0x03, 0x04, 0x05, 0xff
    );
    cmp_deeply(\@crunched_data, \@expected_data, 'attaching decruncher to the compressed data');
}
#########################
