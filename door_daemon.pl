#!/usr/bin/perl -w
use IO::Handle;

my $fifofile = "/root/door_cmd.fifo";
unless( -p $fifofile) 
{
  unlink $fifofile;
  system("mkfifo -m 600 $fifofile") && die "Can't mkfifo $fifofile: $!";
  system("setfacl -m u:otti:rw $fifofile");
  system("setfacl -m u:asterisk:rw $fifofile");
}

open($logfile,'>>/var/log/tuer.log');
$logfile->autoflush(1);
print $logfile localtime()." Door Daemon started\n";

print `/root/ledoff`;
system('ln -sf /var/www/indexclosed.html /var/www/index.html');
my $tuer=0;
my $who="";

sub handler
{
  #local($sig) = @_;
  print $logfile localtime()." Door Daemon stopped\n";
  close $logfile;
  close $fifo if (defined $fifo);
  exit(0);
}

$SIG{'INT'} = 'handler';
$SIG{'QUIT'} = 'handler';
$SIG{'KILL'} = 'handler';

while (1)
{
  open($fifo,"< $fifofile");
	while (my $cmd = <$fifo>)
	{
	  if ($cmd =~ /^(\w+)\s*(.*)$/)
	  {
	    $who=$2;
	    if    ($1 eq "open")   {$tuer=1;}
	    elsif ($1 eq "close")  {$tuer=0;}
	    elsif ($1 eq "toggle") {$tuer=not $tuer;}
	  }

	  if ($tuer)
	  {
	    print `/root/ledon`;
	    system('ln -sf /var/www/indexopen.html /var/www/index.html');
	    print $logfile localtime()." Door opened by $who\n";
	  } else {
	    print `/root/ledoff`;
	    system('ln -sf /var/www/indexclosed.html /var/www/index.html');
	    print $logfile localtime()." Door closed by $who\n";
	  }
	}
  close($fifo);
}
