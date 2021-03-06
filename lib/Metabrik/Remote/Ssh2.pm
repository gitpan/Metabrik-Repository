#
# $Id: Ssh2.pm,v eff9afda3723 2015/01/04 12:34:23 gomor $
#
# remote::ssh2 Brik
#
package Metabrik::Remote::Ssh2;
use strict;
use warnings;

use base qw(Metabrik);

sub brik_properties {
   return {
      revision => '$Revision: eff9afda3723 $',
      tags => [ qw(unstable remote ssh ssh2) ],
      attributes => {
         hostname => [ qw(hostname) ],
         port => [ qw(integer) ],
         username => [ qw(username) ],
         publickey => [ qw(file) ],
         privatekey => [ qw(file) ],
         ssh2 => [ qw(Net::SSH2) ],
         _channel => [ qw(INTERNAL) ],
      },
      commands => {
         connect => [ ],
         cat => [ qw(file) ],
         exec => [ qw(command) ],
         readall => [ ],
         readline => [ ],
         readlineall => [ ],
         load => [ qw(file) ],
         listfiles => [ qw(glob) ],
         disconnect => [ ],
      },
      require_modules => {
         'IO::Scalar' => [ ],
         'Net::SSH2' => [ ],
      },
   };
}

sub brik_use_properties {
   my $self = shift;

   return {
      attributes_default => {
         hostname => $self->global->hostname || 'localhost',
         port => 22,
         username => $self->global->username || 'root',
      },
   };
}

sub connect {
   my $self = shift;

   if (defined($self->ssh2)) {
      return $self->log->verbose("connect: already connected");
   }

   if (! defined($self->hostname)) {
      return $self->log->error($self->brik_help_set('hostname'));
   }

   if (! defined($self->port)) {
      return $self->log->error($self->brik_help_set('port'));
   }

   if (! defined($self->username)) {
      return $self->log->error($self->brik_help_set('username'));
   }

   if (! defined($self->publickey)) {
      return $self->log->error($self->brik_help_set('publickey'));
   }

   if (! defined($self->privatekey)) {
      return $self->log->error($self->brik_help_set('privatekey'));
   }

   my $ssh2 = Net::SSH2->new;
   my $ret = $ssh2->connect($self->hostname, $self->port);
   if (! $ret) {
      return $self->log->error("connect: can't connect via SSH2: $!");
   }

   $ret = $ssh2->auth(
      username => $self->username,
      publickey => $self->publickey,
      privatekey => $self->privatekey,
   );
   if (! $ret) {
      return $self->log->error("connect: can't authenticate via SSH2: $!");
   }

   $self->log->verbose("connect: ssh2 connected to [".$self->hostname."]");

   return $self->ssh2($ssh2);
}

sub disconnect {
   my $self = shift;

   my $ssh2 = $self->ssh2;

   if (! defined($ssh2)) {
      return $self->log->error($self->brik_help_run('connect'));
   }

   my $r = $ssh2->disconnect;

   $self->ssh2(undef);
   $self->_channel(undef);

   return $r;
}

sub exec {
   my $self = shift;
   my ($cmd) = @_;

   my $ssh2 = $self->ssh2;

   if (! defined($ssh2)) {
      return $self->log->error($self->brik_help_run('connect'));
   }

   if (! defined($cmd)) {
      return $self->log->error($self->brik_help_run('exec'));
   }

   $self->debug && $self->log->debug("exec: cmd [$cmd]");

   my $channel = $ssh2->channel;
   if (! defined($channel)) {
      return $self->log->error("exec: channel creation error");
   }

   $channel->exec($cmd)
      or return $self->log->error("exec: can't execute command [$cmd]: $!");

   return $self->_channel($channel);
}

sub readline {
   my $self = shift;

   my $ssh2 = $self->ssh2;
   if (! defined($ssh2)) {
      return $self->log->error($self->brik_help_run('connect'));
   }

   my $channel = $self->_channel;
   if (! defined($channel)) {
      return $self->log->info("readline: create a channel first");
   }

   my $read = '';
   my $count = 1;
   while (1) {
      my $char = '';
      my $rc = $channel->read($char, $count);
      if ($rc > 0) {
         #print "read[$char]\n";
         #print "returned[$c]\n";
         $read .= $char;

         last if $char eq "\n";
      }
      elsif ($rc < 0) {
         return $self->log->error("read: error [$rc]");
      }
      else {
         last;
      }
   }

   return $read;
}

sub readlineall {
   my $self = shift;

   my $ssh2 = $self->ssh2;
   if (! defined($ssh2)) {
      return $self->log->error($self->brik_help_run('connect'));
   }

   my $channel = $self->_channel;
   if (! defined($channel)) {
      return $self->log->info("readlineall: create a channel first");
   }

   my $read = $self->readall;
   if (! defined($read)) {
      return $self->log->error("readlineall: readall error");
   }

   my @lines = split(/\n/, $read);

   return \@lines;
}

sub readall {
   my $self = shift;

   my $ssh2 = $self->ssh2;
   if (! defined($ssh2)) {
      return $self->log->error($self->brik_help_run('connect'));
   }

   my $channel = $self->_channel;
   if (! defined($channel)) {
      return $self->log->info("readall: create a channel first");
   }

   my $read = '';
   my $count = 1024;
   while (1) {
      my $buf = '';
      my $rc = $channel->read($buf, $count);
      if ($rc > 0) {
         #print "read[$buf]\n";
         #print "returned[$c]\n";
         $read .= $buf;

         last if $rc < $count;
      }
      elsif ($rc < 0) {
         return $self->log->error("read: error [$rc]");
      }
      else {
         last;
      }
   }

   return $read;
}

sub listfiles {
   my $self = shift;
   my ($glob) = @_;

   my $channel = $self->exec("ls $glob 2> /dev/null");
   if (! defined($channel)) {
      return $self->log->error("listfiles: exec error");
   }

   my $read = $self->readall;
   if (! defined($read)) {
      return $self->log->error("listfiles: readall error");
   }

   my @files = split(/\n/, $read);

   return \@files;
}

sub cat {
   my $self = shift;
   my ($file) = @_;

   if (! defined($self->ssh2)) {
      return $self->log->error($self->brik_help_run('connect'));
   }

   if (! defined($file)) {
      return $self->log->error($self->brik_help_run('cat'));
   }

   my $channel = $self->exec('cat '.$file);
   if (! defined($channel)) {
      return $self->log->error("cat: channel for file [$file]");
   }

   return $self->_channel($channel);
}

sub load {
   my $self = shift;
   my ($file) = @_;

   if (! defined($self->ssh2)) {
      return $self->log->error($self->brik_help_run('connect'));
   }

   if (! defined($file)) {
      return $self->log->error($self->brik_help_run('load'));
   }

   my $ssh2 = $self->ssh2;

   my $io = IO::Scalar->new;

   $ssh2->scp_get($file, $io)
      or return $self->log->error("load: scp_get: $file");

   $io->seek(0, 0);

   my $buf = '';
   while (<$io>) {
      $buf .= $_;
   }

   return $buf;
}

sub brik_fini {
   my $self = shift;

   my $ssh2 = $self->ssh2;
   if (defined($ssh2)) {
      $ssh2->disconnect;
      $self->ssh2(undef);
      $self->_channel(undef);
   }

   return 1;
}

1;

__END__

=head1 NAME

Metabrik::Remote::Ssh2 - remote::ssh2 Brik

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2014-2015, Patrice E<lt>GomoRE<gt> Auffret

You may distribute this module under the terms of The BSD 3-Clause License.
See LICENSE file in the source distribution archive.

=head1 AUTHOR

Patrice E<lt>GomoRE<gt> Auffret

=cut
