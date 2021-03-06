#
# $Id: Netbios.pm,v eff9afda3723 2015/01/04 12:34:23 gomor $
#
# network::netbios Brik
#
package Metabrik::Network::Netbios;
use strict;
use warnings;

use base qw(Metabrik);

sub brik_properties {
   return {
      revision => '$Revision: eff9afda3723 $',
      tags => [ qw(unstable netbios) ],
      commands => {
         probe => [ qw(ipv4_address) ],
      },
      require_modules => {
         'Net::NBName' => [ ],
      },
   };
}

sub probe {
   my $self = shift;
   my ($ip) = @_;

   if (! defined($ip)) {
      return $self->log->error($self->brik_help_run('probe'));
   }

   my $nb = Net::NBName->new;
   if (! $nb) {
      return $self->log->error("can't new() Net::NBName: $!");
   }

   my $ns = $nb->node_status($ip);
   if ($ns) {
      #for my $rr ($ns->names) {
          #if ($rr->suffix == 0 && $rr->G eq "GROUP") {
              #$domain = $rr->name;
          #}
          #if ($rr->suffix == 3 && $rr->G eq "UNIQUE") {
              #$user = $rr->name;
          #}
          #if ($rr->suffix == 0 && $rr->G eq "UNIQUE") {
              #$machine = $rr->name unless $rr->name =~ /^IS~/;
          #}
      #}
      #$mac_address = $ns->mac_address;
      #print "$mac_address $domain\\$machine $user";
      print $ns->as_string;
      return $nb;
   }

   print "no response\n";

   return $nb;
}

1;

__END__

=head1 NAME

Metabrik::Network::Netbios - network::netbios Brik

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2014-2015, Patrice E<lt>GomoRE<gt> Auffret

You may distribute this module under the terms of The BSD 3-Clause License.
See LICENSE file in the source distribution archive.

=head1 AUTHOR

Patrice E<lt>GomoRE<gt> Auffret

=cut
