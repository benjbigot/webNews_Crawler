#!/usr/bin/perl -w
package CHALLENGES;

use HTML::TreeBuilder::XPath;
use HTML::Parser;
use LWP::UserAgent;
use Data::Dumper;



sub extractArticle{
        my ($link) = @_ ;
        my $returnedText = '' ;

	# ------------------------ #

	my $ua = LWP::UserAgent->new;
	my $response = $ua->get($link);


	if ($response->is_success){
		#--- URL is not 404 -> now checked if it is a redirection or not ---#

		my $content = $response->content;
		my $tree = HTML::TreeBuilder::XPath->new;
		$tree->parse_content($content);

		#my $isRedirected = '';
		#my @listLien =  $tree->findnodes(q{/html/head/title}) ;
		#print @listLien;
		#print $listLien[0]->findvalue(q{text()});

		#my $newLink = 'http://www.tv5.org/' .  $listLien[0]->attr('href');
		#print "nouveau lien $newLink\n";
		#exit;

		#$response = $ua->get($newLink) ;
		if ($response->is_success){

			# --- redirected and no 404 error ---- #
			$content = $response->content;
			$tree->parse_content($content);
		}
		else{
			print "but unfortunately this new url is not valid\n";
			return $returnedText;
		}


		
		# ---- after all now we can extract the text ----- # 
		for  my $result ( $tree->findnodes(q{/html/body})){
	                $returnedText = $result->findvalue(q{//div[@class="posttext"]}); # lock
                }

		if ( $returnedText eq ''){
			print "empty string\n";
			for  my $result ( $tree->findnodes(q{/html/body})){
	                	$returnedText = $result->findvalue(q{//div[@class="article-header"]/h2});
	                }
		}
		if ( $returnedText eq ''){
			print "empty string\n";
			for  my $result ( $tree->findnodes(q{/html/body})){
	                	$returnedText = $result->findvalue(q{//div[@class="announce"]}); # lock
	                }
		}
		if ( $returnedText eq ''){
			print "empty string\n";
			for  my $result ( $tree->findnodes(q{/html/body})){
	                	$returnedText = $result->findvalue(q{//div[@class="article-headerintro"]/h2});
	                }
		}
		if ( $returnedText eq ''){
			print "empty string\n";
			for  my $result ( $tree->findnodes(q{/html/body})){
	                	$returnedText = $result->findvalue(q{//div[@class="edition-main-text"]});
	                }
		}
		#print "$returnedText\n";
		return $returnedText ;
 
	
	

	}	
	else{  
		print "". $response->status_line . "\n";
	}
}1;

