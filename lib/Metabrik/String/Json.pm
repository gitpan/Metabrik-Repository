#
# $Id: Json.pm,v eff9afda3723 2015/01/04 12:34:23 gomor $
#
# string::json Brik
#
package Metabrik::String::Json;
use strict;
use warnings;

use base qw(Metabrik);

sub brik_properties {
   return {
      revision => '$Revision: eff9afda3723 $',
      tags => [ qw(unstable encode decode json) ],
      commands => {
         encode => [ qw($data_list|$data_hash) ],
         decode => [ qw($data) ],
      },
      require_modules => {
         'JSON::XS' => [ ],
      },
   };
}

sub encode {
   my $self = shift;
   my ($data) = @_;

   if (! defined($data)) {
      return $self->log->error($self->brik_help_run('encode'));
   }

   if (ref($data) ne 'ARRAY' && ref($data) ne 'HASH') {
      return $self->log->error("encode: you need to give data as an ARRAYREF or HASHREF");
   }

   my $encoded = JSON::XS::encode_json($data);

   return $encoded;
}

sub decode {
   my $self = shift;
   my ($data) = @_;

   if (! defined($data)) {
      return $self->log->error($self->brik_help_run('decode'));
   }

   my $decoded = JSON::XS::decode_json($data);

   return $decoded;
}

1;

__END__

=head1 NAME

Metabrik::String::Json - string::json Brik

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2014-2015, Patrice E<lt>GomoRE<gt> Auffret

You may distribute this module under the terms of The BSD 3-Clause License.
See LICENSE file in the source distribution archive.

=head1 AUTHOR

Patrice E<lt>GomoRE<gt> Auffret

=cut
