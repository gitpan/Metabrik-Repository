#
# $Id: Keystore.pm,v eff9afda3723 2015/01/04 12:34:23 gomor $
#
# database::keystore Brik
#
package Metabrik::Database::Keystore;
use strict;
use warnings;

use base qw(Metabrik::File::Text);

sub brik_properties {
   return {
      revision => '$Revision: eff9afda3723 $',
      tags => [ qw(unstable database keystore) ],
      attributes => {
         db => [ qw(keystore_db) ],
      },
      commands => {
         search => [ qw(pattern) ],
      },
      require_modules => {
         'Metabrik::Crypto::Aes' => [ ],
      },
   };
}

sub search {
   my $self = shift;
   my ($pattern) = @_;

   if (! defined($self->db)) {
      return $self->log->error($self->brik_help_set('db'));
   }

   if (! defined($pattern)) {
      return $self->log->error($self->brik_help_run('search'));
   }

   my $read = $self->read($self->db)
      or return $self->log->error("search: read failed");

   my $crypto_aes = Metabrik::Crypto::Aes->new_from_brik($self);

   my $decrypted = $crypto_aes->decrypt($read)
      or return $self->log->error("search: decrypt failed");

   my @results = ();
   my @lines = split(/\n/, $decrypted);
   for (@lines) {
      push @results, $_ if /$pattern/i;
   }

   return \@results;
}

1;

__END__

=head1 NAME

Metabrik::Database::Keystore - database::keystore Brik

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2014-2015, Patrice E<lt>GomoRE<gt> Auffret

You may distribute this module under the terms of The BSD 3-Clause License.
See LICENSE file in the source distribution archive.

=head1 AUTHOR

Patrice E<lt>GomoRE<gt> Auffret

=cut
