#
# $Id: Search.pm,v eff9afda3723 2015/01/04 12:34:23 gomor $
#
# brik::search Brik
#
package Metabrik::Brik::Search;
use strict;
use warnings;

use base qw(Metabrik);

sub brik_properties {
   return {
      revision => '$Revision: eff9afda3723 $',
      tags => [ qw(unstable main brik search) ],
      commands => {
         all => [ ],
         string => [ qw(string) ],
         tag => [ qw(Tag) ],
         not_tag => [ qw(Tag) ],
         used => [ ],
         not_used => [ ],
      },
   };
}

sub all {
   my $self = shift;

   my $context = $self->context;
   my $status = $context->status;

   my $total = 0;
   my $count = 0;
   $self->log->info("Used:");
   for my $brik (@{$status->{used}}) {
      my $tags = $context->used->{$brik}->brik_tags;
      $self->log->info(sprintf("   %-20s [%s]", $brik, join(', ', @$tags)));
      $count++;
      $total++;
   }
   $self->log->info("Count: $count");

   $count = 0;
   $self->log->info("Not used:");
   for my $brik (@{$status->{not_used}}) {
      my $tags = $context->not_used->{$brik}->brik_tags;
      $self->log->info(sprintf("   %-20s [%s]", $brik, join(', ', @$tags)));
      $count++;
      $total++;
   }
   $self->log->info("Count: $count");

   return $total;
}

sub string {
   my $self = shift;
   my ($string) = @_;

   if (! defined($string)) {
      return $self->log->error($self->brik_help_run('string'));
   }

   my $context = $self->context;
   my $status = $context->status;

   my $total = 0;
   $self->log->info("Used:");
   for my $brik (@{$status->{used}}) {
      next unless $brik =~ /$string/;
      my $tags = $context->used->{$brik}->brik_tags;
      $self->log->info(sprintf("   %-20s [%s]", $brik, join(', ', @$tags)));
      $total++;
   }

   $self->log->info("Not used:");
   for my $brik (@{$status->{not_used}}) {
      next unless $brik =~ /$string/;
      my $tags = $context->not_used->{$brik}->brik_tags;
      $self->log->info(sprintf("   %-20s [%s]", $brik, join(', ', @$tags)));
      $total++;
   }

   return $total;
}

sub tag {
   my $self = shift;
   my ($tag) = @_;

   if (! defined($tag)) {
      return $self->log->error($self->brik_help_run('tag'));
   }

   my $context = $self->context;
   my $status = $context->status;

   my $total = 0;
   $self->log->info("Used:");
   for my $brik (@{$status->{used}}) {
      my $tags = $context->used->{$brik}->brik_tags;
      push @$tags, 'used';
      for my $this (@$tags) {
         next unless $this eq $tag;
         $self->log->info(sprintf("   %-20s [%s]", $brik, join(', ', @$tags)));
         $total++;
         last;
      }
   }

   $self->log->info("Not used:");
   for my $brik (@{$status->{not_used}}) {
      my $tags = $context->not_used->{$brik}->brik_tags;
      push @$tags, 'not_used';
      for my $this (@$tags) {
         next unless $this eq $tag;
         $self->log->info(sprintf("   %-20s [%s]", $brik, join(', ', @$tags)));
         $total++;
         last;
      }
   }


   return $total;
}

sub not_tag {
   my $self = shift;
   my ($tag) = @_;

   if (! defined($tag)) {
      return $self->log->error($self->brik_help_run('not_tag'));
   }

   my $context = $self->context;
   my $status = $context->status;

   my $total = 0;
   $self->log->info("Used:");
   for my $brik (@{$status->{used}}) {
      my $tags = $context->used->{$brik}->brik_tags;
      push @$tags, 'used';
      for my $this (@$tags) {
         next if $this eq $tag;
         $self->log->info(sprintf("   %-20s [%s]", $brik, join(', ', @$tags)));
         $total++;
         last;
      }
   }

   $self->log->info("Not used:");
   for my $brik (@{$status->{not_used}}) {
      my $tags = $context->not_used->{$brik}->brik_tags;
      push @$tags, 'not_used';
      for my $this (@$tags) {
         next if $this eq $tag;
         $self->log->info(sprintf("   %-20s [%s]", $brik, join(', ', @$tags)));
         $total++;
         last;
      }
   }

   return $total;
}

sub used {
   my $self = shift;

   return $self->tag('used');
}

sub not_used {
   my $self = shift;

   return $self->not_tag('used');
}

1;

__END__

=head1 NAME

Metabrik::Brik::Search - brik::search Brik

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2014-2015, Patrice E<lt>GomoRE<gt> Auffret

You may distribute this module under the terms of The BSD 3-Clause License.
See LICENSE file in the source distribution archive.

=head1 AUTHOR

Patrice E<lt>GomoRE<gt> Auffret

=cut
