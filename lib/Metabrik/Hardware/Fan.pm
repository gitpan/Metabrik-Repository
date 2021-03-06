#
# $Id: Fan.pm,v eff9afda3723 2015/01/04 12:34:23 gomor $
#
# harware::fan Brik
#
package Metabrik::Hardware::Fan;
use strict;
use warnings;

use base qw(Metabrik::File::Text);

sub brik_properties {
   return {
      revision => '$Revision: eff9afda3723 $',
      tags => [ qw(unstable hardware fan) ],
      commands => {
         info => [ ],
         #status => [ ],
         #speed => [ ],
         #level => [ ],
      },
   };
}

sub info {
   my $self = shift;

   my $base_file = '/proc/acpi/ibm/fan';

   if (! -f $base_file) {
      return $self->log->error("info: cannot find file [$base_file]");
   }

   my $data = $self->read($base_file)
      or return $self->log->error("info: read failed");
   chomp($data);

   my $info_hash = {};

   my @lines = split(/\n/, $data);
   for my $line (split(/\n/, $data)) {
      my ($name, $value) = $line =~ /^(\S+):\s+(.*)$/;

      if ($name eq 'commands') {
         push @{$info_hash->{$name}}, $value;
      }
      else {
         $info_hash->{$name} = $value;
      }
   }

   return $info_hash;
}

1;

__END__

=head1 NAME

Metabrik::Hardware::Fan - hardware::fan Brik

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2014-2015, Patrice E<lt>GomoRE<gt> Auffret

You may distribute this module under the terms of The BSD 3-Clause License.
See LICENSE file in the source distribution archive.

=head1 AUTHOR

Patrice E<lt>GomoRE<gt> Auffret

=cut
