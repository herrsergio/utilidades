#!/usr/bin/perl
#
# Net::Twitter - OAuth desktop app example
#
use warnings;
use strict;

use Net::Twitter;
use File::Spec;
use Storable;
use Data::Dumper;

# You can replace the consumer tokens with your own;
# these tokens are for the Net::Twitter example app.
my %consumer_tokens = (
    consumer_key    => '4bz7XfRrXXxKdo4J5QstyA',
    consumer_secret => 'RlbHrcG6ehbn8rNNX9fy6Au6CsPNlgfW1WKW1eg8',
);

my (undef, undef, $datafile) = File::Spec->splitpath($0);
$datafile = "/home/sergio/perl/oauth_desktop.dat";
#$datafile =~ s/\..*/.dat/;

my $nt = Net::Twitter->new(traits => [qw/API::REST OAuth/], %consumer_tokens);
my $access_tokens = eval { retrieve($datafile) } || [];

if ( @$access_tokens ) {
    $nt->access_token($access_tokens->[0]);
    $nt->access_token_secret($access_tokens->[1]);
}
else {
    my $auth_url = $nt->get_authorization_url;
    print " Authorize this application at: $auth_url\nThen, enter the PIN# provided to continue: ";

    my $pin = <STDIN>; # wait for input
    chomp $pin;

    # request_access_token stores the tokens in $nt AND returns them
    my @access_tokens = $nt->request_access_token(verifier => $pin);

    # save the access tokens
    store \@access_tokens, $datafile;
}

my $tweet_msg = `uptime`;
#my $tweet_msg = "hola";
my $result     = $nt->update( $tweet_msg );
print "$tweet_msg\n";

