#!/usr/bin/perl -w
package VOXALEAD;
use HTML::TreeBuilder::XPath;
use HTML::Parser;
use LWP::UserAgent;
use Data::Dumper;
#--------------------------------------------------------------------#
# attention limitation à moins de 15 jours de période de recherche
# http://voxaleadnews.labs.exalead.com/search/? l=fr & q= & r=+refine%3A%22Top%2Fchannel%2Fbfm+tv%22 & lr= & date=2013-01-28%3A2013-01-29 & b=1 & nhits=100000
#--------------------------------------------------------------------#
sub produceAddressURL{
	my ($query) = @_ ;
	my $name      = (split(/ /, $query))[1];
	my $date      = (split(/ /, $query))[2]; # date
	my $nbP       = (split(/ /, $query))[3]; # nb of pages
	my $speakerID = (split(/ /, $query))[5];
	print "$name $date $nbP $speakerId\n";
	#$name =~ s/ /+/g; # espace dans les recherche pour ce site
	my @date = split(/\-/, $date);
	if ( @date != 6){ die "check date format dd-mm-yyyy-dd-mm-yyyy\n";}

	my @urlList =(); 

	my @currentQueryReturned = ();
	my $currentQuery = 'http://voxaleadnews.labs.exalead.com/search/?b=1&nhits='. $nbP.'&q=&l=fr&r=+refine%3A%22Top%2Fchannel%2Fbfm+tv%22&lr=&date='. $date[2] .'-'. $date[1] .'-'. $date[0] .'%3A'. $date[5] .'-'.$date[4] .'-'. $date[3]; 
	print "query : $currentQuery\n";
	my $ua = LWP::UserAgent->new;
	my $response = $ua->get($currentQuery);
	my $content = $response->content;
	my @NElist = ();
	if ($response->is_success) {
		print "". $response->status_line ." : $currentQuery\n";
		my $content = $response->content;
		my @currentQueryReturned = &cleanResultFileVOXALEAD($content);
		@NElist = &getEntityList($content, $date);
		if ( scalar(@currentQueryReturned) == 0){
			last ;
		}
		else{
			$pageCounter += scalar(@currentQueryReturned) ;
			foreach (@currentQueryReturned){
				print "added : $_\n";
				push @urlList, "voxalead"."::"."$speakerID"."::"."$_";
			}
		}
	}
	else{
		print "". $response->status_line ."::$currentQuery\n";
		last;
	}

	#foreach (@urlList){print $_."\n";}
	return (\@urlList, \@NElist);
}
1;

#++++++++++++++++++++++++++++++++++++++++++#

# ajouter http://voxaleadnews.labs.exalead.com/

sub cleanResultFileVOXALEAD{
	# parse the output of the query for the site alvinet
	my ( $content  ) = @_;
    my @URLlist = ();
 
    my $result = HTML::TreeBuilder::XPath->new;
    $result->parse_content($content);

    my @list = $result->findnodes(q{//div[@id="content"]/ol/li/div/h2/a});
    #print "list: @list\n";
    for my $l (@list){
	print "links : http://voxaleadnews.labs.exalead.com/". $l->attr('href') ."\n";
        #push @URLlist, 'http://voxaleadnews.labs.exalead.com/' . $l->attr('pw:url') ;
        push @URLlist, 'http://voxaleadnews.labs.exalead.com/' . $l->attr('href') ;
	}
	
	#if (scalar(@URLlist) > 0){ 
	#        print join(' ', (@URLlist, "\n" ));
	#}

        return @URLlist;
}1;

#**********************************************#

sub getEntityList{
	my ( $content , $date ) = @_;
	
	my $result = HTML::TreeBuilder::XPath->new;
    $result->parse_content($content);
	my @list = $result->findnodes(q{//li[@class="group personpeople"]/ul//text()});
	my @NElist = ();
	for my $l (@list){
		#print  $l->getValue()."\n";
		push @NElist ,  $l->getValue();
		#push @NElist , $l->getValue();
	}
	#foreach (@NElist){print $_."\n";}
	return @NElist;
	#open(OUT, "> ./VOXALEAD_NAME_ENTITIES_"."$date") or die "pb with out nmaed entities\n";
	#for my $l (@list){
	#	#print "$l\n";
	#	print OUT "".$l->getValue()."\n";
	#}
	#close(OUT);
	
}1;


