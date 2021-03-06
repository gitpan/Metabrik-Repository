#
# $Id: Ssh.pm,v eff9afda3723 2015/01/04 12:34:23 gomor $
#
# identify::ssh Brik
#
package Metabrik::Identify::Ssh;
use strict;
use warnings;

use base qw(Metabrik);

sub brik_properties {
   return {
      revision =>  '$Revision: eff9afda3723 $',
      tags => [ qw(unstable ssh) ],
      attributes => {
         banner => [ qw(string) ],
      },
      commands => {
         parsebanner => [ ],
      },
   };
}

sub parsebanner {
   my $self = shift;

   if (! defined($self->banner)) {
      return $self->log->error($self->brik_help_set('banner'));
   }

   my $banner = $self->banner;

   # From most specific to less specific
   my $data = [
      [
         '^SSH-(\d+\.\d+)-OpenSSH_(\d+\.\d+\.\d+)(p\d+) Ubuntu-(2ubuntu2)$' => {
            ssh_protocol_version => '$1',
            ssh_product_version => '$2',
            ssh_product_feature_portable => '$3',
            ssh_os_distribution_version => '$4',
            ssh_product => 'OpenSSH',
            ssh_os => 'Linux',
            ssh_os_distribution => 'Ubuntu',
         },
      ],
      [
         '^SSH-(\d+\.\d+)-OpenSSH_(\d+\.\d+)_(\S+) (\S+)$' => {
            ssh_protocol_version => '$1',
            ssh_product_version => '$2',
            ssh_product_feature_portable => '$3',
            ssh_product => 'OpenSSH',
            ssh_extra => '$4',
         },
      ],
      [
         '^SSH-(\d+\.\d+)(.*)$' => {
            ssh_protocol_version => '$1',
            ssh_product => 'UNKNOWN',
            ssh_extra => '$2',
         },
      ],
   ];

   my $result = {};
   for my $elt (@$data) {
      my $re = $elt->[0];
      my $info = $elt->[1];
      if ($banner =~ /$re/) {
         for my $k (keys %$info) {
            $result->{$k} = eval($info->{$k}) || $info->{$k};
         }
         last;
      }
   }

   return $result;
}

1;

__END__

=head1 NAME

Metabrik::Identify::Ssh - identify::ssh Brik

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2014-2015, Patrice E<lt>GomoRE<gt> Auffret

You may distribute this module under the terms of The BSD 3-Clause License.
See LICENSE file in the source distribution archive.

=head1 AUTHOR

Patrice E<lt>GomoRE<gt> Auffret

=cut
