#!/usr/bin/perl -w
#
# kmer_count_fasta_top50.pl
#
#  The purpose of this script is to read-in a FASTA file line-
#  by-line and record every kmer found as defined by the user.
#  All kmers are recorded and quantified, with several metrics
#  reported after the FASTA has been fully transversed.

#  Usage:     kmer_count_fasta_top50.pl <FASTA file> <kmer>
#
# Charles Chiu, July 2017
#

#---- STEP1: build a hash with all kmers from the reads ----#
$position = 0;
$reads = 0;
open(FASTA,$ARGV[0]) || die("Can't open the FASTA file.");
while(<FASTA>)
{
    $position++;
        if($position == 2)
        {
	    $reads++;
                $_ =~ s/\n//;
	    for($i=0; $i<=(length($_)-$ARGV[1]); $i++)
	    {
		$kmer = substr($_, $i, $ARGV[1]);
		if(not defined $HASH{$kmer})
		{
		    $HASH{$kmer} = 1;
		}
                        else
                        {
			    $HASH{$kmer} += 1;
                        }
	    }
        }
        if($position == 2)
	{
            $position = 0;
        }
}
close(FASTA);

#---- STEP2: scan through the hash to calculate metrics ----#
$count = 0;
$running_total = 0;
$top_50 = "";
$bottom_5 = "";
$at_10 = "";
$at_100 = "";
$at_1000 = "";

foreach (sort { $HASH{$b} <=> $HASH{$a} } keys(%HASH) )
{
    $count++;
    $running_total += $HASH{$_};
        if($count <= 50)
        {
	    $top_50 .= "$HASH{$_}\t$_\n";
        }
        if($count == 10)
        {
	    $at_10 = $running_total;
        }
        if($count == 100)
        {
	    $at_100 = $running_total;
        }
        if($count == 1000)
        {
	    $at_1000 = $running_total;
        }
#        if($count == 10000)
#        {
#	    $at_10000 = $running_total;
#        }
}
for($q=-1; $q>=-5; $q--)
{
    $bottom_key = (sort { $HASH{$b} <=> $HASH{$a} } keys(%HASH))[$q];
    $bottom_5 .= "$HASH{$bottom_key}\t$bottom_key\n";
}

#---- STEP3: report the metrics ----#
print "Used $0 to find kmer size $ARGV[1] metrics\n";
print "Reads file: $ARGV[0]\n\n";
print "Total number of reads: $reads\n";
print "Total number of kmers: ".(keys %HASH)."\n\n";
#print "Top 10 kmers combined:       $at_10/$running_total:  ".sprintf("%.2f", (($at_10/$running_total)*100))."% of all kmers\n";
#print "Top 100 kmers combined:      $at_100/$running_total:  ".sprintf("%.2f", (($at_100/$running_total)*100))."% of all kmers\n";
#print "Top 1000 kmers combined:     $at_1000/$running_total:  ".sprintf("%.2f", (($at_1000/$running_total)*100))."% of all kmers\n";
#print "Top 10000 kmers combined:    $at_10000/$running_total:  ".sprintf("%.2f", (($at_10000/$running_total)*100))."% of all kmers\n";
print "\nMost common 50 kmers:\n$top_50\nLeast common 5 kmers:\n$bottom_5\n";
