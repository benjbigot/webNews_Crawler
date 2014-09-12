#!/usr/bin/perl -w
package LIBERATION;
#~ use HTML::TreeBuilder::XPath;
#~ use HTML::Parser;
use LWP::UserAgent;
use Data::Dumper;
use HTML::HTML5::Parser;
use XML::LibXML ;
use feature qw(say switch);

#--------------------------------------------------------------------#
#~ http://www.liberation.fr/recherche/?q=sarkozy
#~ &period=custom
#~ &period_start_day=1
#~ &period_start_month=1
#~ &period_start_year=2012
#~ &period_end_day=1
#~ &period_end_month=1
#~ &period_end_year=2013
#~ &editorial_source=
#~ &paper_channel=
#~ &sort=-publication_date_time
#--------------------------------------------------------------------#


sub produceAddressURL{
	my ($query) = @_ ;
	#$query = "$pattern $startD-$startM-$startY-$endD-$endM-$endY $nbLink $key";
	my $name      = (split(/ /, $query))[0]; # pattern
	my $date      = (split(/ /, $query))[1]; # date
	my $nbP       = (split(/ /, $query))[2]; # nb of pages
	my $speakerID = (split(/ /, $query))[3]; # keyName
	
	#~ print "$name $date $nbP $speakerID\n";
	
	
	my @date = split(/\-/, $date);
	if ( @date != 6){ die "check date format dd-mm-yyyy-dd-mm-yyyy\n";}

	#~ my @currentQueryReturned = ();
	
	
	my @urlList =();
	for (my $pageItem = 1; $pageItem <= $nbP ; $pageItem++){
		
		push @urlList , 'http://www.liberation.fr/recherche/?q='. $name  
															.'&period=custom'
															.'&period_start_day='.   ($date[0]-1) 
															.'&period_start_month='. $date[1]
															.'&period_start_year='.  $date[2] 
															.'&period_end_day='.     $date[3] 
															.'&period_end_month='.   $date[4]
															.'&period_end_year='.    $date[5]
															.'&editorial_source='
															.'&paper_channel='
															.'&sort=-publication_date_time'
															.'&page='. $pageItem
															.'&period=custom';
	}

	
	#~ my $currentQuery = 'http://voxaleadnews.labs.exalead.com/search/?b=1&nhits='. $nbP.'&q=&l=fr&r=+refine%3A%22Top%2Fchannel%2Fbfm+tv%22&lr=&date='. $date[2] .'-'. $date[1] .'-'. $date[0] .'%3A'. $date[5] .'-'.$date[4] .'-'. $date[3]; 
	#~ print "query : $currentQuery\n";
	
	
	
	
	
	foreach my $currentQuery (@urlList){
		
		$currentQuery='http://www.liberation.fr/recherche/?q=sarkozy&period=custom&period_start_day=1&period_start_month=4&period_start_year=2012&period_end_day=2&period_end_month=4&period_end_year=2012&editorial_source=&paper_channel=&sort=-publication_date_time';
		
		
		
		
		
		
		#~ my $parser = HTML::HTML5::Parser->new;
		#~ $doc = $parser->parse_file( $currentQuery );
		#~ say $doc;
		#~ exit;
		
		
		
		
		my $ua = LWP::UserAgent->new;
		my $response = $ua->get($currentQuery);
		my $content = $response->content;
	
		#~ my @NElist = ();
	
		if ($response->is_success) {
			print "". $response->status_line ." : $currentQuery\n";
			
			
			#~ my $content = $response->content;
			
			my @currentQueryReturned = &cleanResultFileLIBE($content);
			print "current @currentQueryReturned\n";
			exit;
			
			if ( scalar(@currentQueryReturned) == 0){
				print "no result\n";
				last ;
			}
			else{
				$pageCounter += scalar(@currentQueryReturned) ;
				foreach (@currentQueryReturned){
					print "added : $_\n";
					push @urlList, "liberation"."::"."$speakerID"."::"."$_";
				}
			}
		}
		else{
			print "". $response->status_line ."::$currentQuery\n";
			#~ last;
		}
	
		#foreach (@urlList){print $_."\n";}
		return (\@urlList);
	}
}
1;

#++++++++++++++++++++++++++++++++++++++++++#

sub cleanResultFileLIBE{
	# parse the output of the query for the site liberation.fr	
	my ( $content  ) = @_;
	my @URLlist = ();

	#~ my $result = HTML::TreeBuilder::XPath->new;
	my $result = HTML::HTML5::Parser->new;
	
	$result->parse_string($content);
	my $dom = HTML::HTML5::Parser->load_html(
      string => $content
      # parser options ...
    );
	print $dom;
	
	
	#~ $res = $result->parse_balanced_chunk(q{div/span}); 
	#~ my $list = $result->parse_balanced_chunk($content, {within=>'section'});
	#~ print Dumper($result);
	#~ $result->load_xml($content);
	#~ print $result->parse_balanced_chunk(q{div});
	
	exit;

	#~ my @list = $result->findnodes(q{//div[@class="item article"]/div/h3/a});
	print $result->getElementsByTagName('a')->[0]->textContent ;
	
	exit;
	
	my @list = $result->findnodes(q{//section[@class="timeline"]/div[@class="day"]/ul/li/div[@class="content"]/h2/a});
	
	print "list @list\n";

	
	for my $l (@list){
		#print "". $l->attr('href') ."\n";
		push @URLlist, $l->attr('href') ;
	}
	#print join(' ', @URLlist); 
	exit;
	return @URLlist;
}1;

#**********************************************#

#~ sub getEntityList{
	#~ my ( $content , $date ) = @_;
	#~ 
	#~ my $result = HTML::TreeBuilder::XPath->new;
    #~ $result->parse_content($content);
	#~ my @list = $result->findnodes(q{//li[@class="group personpeople"]/ul//text()});
	#~ my @NElist = ();
	#~ for my $l (@list){
		#print  $l->getValue()."\n";
		#~ push @NElist ,  $l->getValue();
		#push @NElist , $l->getValue();
	#~ }
	#foreach (@NElist){print $_."\n";}
	#~ return @NElist;
	#open(OUT, "> ./VOXALEAD_NAME_ENTITIES_"."$date") or die "pb with out nmaed entities\n";
	#for my $l (@list){
	#	#print "$l\n";
	#	print OUT "".$l->getValue()."\n";
	#}
	#close(OUT);
	
#~ }1;


