# expects as input a file ($fname.4rows) generated by grep -E  "variables\|VERIFICATION"  <log_file> >  $fname.2rows


my $vars_clauses = undef;
while(<>){
  my $line = $_;
  if($line =~ /clauses$/)
  {
    chomp $line;
    $line =~ s/variables,//;
    $line =~ s/clauses$//;
    $vars_clauses = $line;
  }
  elsif($line =~ /^VERIFICATION .\//)
  {
    next if !defined $vars_clauses;
    $line =~ s/^VERIFICATION //;
    chomp $line;
    print "$line  $vars_clauses\n"; 
  }
  else
  {
    die "malformed input: $_\n";
  }
}
