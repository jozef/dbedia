package dbedia;

=head1 NAME

dbedia - interface to dbedia.com

=head1 SYNOPSIS

    my $dbedia = dbedia->new( base_uri => 'http://dbedia.com/WURFL' );
    my %brands = %{ $dbedia->get('brandsModels.json') };

=head1 DESCRIPTION

This is an experiment.

=cut

use warnings;
use strict;

our $VERSION = '0.01';

use 5.010;
use feature 'state';

use base 'Class::Accessor::Fast';

use App::Cache;
use Carp;
use JSON::XS;
use IO::Uncompress::Gunzip 'gunzip', '$GunzipError';

=head1 PROPERTIES

    base_uri    (default 'http://dbedia.com/')
    cache_ttl   (default 60*60)

=cut

__PACKAGE__->mk_accessors(qw{
    base_uri
    cache_ttl
    _cache
});


=head1 METHODS

=head2 new()

Object constructor.

=cut

sub new {
    my $class = shift;
    my $self  = $class->SUPER::new({
        'base_uri' => 'http://dbedia.com/',
        'cache_ttl' => 60*60,
        @_
    });
    $self->_cache(App::Cache->new({ ttl => $self->cache_ttl }));
    
    return $self;
}


=head2 get($path)

Get C<$path> from dbedia by prepending C<< $self->base_uri >>. Results are
cached for C<< $self->cache_ttl >> seconds.

=cut

sub get {
    my $self = shift;
    my $path = shift;
    
    croak 'pass path as function argument'
        if not $path;
    
    my $data = $self->_cache->get_url($self->base_uri.$path);
    
    my $suffix = '';
    $suffix = $1
        if $path =~ m/\.([^.]+)$/;
    
    # decompress gzip-ed content
    if ($suffix eq 'gz') {
        my $gzdata = $data;
        gunzip \$gzdata => \$data or die "gunzip failed: $GunzipError\n";

        $path = substr($path, 0, -3);
        $suffix = '';
        $suffix = $1
            if $path =~ m/\.([^.]+)$/;
    }
    
    state $json = JSON::XS->new->utf8;
    return (
        $suffix eq 'json' ? $json->decode($data)
        : $data
    );
}


=head2 clear_cache

Clears the cache.

=cut

sub clear_cache {
    my $self = shift;
    return $self->_cache->clear;
}

1;


__END__

=head1 AUTHOR

Jozef Kutej, C<< <jkutej at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-dbedia at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=dbedia>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc dbedia


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=dbedia>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/dbedia>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/dbedia>

=item * Search CPAN

L<http://search.cpan.org/dist/dbedia>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 Jozef Kutej, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1;
