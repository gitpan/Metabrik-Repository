#
# $Id: Jpg.pm,v eff9afda3723 2015/01/04 12:34:23 gomor $
#
# image::jpg Brik
#
package Metabrik::Image::Jpg;
use strict;
use warnings;

use base qw(Metabrik::Shell::Command);

sub brik_properties {
   return {
      revision => '$Revision: eff9afda3723 $',
      tags => [ qw(unstable image jpg jpeg) ],
      commands => {
         info => [ qw(image.jpg) ],
      },
      require_binaries => {
         'jhead' => [ ],  # apt-get install jhead
      },
   };
}

sub info {
   my $self = shift;
   my ($image) = @_;

   if (! defined($image)) {
      return $self->log->error($self->brik_help_run('info'));
   }

   my $cmd = "jhead \"$image\"";
   my $out = $self->capture($cmd);

   my $info = {};
   for my $this (@$out) {
      my ($key, $val) = $this =~ /^(.*?)\s+:\s+(.*)$/;
      $self->debug && $self->log->debug("info: key [$key] val [$val]");
      $key = lc($key);
      $key =~ s/\s+/_/g;
      $info->{$key} = $val;
   }

   return $info;
}

1;

__END__

=head1 NAME

Metabrik::Image::Jpg - image::jpg Brik

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2014-2015, Patrice E<lt>GomoRE<gt> Auffret

You may distribute this module under the terms of The BSD 3-Clause License.
See LICENSE file in the source distribution archive.

=head1 AUTHOR

Patrice E<lt>GomoRE<gt> Auffret

=cut
