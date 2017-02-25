package BounceBee::Bounce;

use strict;
use warnings;
use Moo;
use Types::Standard qw/InstanceOf/;
use Sisimai::Data;

=head1 Name

BounceBee::Bounce - Email message bounce class

=head1 Public attributes

=head2 reason

Code for the reason why the email has been bounced.

=head2 reason_advice

Human readable advice about the reason.

=head2 bounce_date

Date and time of the bounce.

=head2 subject

Subject of the original email.

=head2 recipient

Recipient object.

=head2 recipient_email

Email address of recipient.

=head2 recipient_domain

Domain part of email address.

=head2 provider

Name of provider which bounced the email.

=head2 providers

List of email providers.

=head2 data

L<Sisimai::Data> object used to retrieve information about the bounced message.

=head1 Internal attributes

=head2 rhost

=head2 timestamp

=cut

has data => (is => 'ro', isa => InstanceOf['Sisimai::Data'], required => 1);

has providers => (
    is => 'ro',
    default => sub {
        return {
            'bluewin.ch' => 'BlueWin',
            'gmail.com' => 'Google Email',
            't-online.de' => 'T Online',
            'web.de' => 'WEB.DE',
        }
    }
);

sub recipient {
    return $_[0]->data->recipient;
}

sub recipient_email {
    return $_[0]->data->recipient->address;
}

sub recipient_domain {
    return $_[0]->data->recipient->host;
}

sub rhost {
    return $_[0]->data->rhost;
}

sub provider {
    my $self = shift;
    my $destination = $self->data->destination;
    my $host = $self->rhost;

    if (exists $self->providers->{$destination}) {
        return $self->providers->{$destination};
    }

    return $destination ? $destination : $host;
}

sub reason {
    return $_[0]->data->reason;
}

sub reason_advice {
    my $self = shift;
    my $reason = $self->reason;
    my $advice = [$reason];

    if ($reason eq 'hostunknown') {
        $advice = ['Please doublecheck your email %s, the domain %s is unknown.',
                   $self->recipient_email, $self->recipient_domain];
    }
    elsif ($reason eq 'mailboxfull') {
        $advice = ['Your mailbox %s has been reported to be full by your email provider %s.', $self->recipient_email, $self->provider];
    }
    elsif ($reason eq 'securityerror') {
        $advice = ['Your provider %s rejected the email to your address %s.', $self->provider, $self->recipient_email];
    }
    elsif ($reason eq 'userunknown') {
        $advice = ['Please doublecheck your email address %s, your email provider %s has rejected our email with the reason of unknown', $self->recipient_email, $self->provider];
    }

    return sprintf(shift(@$advice), @$advice);
}

sub timestamp {
    return $_[0]->data->timestamp;
}

sub bounce_date {
    return $_[0]->data->timestamp->ymd;
}

sub subject {
    return $_[0]->data->subject;
}

1;
