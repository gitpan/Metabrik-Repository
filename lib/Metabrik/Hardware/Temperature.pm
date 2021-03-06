#
# $Id: Temperature.pm,v eff9afda3723 2015/01/04 12:34:23 gomor $
#
# hardware::temperature Brik
#
package Metabrik::Hardware::Temperature;
use strict;
use warnings;

use base qw(Metabrik::File::Text);

sub brik_properties {
   return {
      revision => '$Revision: eff9afda3723 $',
      tags => [ qw(unstable hardware temperature) ],
      commands => {
         cpu => [ ],
      },
   };
}

sub cpu {
   my $self = shift;

   my $file = "/sys/class/thermal/thermal_zone0/temp";
   if (! -f $file) {
      return $self->log->error("cpu: can't find file [$file]");
   }

   my $text = $self->read($file)
      or return $self->log->error("cpu: can't read file [$file]");

   if (length($text)) {
      chomp($text);
      if ($text =~ /^\d+$/) {
         return $text / 1000;
      }
   }

   return $self->log->error("cpu: invalid content in file [$file]");
}

1;

__END__

=head1 NAME

Metabrik::Hardware::Temperature - hardware::temperature Brik

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2015, Patrice E<lt>GomoRE<gt> Auffret

You may distribute this module under the terms of The BSD 3-Clause License.
See LICENSE file in the source distribution archive.

=head1 AUTHOR

Patrice E<lt>GomoRE<gt> Auffret

=cut
