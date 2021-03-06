#
# $Id: Write.pm,v eff9afda3723 2015/01/04 12:34:23 gomor $
#
# file::write Brik
#
package Metabrik::File::Write;
use strict;
use warnings;

use base qw(Metabrik);

sub brik_properties {
   return {
      revision => '$Revision: eff9afda3723 $',
      tags => [ qw(unstable file) ],
      attributes => {
         output => [ qw(file) ],
         append => [ qw(0|1) ],
         overwrite => [ qw(0|1) ],
         encoding => [ qw(utf8|ascii) ],
         fd => [ qw(file_descriptor) ],
         unbuffered => [ qw(0|1) ],
      },
      attributes_default => {
         append => 1,
         overwrite => 0,
         unbuffered => 0,
      },
      commands => {
         open => [ qw(file|OPTIONAL) ],
         write => [ qw($data|$data_ref|$data_list) ],
         close => [ ],
      },
   };
}

sub brik_use_properties {
   my $self = shift;

   # encoding: see `perldoc Encode::Supported' for other types
   return {
      attributes_default => {
         output => $self->global->output || '/tmp/output.txt',
         encoding => $self->global->encoding || 'utf8',
      },
   };
}

sub open {
   my $self = shift;
   my ($output) = @_;

   $output ||= $self->output;
   if (! defined($output)) {
      return $self->log->error($self->brik_help_set('output'));
   }

   my $encoding = $self->encoding;
   if ($encoding eq 'ascii') {
      $encoding = '';
   }

   my $out;
   if ($self->append) {
      my $r = open($out, ">>$encoding", $output);
      if (! defined($r)) {
         return $self->log->error("open: open: append file [$output]: $!");
      }
   }
   elsif (! $self->append && $self->overwrite) {
      my $r = open($out, ">$encoding", $output);
      if (! defined($r)) {
         return $self->log->error("open: open: write file [$output]: $!");
      }
   }
   elsif (! $self->append && ! $self->overwrite && -f $self->output) {
      $self->log->info("open: we will not overwrite an existing file. See:");
      return $self->log->error($self->brik_help_set('overwrite'));
   }

   if ($self->unbuffered) {
      my $previous_default = select(STDOUT);
      select($out);
      $|++;
      select($previous_default);          
   }

   return $self->fd($out);
}

sub close {
   my $self = shift;

   if (defined($self->fd)) {
      close($self->fd);
      $self->fd(undef);
   }

   return 1;
}

sub write {
   my $self = shift;
   my ($data) = @_;

   if (! defined($data)) {
      return $self->log->error($self->brik_help_run('write'));
   }

   $self->debug && $self->log->debug("write: data[$data]");

   my $fd = $self->fd;
   if (! defined($fd)) {
      return $self->log->error($self->brik_help_run('open'));
   }

   if (ref($data) eq 'ARRAY') {
      for my $this (@$data) {
         print $fd $this."\n";
      }
   }
   else {
      ref($data) eq 'SCALAR' ? print $fd $$data : print $fd $data;
   }

   return $data;
}

1;

__END__

=head1 NAME

Metabrik::File::Write - file::write Brik

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2014-2015, Patrice E<lt>GomoRE<gt> Auffret

You may distribute this module under the terms of The BSD 3-Clause License.
See LICENSE file in the source distribution archive.

=head1 AUTHOR

Patrice E<lt>GomoRE<gt> Auffret

=cut
