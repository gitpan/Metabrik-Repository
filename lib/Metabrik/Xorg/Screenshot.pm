#
# $Id: Screenshot.pm,v eff9afda3723 2015/01/04 12:34:23 gomor $
#
# xorg::screenshot Brik
#
package Metabrik::Xorg::Screenshot;
use strict;
use warnings;

use base qw(Metabrik::Shell::Command);

sub brik_properties {
   return {
      revision => '$Revision: eff9afda3723 $',
      tags => [ qw(unstable screenshot) ],
      attributes => {
         output => [ qw(file) ],
      },
      attributes_default => {
         output => 'screenshot.png',
      },
      commands => {
         active_window => [ qw(output_file|OPTIONAL) ],
         full_screen => [ qw(output_file|OPTIONAL) ],
      },
      require_binaries => {
         'scrot' => [ ],
      },
   };
}

sub active_window {
   my $self = shift;
   my ($output) = @_;

   $output ||= $self->output;

   $self->log->verbose("active_window: saving to file [$output]");

   my $cmd = "scrot --focused --border $output";
   $self->system($cmd);

   return $output;
}

sub full_screen {
   my $self = shift;
   my ($output) = @_;

   $output ||= $self->output;

   $self->log->verbose("full_screen: saving to file [$output]");

   my $cmd = "scrot $output";
   $self->system($cmd);

   return $output;
}

1;

__END__

=head1 NAME

Metabrik::Xorg::Screenshot - xorg::screenshot Brik

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2014-2015, Patrice E<lt>GomoRE<gt> Auffret

You may distribute this module under the terms of The BSD 3-Clause License.
See LICENSE file in the source distribution archive.

=head1 AUTHOR

Patrice E<lt>GomoRE<gt> Auffret

=cut
