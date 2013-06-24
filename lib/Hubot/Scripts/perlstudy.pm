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
                    my @titles = $decode_body =~ m{<!\[CDATA\[(.*?)\]\]>}gsm;
                    my @times = $decode_body =~ m{<pubDate>(.*?) \+0900</pubDate>}gsm;
                    $msg->send('befor if in');

                    my @new_titles;
                    if ( $robot->brain->{data}{old_titles} ) {
                    $msg->send('if in');
                    my $cnt = 0;
                        for my $title (@titles) {
                            if ( $title eq $robot->brain->{data}{old_titles}->[$cnt] ) {
                                push @new_titles, $robot->brain->{data}{old_titles}->[$cnt];
                                $msg->send('unless in');
                            }
                        $cnt++;
                        }
                    }
                    else {
                        $robot->brain->{data}{old_titles} = \@titles;
                        $robot->brain->{data}{old_times} = \@times;
                    }
                    $msg->send(@new_titles);
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
