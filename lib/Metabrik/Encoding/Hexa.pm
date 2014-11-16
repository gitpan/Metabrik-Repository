#
# $Id: Hexa.pm 360 2014-11-16 14:52:06Z gomor $
#
# encoding::hexa Brik
#
package Metabrik::Encoding::Hexa;
use strict;
use warnings;

use base qw(Metabrik);

sub brik_properties {
   return {
      revision => '$Revision: 360 $',
      tags => [ qw(unstable encode decode hex) ],
      attributes => {
         with_x => [ ],
      },
      attributes_default => {
         with_x => 1,
      },
      commands => {
         encode => [ qw($data) ],
         decode => [ qw($data) ],
         is_hexa => [ qw($data) ],
      },
      require_modules => {
         'MIME::Base64' => [ ],
      },
   };
}

sub encode {
   my $self = shift;
   my ($data) = @_;

   if (! defined($data)) {
      return $self->log->error($self->brik_help_run('encode'));
   }

   my $encoded = unpack('H*', $data);

   if ($self->with_x) {
      $encoded =~ s/(..)/\\x$1/g;
   }

   return $encoded;
}

sub decode {
   my $self = shift;
   my ($data) = @_;

   if (! defined($data)) {
      return $self->log->error($self->brik_help_run('decode'));
   }

   # Keep only hex-compliant characters
   $data =~ s/[^a-fA-F0-9]//g;

   my $decoded = pack('H*', $data);

   return $decoded;
}

sub is_hexa {
   my $self = shift;
   my ($data) = @_;

   my $this = lc($data);
   $this =~ s/\\x//g;

   if ($this =~ /^[a-f0-9]+$/) {
      return 1;
   }

   return 0;
}

1;

__END__

=head1 NAME

Metabrik::Encoding::Hexa - encoding::hexa Brik

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2014, Patrice E<lt>GomoRE<gt> Auffret

You may distribute this module under the terms of The BSD 3-Clause License.
See LICENSE file in the source distribution archive.

=head1 AUTHOR

Patrice E<lt>GomoRE<gt> Auffret

=cut