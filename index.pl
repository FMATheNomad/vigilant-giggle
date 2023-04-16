#!/usr/bin/perl

use strict;
use warnings;
use feature 'say';
use Mojo::UserAgent;
use Mojo::Util qw(decode encode);
use Mojo::DOM;

# Set up UserAgent
my $ua = Mojo::UserAgent->new;
$ua->transactor->name('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3');

# Set up URLs
my $url = 'https://www.example.com';

# Make request
my $tx = $ua->get($url);

# Check response
if (my $res = $tx->success) {

    # Get content
    my $html = decode('UTF-8', $res->body);

    # Parse HTML
    my $dom = Mojo::DOM->new($html);

    # Extract data
    my @data;
    for my $row ($dom->find('table tr')->each) {
        my $col1 = $row->at('td:nth-child(1)')->text;
        my $col2 = $row->at('td:nth-child(2)')->text;
        push @data, [$col1, $col2];
    }

    # Print data
    say join("\t", @$_) for @data;

} else {

    # Handle error
    my $err = $tx->error;
    say "Error: $err->{message}";

}
