#!/usr/bin/perl -w
## perl 3_getCleanArticle.pl --i test --d doneREPERE --o SORTIES_CLEAN/   --r articleRules/
use strict;
use warnings;
use Getopt::Long;
use Cwd;
use Pod::Usage;
use FileHandle;
use Module::Load::Conditional qw[can_load check_install requires];

#== rule file request ==#
my $adFile        = undef ;
my $outDir        = undef ;
my $doneFile      = undef ;
my $ruleDir       = undef ; 
 
#== gerenal options == #
my $man         = 0      ;
my $help        = 0      ;
 
my $options = GetOptions(       "i=s"   => \$adFile , 		#unsorted adress file
								"d=s"	=> \$doneFile, 		#list of already processed files
								"r=s"   => \$ruleDir,    	#list of already processed files
                                "o=s"   => \$outDir   ); 	#sorted adressFile 

#_________________ Main _________________#

push(@INC, "$ruleDir");                             
my @input  =();
#my %output =();
 
#__ loading rules file ___# 

open(I, $adFile) or die "unable to open $adFile\n";
@input = <I>;
chomp(@input);
close(I);

#____ loading done file____#
my %doneList = ();
open(I,">> $doneFile") or die "unable to create $doneFile\n";
close(I);
open(I, $doneFile) or die "unable to read $doneFile\n";
my @temp =<I>;
chomp(@temp);
close(I);
foreach(@temp){ $doneList{$_} = '' };
 

open(DONE,">> $doneFile") or die "unable to create $doneFile\n";
#___ processing cleaning __#


foreach my $line (@input){
	my $site = (split(/\:\:/,$line))[0];
	my $name = (split(/\:\:/,$line))[1];
	my $link = (split(/\:\:/,$line))[2];

	my $content = '';

	next if exists $doneList{$link};

	print "\n" . "\*" x 100 . "\n" . "\*" x 100  . "\n";
	print "$site : $link\n";
	

	my $test = { $site  => undef };
	if ( can_load( modules => $test)){
		print "module exists\n";
		print "\n" . "\*" x 50 .  "\n";
		require "$site.pm" ;
		no strict 'refs';
		#print "$site ::extractArticle($link)\n";
		$content = &{"$site\::extractArticle"}($link);
		print "$content\n";
	}
	else{
		print "module not found\n";	
	}



	#_______ processing text ______#

	if ( $content eq ''){
		print "===> $link did not return text, check link or rules\n";
	}
	else{
		#print "$content\n";
		my $newLink = $link;
		if ( $site ne 'VOXALEAD'){
			$newLink =~ s/\/|\.|\?|\.|\://g  ;
		}
		else{
			$newLink = (split(/\/+/, $link))[3];
			
		}
		print "new link : $newLink\n";
		if ( (length $newLink ) > 250) {
			$newLink = substr $newLink, 250; 
		}

		open(OUTPUT,"> $outDir/$newLink.txt") or die "unable to open $outDir/$newLink.txt\n";
		if ( $site ne 'VOXALEAD'){	
			print OUTPUT $content."\n";
		}
		else{
				foreach (@$content){
					print OUTPUT $_."\n";
				}
		}
		close(OUTPUT);

		$doneList{$link} = '' ;
		print DONE "$link\n";
		DONE->autoflush(1);

	}
}

close(DONE);


