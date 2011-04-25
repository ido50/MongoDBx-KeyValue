package MongoDBx::KeyValue;

# ABSTRACT: Use MongoDB as if it were a key-value store.

use strict;
use warnings;
use MongoDB;
use Carp;

our $VERSION = "0.001";
$VERSION = eval $VERSION;

sub new {
	my ($class, %opts) = @_;

	my $kvdb = delete $opts{kvdb} || croak "You must provide the name of the key-value database (as parameter 'kvdb')";

	bless {
		conn => MongoDB::Connection->new(%opts),
		db => $kvdb,
	}, $class;
}

sub get {
	my ($self, $bucket, $key) = @_;

	my $entry = $self->{conn}->get_database($self->{db})->get_collection($bucket)->find_one({ _id => $key });
	return $entry ? $entry->{value} : undef;
}

sub set {
	my ($self, $bucket, $key, $value) = @_;

	$self->{conn}->get_database($self->{db})->get_collection($bucket)->insert({ _id => $key, value => $value });
}

1;
