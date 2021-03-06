#
# $Id: Compress.pm,v eff9afda3723 2015/01/04 12:34:23 gomor $
#
# string::gzip Brik
#
package Metabrik::String::Compress;
use strict;
use warnings;

use base qw(Metabrik);

sub brik_properties {
   return {
      revision => '$Revision: eff9afda3723 $',
      tags => [ qw(unstable gzip gunzip uncompress compress) ],
      attributes => {
         data => [ qw($data) ],
         memory_limit => [ qw(integer) ],
      },
      attributes_default => {
         memory_limit => '1_000_000_000', # XXX: to implement
      },
      commands => {
         gunzip => [ qw($data) ],
         gzip => [ qw($data) ],
      },
      require_modules => {
         'Gzip::Faster' => [ ],
      },
   };
}

sub gunzip {
   my $self = shift;
   my ($data) = @_;

   if (! defined($data)) {
      return $self->log->error($self->brik_help_run('gunzip'));
   }

   $self->debug && $self->log->debug("gunzip: length[".length($data)."]");

   $self->debug && $self->log->debug("gunzip: starting");

   my $plain = Gzip::Faster::gunzip($data)
      or return $self->log->error("gunzip: error");

   $self->debug && $self->log->debug("gunzip: finished");

   $self->debug && $self->log->debug("gunzip: length[".length($plain)."]");

   return \$plain;
}

sub gzip {
   my $self = shift;
   my ($data) = @_;

   if (! defined($data)) {
      return $self->log->error($self->brik_help_run('gzip'));
   }

   my $gzipped = Gzip::Faster::gzip($data)
      or return $self->log->error("gzip: error");

   return \$gzipped;
}

1;

__END__

=head1 NAME

Metabrik::String::Compress - string::compress Brik

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2014-2015, Patrice E<lt>GomoRE<gt> Auffret

You may distribute this module under the terms of The BSD 3-Clause License.
See LICENSE file in the source distribution archive.

=head1 AUTHOR

Patrice E<lt>GomoRE<gt> Auffret

=cut
