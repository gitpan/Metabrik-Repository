#
# $Id: Aes.pm 360 2014-11-16 14:52:06Z gomor $
#
# crypto::aes Brik
#
package Metabrik::Crypto::Aes;
use strict;
use warnings;

use base qw(Metabrik);

sub brik_properties {
   return {
      revision => '$Revision: 360 $',
      tags => [ qw(unstable aes crypto) ],
      commands => {
         encrypt => [ qw($data) ],
         decrypt => [ qw($data) ],
      },
      #require_modules => {
         #'Crypt::CBC' => [ ],
         #'Crypt::OpenSSL::AES' => [ ],
      #},
      require_binaries => {
         'openssl' => [ ],
      },
   };
}

sub encrypt {
   my $self = shift;
   my ($data) = @_;

   if (! defined($data)) {
      return $self->log->error($self->brik_help_run('encrypt'));
   }

   #my $key = 'key';

   #my $cipher = Crypt::CBC->new(
      #-key => $key,
      #-cipher => 'Crypt::OpenSSL::AES',
   #) or return $self->log->error("cipher: $!");

   #my $crypted = $cipher->encrypt_hex($data);

   # Will only return hex encoded data
   my $crypted = `echo "$data" | openssl enc -e -a -aes-128-cbc`;

   return $crypted;
}

sub decrypt {
   my $self = shift;
   my ($data) = @_;

   if (! defined($data)) {
      return $self->log->error($self->brik_help_run('decrypt'));
   }

   #my $key = 'key';

   #my $cipher = Crypt::CBC->new(
      #-key => $key,
      #-cipher => 'Crypt::OpenSSL::AES',
   #) or return $self->log->error("cipher: $!");

   #my $decrypted = $cipher->decrypt_hex($data);

   $self->debug && $self->log->debug("echo \"$data\" | openssl enc -d -a -aes-128-cbc");

   # Will only return hex decoded data
   my $decrypted = `echo "$data" | openssl enc -d -a -aes-128-cbc`;

   return $decrypted;
}

1;

__END__

=head1 NAME

Metabrik::Crypto::Aes - crypto::aes Brik

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2014, Patrice E<lt>GomoRE<gt> Auffret

You may distribute this module under the terms of The BSD 3-Clause License.
See LICENSE file in the source distribution archive.

=head1 AUTHOR

Patrice E<lt>GomoRE<gt> Auffret

=cut
