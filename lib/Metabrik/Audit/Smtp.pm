#
# $Id: Smtp.pm,v eff9afda3723 2015/01/04 12:34:23 gomor $
#
# audit::smtp Brik
#
package Metabrik::Audit::Smtp;
use strict;
use warnings;

use base qw(Metabrik);

sub brik_properties {
   return {
      revision => '$Revision: eff9afda3723 $',
      tags => [ qw(unstable audit smtp) ],
      attributes => {
         hostname => [ qw(hostname) ],
         port => [ qw(integer) ],
         domainname => [ qw(domainname) ],
         _smtp => [ qw(INTERNAL) ],
      },
      commands => {
         connect => [ ],
         banner => [ ],
         quit => [ ],
         open_auth_login => [ ],
         open_relay => [ ],
         all => [ ],
      },
      require_modules => {
         'Net::SMTP' => [],
         'Net::Cmd' => [ qw(CMD_INFO CMD_OK CMD_MORE CMD_REJECT CMD_ERROR CMD_PENDING) ],
      },
   };
}

sub brik_use_properties {
   my $self = shift;

   return {
      attributes_default => {
         hostname => $self->global->hostname,
         domainname => $self->global->domainname,
         port => 25,
      },
   };
}

sub connect {
   my $self = shift;

   my $hostname = $self->hostname;
   my $port = $self->port;
   my $domainname = $self->domainname;
   my $timeout = $self->global->ctimeout;

   my $smtp = Net::SMTP->new(
      $hostname,
      Port    => $port,
      Hello   => $domainname,
      Timeout => $timeout,
      Debug   => $self->log->level,
   ) or return $self->log->error("connect: $!");

   $self->_smtp($smtp);

   return $smtp;
}

sub quit {
   my $self = shift;

   if (! defined($self->_smtp)) {
      return $self->log->error($self->brik_help_run('connect'));
   }

   my $smtp = $self->_smtp;
   $self->_smtp(undef);

   return $smtp->quit;
}

sub banner {
   my $self = shift;

   if (! defined($self->_smtp)) {
      return $self->log->error($self->brik_help_run('connect'));
   }

   my $smtp = $self->_smtp;

   chomp(my $banner = $smtp->banner);

   # XXX: move to identify::smtp
   #if ($banner =~ /rblsmtpd/i) {
      #$log->debug("smtpRbl=1");
      #$result->rbl(1);
   #}
   #else {
      #$log->debug("smtpRbl=0");
      #$result->rbl(0);
   #}

   return $banner;
}

sub open_auth_login {
   my $self = shift;

   if (! defined($self->_smtp)) {
      return $self->log->error($self->brik_help_run('connect'));
   }

   my $smtp = $self->_smtp;

   my $smtp_feature_auth_login = 0;
   my $smtp_open_auth_login = 0;

   my $msg = $smtp->message;
   if ($msg =~ /AUTH LOGIN/i) {
      $smtp_feature_auth_login = 1;

      my $ok = $smtp->command("AUTH LOGIN")->response;
      if ($ok == Net::Cmd::CMD_MORE()) {
         $ok = $smtp->command("YWRtaW4=")->response; # Send login 'admin'
         if ($ok == Net::Cmd::CMD_MORE()) {
            $ok = $smtp->command("YWRtaW4=")->response; # Send password 'admin'
            if ($ok == Net::Cmd::CMD_OK()) {
               $smtp_open_auth_login = 1;
            }
         }
      }
   }

   return {
      smtp_feature_auth_login => $smtp_feature_auth_login,
      smtp_open_auth_login => $smtp_open_auth_login,
   };
}

sub open_relay {
   my $self = shift;

   if (! defined($self->_smtp)) {
      return $self->log->error($self->brik_help_run('connect'));
   }

   my $smtp = $self->_smtp;

   my $smtp_open_relay = 0;
   my $smtp_to_reject = 0;
   my $smtp_to_error = 0;
   my $smtp_from_reject = 0;
   my $smtp_from_error = 0;

   my $ok = $smtp->mail('audit@example.com');
   if ($ok) {
      $ok = $smtp->to('audit@example.com');
      if ($ok) {
         $smtp_open_relay = 1;
      }
      else {
         my $status = $smtp->status;
         if ($status == Net::Cmd::CMD_REJECT()) {
            $smtp_to_reject = 1;
         }
         elsif ($status == Net::Cmd::CMD_ERROR()) {
            $smtp_to_error = 1;
         }
         else {
            chomp(my $msg = $smtp->message);
            $self->log->debug("open_relay: MSG[$msg]");
         }
      }
   }
   else {
      my $status = $smtp->status;
      if ($status == Net::Cmd::CMD_REJECT()) {
         $smtp_from_reject = 1;
      }
      elsif ($status == Net::Cmd::CMD_ERROR()) {
         $smtp_from_error = 1;
      }
      else {
         chomp(my $msg = $smtp->message);
         $self->log->debug("open_relay: MSG[$msg]");
      }
   }

   return {
      smtp_open_relay => $smtp_open_relay,
      smtp_to_reject => $smtp_to_reject,
      smtp_to_error => $smtp_to_error,
      smtp_from_reject => $smtp_from_reject,
      smtp_from_error => $smtp_from_error,
   };
}

sub all {
   my $self = shift;

   my $hash = {};

   my $check_001 = $self->open_auth_login;
   for (keys %$check_001) { $hash->{$_} = $check_001->{$_} }

   my $check_002 = $self->open_relay;
   for (keys %$check_002) { $hash->{$_} = $check_002->{$_} }

   return $hash;
}

1;

__END__

=head1 NAME

Metabrik::Audit::Smtp - audit::smtp Brik

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2014-2015, Patrice E<lt>GomoRE<gt> Auffret

You may distribute this module under the terms of The BSD 3-Clause License.
See LICENSE file in the source distribution archive.

=head1 AUTHOR

Patrice E<lt>GomoRE<gt> Auffret

=cut
