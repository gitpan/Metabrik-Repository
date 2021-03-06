#
# $Id: Battery.pm,v eff9afda3723 2015/01/04 12:34:23 gomor $
#
# harware::battery Brik
#
package Metabrik::Hardware::Battery;
use strict;
use warnings;

use base qw(Metabrik::File::Text);

sub brik_properties {
   return {
      revision => '$Revision: eff9afda3723 $',
      tags => [ qw(unstable hardware battery) ],
      commands => {
         capacity => [ ],
      },
   };
}

sub capacity {
   my $self = shift;

   my $base_file = '/sys/class/power_supply/BAT';

   my $battery_hash = {};
   my $count = 0;
   while (-f "$base_file$count/capacity") {
      my $data = $self->read("$base_file$count/capacity") or next;
      chomp($data);

      my $this = sprintf("battery_%02d", $count);
      $battery_hash->{$this} = {
         battery => $count,
         capacity => $data,
      };

      $count++;
   }

   return $battery_hash;
}

1;

__END__

=head1 NAME

Metabrik::Hardware::Battery - hardware::battery Brik

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2014-2015, Patrice E<lt>GomoRE<gt> Auffret

You may distribute this module under the terms of The BSD 3-Clause License.
See LICENSE file in the source distribution archive.

=head1 AUTHOR

Patrice E<lt>GomoRE<gt> Auffret

=cut
