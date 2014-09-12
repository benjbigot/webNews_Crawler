#!/usr/bin/perl -w
use strict;
use warnings;
use Getopt::Long;
use Cwd;
use Pod::Usage;
push(@INC, 'searchEngines');

# ==== specific rules for query strings edition === #
require 'ALVINET.pm';
require 'VOXALEAD.pm';
require 'LIBERATION.pm';



# ____ rule file request ____ #
my $ruleFile      = '' ;
my $outputFile    = '' ;
#~ my $voxaleadNeDir = '' ;
my %rules			   ;
my $man           = 0  ;
my $help          = 0  ;

#== command line request ==#
#~ my $siteLabel   = undef     ;
#~ my $pattern     = undef     ;
#~ my $date        = undef     ;
#~ my $outputFile  = undef     ;
#~ my $speakerID   = undef     ;
#~ my $nbOfPage    = 1         ;
#~ my $voxaleadNeDir= undef ;
#== gerenal options == #

my $options = GetOptions(	"rule=s"         => \$ruleFile   ,  # file containing a list of queries
							"linkOutFile=s"  => \$outputFile ,  # output directory for article 
                          	"help|?"         => \$help       ,  # get help
	                        "man"            => \$man       );  # get man
	                        
	                        #~ "voxaleadNE=s"   => \$voxaleadNeDir ,  # voxaleadNamedEntityFile 





#________ main ____________#

if ( ! -e $ruleFile){
	die " --ruleFile is not optional \n" ;
}
else{
	#___ loading rule file _____#
	# pour info le dernier faisait 160Mo #
	open(A, $ruleFile) or die "check $ruleFile\n";
	my @rules = <A>;
	close(A);
	my $counter = 0 ;

	
	#___ generating search query ____#
	my @queryList;	
	foreach my $line (@rules){
		if ($line =~ m/^<query /){
			my $queryId = (split(/\"/, (split(/ id\=\"/, $line))[1]))[0];
			my $source = (split(/\"/, (split(/ source\=\"/, $line))[1]))[0];
			my $pattern= (split(/\"/, (split(/ pattern\=\"/, $line))[1]))[0];
			my $startY = (split(/\"/, (split(/ startY\=\"/, $line))[1]))[0];
			my $startM = (split(/\"/, (split(/ startM\=\"/, $line))[1]))[0];
			my $startD = (split(/\"/, (split(/ startD\=\"/, $line))[1]))[0];
			my $endY = (split(/\"/, (split(/ endY\=\"/, $line))[1]))[0];
			my $endM = (split(/\"/, (split(/ endM\=\"/, $line))[1]))[0];
			my $endD = (split(/\"/, (split(/ endD\=\"/, $line))[1]))[0];
			my $nbLink  = (split(/\"/, (split(/ nbLink\=\"/, $line))[1]))[0];
			my $key     = (split(/\"/, (split(/ key\=\"/, $line))[1]))[0];			
			
			my $query = "$pattern $startD-$startM-$startY-$endD-$endM-$endY $nbLink $key";
			print "query $queryId: $query\n";
			
			if ($source eq 'alvinet'){
				my @list = &ALVINET::produceAddressURL($query);
				foreach (@list){print "$_\n";}
				#~ &write2ListFile($outputFile, @list);
			}
			elsif ($source eq 'liberation'){
				my @list = &LIBERATION::produceAddressURL($query);
				foreach (@list){print "$_\n";}
				#~ exit;
				#~ &write2ListFile($outputFile, @list);
			}			
		}		
	}
}
#~ my @queryParameters = ();
#~ if (defined($ruleFile)){
	#~ print "rule File $ruleFile\n";
	#~ @queryParameters  = &loadRuleFile($ruleFile);
#~ }
#~ else{
	#~ print "generate from command line\n";
	#~ push @queryParameters , "$siteLabel $pattern $date $nbOfPage $outputFile $speakerID";
#~ }
#________ Produce query links _________#
# format source address
#~ my @queryAddressList = ();
#~ 
#~ foreach my $query (@queryParameters){
	#~ my $label     = (split(/ /, $query))[0];
	#~ my $outputFile = (split(/ /, $query))[4];
	#~ my $date = (split(/ /, $query))[2];
#~ 
#~ 
#~ 
	#~ if ( lc($label) eq 'alvinet'){
		#~ my @list = &ALVINET::produceAddressURL($query);
		#~ &write2ListFile($outputFile, @list);
	#~ }
	#~ elsif (lc($label) eq 'voxalead'){
		#~ print "voxalead selected\n";
		#~ my ($list, $NElist) = &VOXALEAD::produceAddressURL($query);
		#~ my @list = @$list;
		#~ my @NElist = @$NElist;
		#foreach (@list){print $_."\n";}


		#~ print "$voxaleadNeDir/VOXALEAD_NAME_ENTITIES_$date\n";
		#~ open(OUT, "> $voxaleadNeDir/VOXALEAD_NAME_ENTITIES_$date") or die "pb with out named entities $voxaleadNeDir/VOXALEAD_NAME_ENTITIES_$date \n";
		#~ foreach my $m (@NElist){
			#~ #print "ueu $m\n\n";
			#~ print OUT "$m\n";
		#~ }
		#~ close(OUT);
		#~ &write2ListFile($outputFile, @list);
	#~ }	
	#~ else{
		#~ print "website not known\n";
	#~ }
#~ }



#================= Routines ====================#

sub write2ListFile{
	my ($f, @content) = @_;
        open(F ,">> $f") or die "unable to open $f\n";
	foreach(@content){
		print F "$_\n";
	}
        close(F);
}1;

#_________________________________________________#

#~ sub loadRuleFile{
	#~ # load the rule file : no check done so far 
	#~ my ($f) = @_;
	#~ open(F , $f) or die "unable to open $f\n";
	#~ my @list = <F>;
	#~ chomp(@list);	
	#~ close(F);
	#~ return(@list);
#~ }1;

