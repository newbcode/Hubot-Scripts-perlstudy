package Hubot::Scripts::perlstudy;

use utf8;
use strict;
use warnings;
use Encode;
use LWP::UserAgent;
use Data::Printer;

my $decode_body;

sub load {
    my ( $class, $robot ) = @_;
 
    $robot->hear(
        qr/^start/i,    
        sub {
            my $msg = shift;
            my $user_input = $msg->match->[0];
        
            $msg->http("http://cafe.rss.naver.com/perlstudy")->get(
                sub {
                    my ( $body, $hdr ) = @_;
                    return if ( !$body || $hdr->{Status} !~ /^2/ );

                    $decode_body = decode ("utf8", $body);
                    #$robot->brain->{data}{old_body} = $decode_body;
                    my @titles = $decode_body =~ m{<title>(.*?)</title>}gsm;
                    my @times = $decode_body =~ m{<pubDate>(.*?)</pubDate>}gsm;

                    #$msg->send($decode_body);
                    $msg->send(@times);
                    #$msg->send(@titles);
                    # $msg->send($robot->brain->{data}{old_body});
                }
            );
        }
    );
}
1;

=pod

=head1 Name 

    Hubot::Scripts::perlstudy
 
=head1 SYNOPSIS

    naver perl cafe polling script
 
=head1 AUTHOR

    YunChang Kang <codenewb@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Yunchang Kang.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself
 
=cut
