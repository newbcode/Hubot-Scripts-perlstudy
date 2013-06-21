package Hubot::Scripts::perlstudy;

use utf8;
use strict;
use warnings;
use Encode;
use LWP::UserAgent;
use Data::Printer;

sub load {
    my ( $class, $robot ) = @_;
 
    $robot->hear(
        qr/^start/i,    
        \&on_process,
    );
}

sub on_process {
    my $msg = shift;

    my $user_input = $msg->match->[0];
    
    $msg->http("http://cafe.naver.com/perlstudy")->get(
        sub {
            my ( $body, $hdr ) = @_;
            return if ( !$body || $hdr->{Status} !~ /^2/ );

            my $decode_body = decode ("euc-kr", $body);
            $msg->send($decode_body);
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
