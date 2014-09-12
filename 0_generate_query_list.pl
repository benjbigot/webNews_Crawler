#!/usr/bin/perl -w
use strict;
use warnings;
use Getopt::Long;

######################
# $nameFile par expl. COMPLETE_10k.lst
# $timeFile par expl. etendu_tempo.all
# siteRule expl. alvinet

# $0 -name toBeSearched.lst -time timePeriod.lst -rule liberation -page 400 -out liste_requete.xml
# name: list of query ex: barack obama
# time: period for search: 2012-01-31 (YYYY-MM-DD)
# rule: news web site (only htt://www.liberation.fr, voxalead and alvinet are supported)
# page: number of returned pages
# out:  output file name (xml)

# the output is a list of queries (see queryList.xml )

######################

# == variables == #
my $nameFile   = '';
my $timeFile   = '';
my $siteRule   = '';
my $nbOfPage   = 0 ;
my $outputFile = '';
my $help       = 0;
my $man        = 0;



my $options = GetOptions(	    "name=s"        => \$nameFile   ,  # file containing a list of queries in a basic format
                                "time=s"        => \$timeFile   ,  # file containing a list of time stamp
                                "rule=s"    	=> \$siteRule   ,  # alvinet liberation voxalead
                                "page=i"        => \$nbOfPage   ,  # number of returned addesses
                                "out=s"         => \$outputFile ,  # output file containing the patterns
                                "help|?"        => \$help       ,  # get help
                                "man"           => \$man       );  # get man


# ___________ main ____________ #

# checking if files exist
if ((! -e $nameFile) or ( ! -e $timeFile) ) {
	die "check input, exiting now\n";
}


# checking source format
if ( ( lc($siteRule) ne 'alvinet' ) and ( lc($siteRule) ne 'voxalead' ) and ( lc($siteRule) ne 'liberation' )){
	die "check site rule\n";
}

# checking nb of page
if ($nbOfPage <= 0 ){
	die "check returned page number\n";
}

# checking ouput file
if (-e $outputFile){
	my $check = 'y';
	print "warning output file: $outputFile already exists. do you want to replace [y/n] then press <Enter> ? ";
	$check = lc(<>) ;
	chomp($check);
	#~ print "$check\n";
	if ( $check ne 'y'){
		die "exiting..\n";
	}
}
	
# ____ loading name and time files ____ #

open(N, $nameFile) or die "check $nameFile\n";
my @listName = <N>; chomp(@listName);
close(N);

open(T, $timeFile) or die "check $timeFile\n";
my @listTime = <T>; chomp(@listTime);
close(T);


my @outputSeq ;
my $idQuery = 0 ;
foreach my $name (@listName){
	foreach my $time (@listTime){
		next if ($time =~ m/^\#/);
		push @outputSeq, "<query id=\"$idQuery\" source=\"$siteRule\" pattern=\"". join('+', split(/ /, lc($name))) . "\" startY=\"". (split(/\-/,(split(/ /, $time))[0]))[0] ."\" startM=\"".(split(/\-/,(split(/ /, $time))[0]))[1]."\" startD=\"".(split(/\-/,(split(/ /, $time))[0]))[2]."\" endY=\"".(split(/\-/,(split(/ /, $time))[1]))[0]."\" endM=\"".(split(/\-/,(split(/ /, $time))[1]))[1]."\" endD=\"".(split(/\-/,(split(/ /, $time))[1]))[2]. "\" nbLink=\"$nbOfPage\" key=\"". join('_', split(/ /, uc($name))) ."\"></query>";
		$idQuery++;
	}	
}

# ____ printing outFile ___ #

print "writting output...\n";
open(OUT, "> $outputFile") or die "problem with $outputFile\n";
print OUT '<?xml version="1.0" encoding="UTF-8"?>'."\n";
print OUT '<querySeq>'."\n";
foreach (@outputSeq){
	print OUT $_."\n";
}
print OUT '</querySeq>'."\n";
close(OUT);


