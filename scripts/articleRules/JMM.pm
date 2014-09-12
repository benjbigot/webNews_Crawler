#!/usr/bin/perl -w
package JMM;

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

		#my $isRedirected = $tree->findnodes_as_string(q{/html/head/title});
		my $isRedirected = $tree->findvalue(q{/html/head/title});
		print "checked Title = $isRedirected \n";


		# --- if redirected --- #
	
		if ($isRedirected eq 'Advertisement'){
			print " page redirected to " ;
			my $newLink  = $tree->findnodes_as_string(q{/html/head/body/a/href/});
			print " $newLink \n";
			$response = $ua->get($newLink) ;
			if ($response->is_success){

				# --- redirected and no 404 error ---- #
				
				$content = $response->content;
				$tree->parse_content($content);
			}
			else{
				print "but unfortunately this new url is not valid\n";
				return $returnedText;
			}
		}
		else{
			print "page not redirected\n";	
		}

		
		# ---- after all now we can extract the text ----- # 
		for  my $result ( $tree->findnodes(q{/html/body})){
			#print $result->findvalue(q{//div[@class="spacearticle"]});
                        #$returnedText = $result->findvalue(q{//div[@class="spacearticle"]});
	                $returnedText = $result->findvalue(q{//div[@class="body"]});
			#print "\nt1\n $returnedText \n\n";
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

