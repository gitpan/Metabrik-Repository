#
# $Id: Read.pm,v eff9afda3723 2015/01/04 12:34:23 gomor $
#
# file::read Brik
#
package Metabrik::File::Read;
use strict;
use warnings;

use base qw(Metabrik);

sub brik_properties {
   return {
      revision => '$Revision: eff9afda3723 $',
      tags => [ qw(unstable file) ],
      attributes => {
         input => [ qw(file) ],
         encoding => [ qw(utf8|ascii) ],
         fd => [ qw(file_descriptor) ],
         as_array => [ qw(0|1) ],
      },
      attributes_default => {
         as_array => 0,
      },
      commands => {
         open => [ qw(file|OPTIONAL) ],
         close => [ ],
         readall => [ ],
         read_until_blank_line => [ ],
      },
   };
}

sub brik_use_properties {
   my $self = shift;

   return {
      attributes_default => {
         input => $self->global->input,
         encoding => $self->global->encoding,
      },
   };
}

sub open {
   my $self = shift;
   my ($input) = @_;

   $input ||= $self->input;
   if (! -f $input) {
      return $self->log->error("open: file [$input] not found");
   }

   my $r;
   my $out;
   my $encoding = $self->encoding || 'ascii';
   if ($encoding eq 'ascii') {
      $r = open($out, '<', $input);
   }
   else {
      $r = open($out, "<$encoding", $input);
   }
   if (! defined($r)) {
      return $self->log->error("open: open: file [$input]: $!");
   }

   return $self->fd($out);
}

sub close {
   my $self = shift;

   if (defined($self->fd)) {
      close($self->fd);
   }

   return 1;
}

sub readall {
   my $self = shift;

   my $fd = $self->fd;
   if (! defined($fd)) {
      return $self->log->error($self->brik_help_run('open'));
   }

   if ($self->as_array) {
      my @out = ();
      while (<$fd>) {
         chomp;
         push @out, $_;
      }
      return \@out;
   }
   else {
      my $out = '';
      while (<$fd>) {
         $out .= $_;
      }
      return $out;
   }

   return;
}

sub read_until_blank_line {
   my $self = shift;

   my $fd = $self->fd;
   if (! defined($fd)) {
      return $self->log->error($self->brik_help_run('open'));
   }

   if ($self->as_array) {
      my @out = ();
      while (<$fd>) {
         last if /^\s*$/;
         chomp;
         push @out, $_;
      }
      return \@out;
   }
   else {
      my $out = '';
      while (<$fd>) {
         last if /^\s*$/;
         $out .= $_;
      }
      return $out;
   }

   return;
}

1;

__END__

=head1 NAME

Metabrik::File::Read - file::read Brik

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2014-2015, Patrice E<lt>GomoRE<gt> Auffret

You may distribute this module under the terms of The BSD 3-Clause License.
See LICENSE file in the source distribution archive.

=head1 AUTHOR

Patrice E<lt>GomoRE<gt> Auffret

=cut
