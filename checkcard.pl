#!/usr/bin/perl -w

my $fifofile = "/root/door_cmd.fifo";
my %validcards;

while (<>)
{ 
  my ($cardid,$name)= split /\s+/,$_;
  $validcards{$cardid}=$name;
};

my $currentcard=0;
while (sleep 1)
{
  my $card=`/usr/bin/opensc-tool --serial 2>/dev/null`;
  $card =~ s/[^0-9A-F]//g; 
  $card = substr($card,0,32);
  if ($card eq $currentcard)
	{ next; }
  else 
  	{$currentcard=$card;}
  if ($validcards{$card})
  {
    if( -p $fifofile)
    {
      open(my $fifo,"> $fifofile");
      print $fifo "toggle "."Card ".$validcards{$card}."\n";
      close($fifo);  
    }
  } else {
    print "Card did not match $card\n";
  }
}
