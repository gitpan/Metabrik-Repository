#
# $Id: Wps.pm 360 2014-11-16 14:52:06Z gomor $
#
# network::wps Brik
#
package Metabrik::Network::Wps;
use strict;
use warnings;

use base qw(Metabrik::Network::Wlan);

sub brik_properties {
   return {
      revision => '$Revision: 360 $',
      tags => [ qw(unstable wifi wlan network wps) ],
      commands => {
         brute_force_wps => [ qw(essid bssid|OPTIONAL) ],
      },
      require_used => {
         'shell::command' => [ ],
      },
      require_binaries => {
         'sudo', => [ ],
         'reaver', => [ ],
      },
   };
}

sub brute_force_wps {
   my $self = shift;
   my ($essid, $bssid) = @_;

   if (! defined($essid)) {
      return $self->log->error($self->brik_help_run('brute_force_wps'));
   }

   my $context = $self->context;

   # If user provided bssid, we skip auto-detection
   if (! defined($bssid)) {
      my $scan = $self->scan;
      if (! defined($scan)) {
         return $self->log->error("brute_force_wps: no AP found?");
      }

      my $ap;
      for my $this (keys %$scan) {
         $self->log->info("this[$this] essid[$essid]");
         if ($scan->{$this}->{essid} eq $essid) {
            $ap = $scan->{$this};
            last;
         }
      }

      if (! defined($ap)) {
         return $self->log->error("brute_force_wps: no AP found by that essid [$essid]");
      }

      $bssid = $ap->{address};
   }

   my $monitor = $self->start_monitor_mode or return;

   my $cmd = "sudo reaver -i $monitor -b $bssid -vv";
   my $r = $context->run('shell::command', 'system', $cmd);

   $self->stop_monitor_mode;

   return $r;
}

1;

__END__

=head1 NAME

Metabrik::Network::Wps - network::wps Brik

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2014, Patrice E<lt>GomoRE<gt> Auffret

You may distribute this module under the terms of The BSD 3-Clause License.
See LICENSE file in the source distribution archive.

=head1 AUTHOR

Patrice E<lt>GomoRE<gt> Auffret

=cut
