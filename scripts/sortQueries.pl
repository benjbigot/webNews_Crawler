#!/usr/bin/perl -w
## perl 2_sortQueries.pl -i FICHIER_TEST_REPERE_ALVINET.txt -o listeLienREPERE  -reportClass -noOut 
use strict;
use warnings;
use Getopt::Long;
use Cwd;
use Pod::Usage;

#== rule file request ==#
my $adFile       		= undef ;
my $sortAdFile 			= undef ; 
my $reportFeedsportal 	= 0;
my $reportSite 			= 0;
my $reportOther 		= 0;
my $noWrite 			= 0;
#== gerenal options == #
my $man         = 0      ;
my $help        = 0      ;

my $options = GetOptions(	"i=s"	=> \$adFile , #unsorted adress file
				"o=s"	=> \$sortAdFile , #sorted adressFile 
				"reportClass" => \$reportSite , #print homeless feedsportal links
				"reportFeedsportal" => \$reportFeedsportal , #print homeless feedsportal links
				"reportOther" => \$reportOther , #print homeless feedsportal links
				"noOut"  => \$noWrite ,
				"man!"  => \$man ,
				"help!"  => \$help ) or pod2usage(-verbose => 0);
if ($man){
	pod2usage(-verbose => 2) && exit;
}
if ($help){
	pod2usage(-verbose => 1) && exit;
}
if ( defined( $adFile) == 0  or defined ($sortAdFile) == 0){
	print "check arguments\n";
	pod2usage(-verbose => 1) && exit;
}

#_________main script_______#
my @input  =();
my %output =();
open(I, $adFile) or die "unable to open $adFile\n";
@input = <I>;
chomp(@input);
close(I);

foreach my $line (@input){
	#print "$line\n";
	my @line = split(/\:\:/,  $line); 
	next if (scalar(@line)  < 3) ;
	if ( $line[0] ne 'TOUTES'){
		# pour les labels comportant un tiret ou un point #
		if ( $line[0] =~ m/20-MINUTES/){
			 push @{$output{'VINGTMINUTES'}} , "$line[1]::$line[2]" ;
		}
		elsif ( $line[0] =~ m/voxalead|VOXALEAD/){
			 push @{$output{'VOXALEAD'}} , "$line[1]::$line[2]" ;
		}		
		elsif ( $line[0] =~ m/LESOIR.BE/){
			 push @{$output{'LESOIR'}} , "$line[1]::$line[2]" ;
		}
		elsif ( $line[0] =~ m/ACTUSTAR.COM/){
			 push @{$output{'ACTUSTARCOM'}} , "$line[1]::$line[2]" ;
		}
		elsif ( $line[0] =~ m/AUTOHEBDO.FR/){
			 push @{$output{'AUTOHEBDO'}} , "$line[1]::$line[2]" ;
		}
		elsif ( $line[0] =~ m/DIPLOWEB.COM/){
			 push @{$output{'DIPLOWEB'}} , "$line[1]::$line[2]" ;
		}
		elsif ( $line[0] =~ m/ZEBULON.FR/){
			 push @{$output{'ZEBULON'}} , "$line[1]::$line[2]" ;
		}
		elsif ( $line[0] =~ m/LAPTOPSPIRIT.FR/){
			 push @{$output{'LAPTOPSPIRIT'}} , "$line[1]::$line[2]" ;
		}
		elsif ( $line[0] =~ m/POLITIQUE.NET/){
			 push @{$output{'POLITIQUE'}} , "$line[1]::$line[2]" ;
		}
		elsif ( $line[0] =~ m/DECO.FR/){
			 push @{$output{'DECO'}} , "$line[1]::$line[2]" ;
		}
		elsif ( $line[0] =~ m/SILICON.FR/){
			 push @{$output{'SILICON'}} , "$line[1]::$line[2]" ;
		}
		elsif ( $line[0] =~ m/JEUXACTU.COM/){
			 push @{$output{'JEUXACTU'}} , "$line[1]::$line[2]" ;
		}
		elsif ( $line[0] =~ m/TURBO.FR/){
			 push @{$output{'TURBOFR'}} , "$line[1]::$line[2]" ;
		}
		elsif ( $line[0] =~ m/JEUXVIDEO.COM/){
			 push @{$output{'JEUXVIDEOCOM'}} , "$line[1]::$line[2]" ;
		}
		elsif ( $line[0] =~ m/JEUXVIDEO.FR/){
			 push @{$output{'JEUXVIDEOFR'}} , "$line[1]::$line[2]" ;
		}
		elsif ( $line[0] =~ m/VENDEEINFO.NET/){
			 push @{$output{'VENDEEINFO'}} , "$line[1]::$line[2]" ;
		}
		elsif ( $line[0] =~ m/EITB.COM/){
			 push @{$output{'EITB'}} , "$line[1]::$line[2]" ;
		}
		elsif ( $line[0] =~ m/AUTONEWS.FR/){
			 push @{$output{'AUTONEWS'}} , "$line[1]::$line[2]" ;
		}
		elsif ( $line[0] =~ m/ABIDJAN.NET/){
			 push @{$output{'ABIDJAN'}} , "$line[1]::$line[2]" ;
		}
		elsif ( $line[0] =~ m/FOOTBALL.FR/){
			 push @{$output{'FOOTBALL'}} , "$line[1]::$line[2]" ;
		}
		elsif ( $line[0] =~ m/ECRANLARGE.COM/){
			 push @{$output{'ECRANLARGE'}} , "$line[1]::$line[2]" ;
		}
		elsif ( $line[0] =~ m/I>TELE/){
			 push @{$output{'ITELE'}} , "$line[1]::$line[2]" ;
		}
		elsif ( $line[0] =~ m/AFRIK.COM/){
			 push @{$output{'AFRIK'}} , "$line[1]::$line[2]" ;
		}
		elsif ( $line[0] =~ m/FRENCH-PEOPLE/){
			 push @{$output{'FRENCHPEOPLE'}} , "$line[1]::$line[2]" ;
		}
		elsif ( $line[0] =~ m/FILMSACTU.COM/){
			 push @{$output{'FILMSACTUCOM'}} , "$line[1]::$line[2]" ;
		}
		elsif ( $line[0] =~ m/CENTRE-PRESSE/){
			 push @{$output{'CENTREPRESSE'}} , "$line[1]::$line[2]" ;
		}
		elsif ( $line[0] =~ m/PROGRAMME-TV/){
			 push @{$output{'PROGRAMMETV'}} , "$line[1]::$line[2]" ;
		}
		elsif ( $line[0] =~ m/CINEMA-JEUXACTU/){
			 push @{$output{'CINEMAJEUXACTU'}} , "$line[1]::$line[2]" ;
		}
		elsif ( $line[0] =~ m/LYONCAPITALE.FR/){
			 push @{$output{'LYONCAPITALE'}} , "$line[1]::$line[2]" ;
		}
		elsif ( $line[0] =~ m/ACTU-ENVIRONNEMENT/){
			 push @{$output{'ACTUENVIRONNEMENT'}} , "$line[1]::$line[2]" ;
		}
		# pour les autres le label est repris #
		else {
			push @{$output{$line[0]}} , "$line[1]::$line[2]" ;
		}
	}

	# pour les lines extraits sous le label 'TOUTES' => reattribution des labels corrects
	# a partir des URL  
	elsif ( $line[0] eq 'TOUTES'){
		next if ( $line[2] eq '') ;

		if   ( $line[2] =~ m/20minutes\.fr/)  {
			push @{$output{'VINGTMINUTES'}} , "$line[1]::$line[2]" ;
		}
		elsif($line[2] =~ m/actualitte\.com/ ) {
			push @{$output{'ACTUALITTE'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/branchez-vous\.com/ ) {
			push @{$output{'BRANCHEZVOUS'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/motorstv\.com/ ) {
			push @{$output{'MOTORSTV'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/next51\.net/ ) {
			push @{$output{'NEXT51'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/eitb\.com/ ) {
			push @{$output{'EITB'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/larecherche\.fr/ ) {
			push @{$output{'LARECHERCHE'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/pourlascience\.fr/ ) {
			push @{$output{'POURLASCIENCE'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/iledefrance\.fr/ ) {
			push @{$output{'ILEDEFRANCE'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/famili\.fr/ ) {
			push @{$output{'FAMILI'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/irna\.ir/ ) {
			push @{$output{'IRNA'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/info-palestine\.net/ ) {
			push @{$output{'INFOPALESTINE'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/rugbyrama\.fr/ ) {
			push @{$output{'RUGBYRAMA'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/come4news\.com/ ) {
			push @{$output{'COME4NEWS'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/banchez\-vous\.com/ ) {
			push @{$output{'BRANCHEZVOUS'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/sportune\.fr/ ) {
			push @{$output{'SPORTUNE'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/fenetreeurope\.com/ ) {
			push @{$output{'FENETREEUROPE'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/newspress\.fr/ ) {
			push @{$output{'NEWSPRESS'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/afriquejet\.com/ ) {
			push @{$output{'AFRIQUEJET'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/agoravox\.fr/ ) {
			push @{$output{'AGORAVOX'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/algerie-focus\.com/ ) {
			push @{$output{'ALGERIEFOCUS'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/allocine\.fr/ ) {
			push @{$output{'ALLOCINE'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/arretsurimages\.net/ ) {
			push @{$output{'ARRETSURIMAGES'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/atlantico\.fr/ ) {
			push @{$output{'ATLANTICO'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/aufeminin\.com/ ) {
			push @{$output{'AUFEMININ'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/autohebdo\.fr/ ) {
			push @{$output{'AUTOHEBDO'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/boursier\.com/ ) {
			push @{$output{'BOURSIER'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/canoe\.ca/ ) {
			push @{$output{'CANOE'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/capital\.fr/ ) {
			push @{$output{'CAPITAL'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/centre\-presse\.fr/ ) {
			push @{$output{'CENTREPRESSE'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/chartsinfrance\.net/ ) {
			push @{$output{'CHARTSINFRANCE'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/cinemateaser\.com/ ) {
			push @{$output{'CINEMATEASER'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/cinema\.fluctuat\.net/ ) {
			push @{$output{'CINEMAFLUCTUAT'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/clicanoo\.re/ ) {
			push @{$output{'CLICANOO'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/dontmiss\.fr/ ) {
			push @{$output{'DONTMISS'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/elwatan\.com/ ) {
			push @{$output{'ELWATAN'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/eurosport\.fr/ ) {
			push @{$output{'EUROSPORT'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/excessif\.com/ ) {
			push @{$output{'EXCESSIF'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/mtm-news\.com/ ) {
			push @{$output{'MTMNEWS'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/voanews\.com/ ) {
			push @{$output{'VOANEWS'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/domactu\.com/ ) {
			push @{$output{'DOMACTU'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/martinique\.franceantilles\.fr/ ) {
			push @{$output{'MARTINIQUE'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/mlyon\.fr/ ) {
			push @{$output{'MLYON'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/lyoncapitale\.fr/ ) {
			push @{$output{'LYONCAPITALE'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/challenges\.fr/ ) {
			push @{$output{'CHALLENGES'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/mercato365\.com/ ) {
			push @{$output{'MERCATO365'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/revuedeslivres\.fr/ ) {
			push @{$output{'REVUEDESLIVRES'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/orserie\.fr/ ) {
			push @{$output{'ORSERIE'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/linfo\.re/ ) {
			push @{$output{'LINFO'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/slate\.fr/ ) {
			push @{$output{'SLATE'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/vendeeinfo\.net/ ) {
			push @{$output{'VENDEEINFO'}} , "$line[1]::$line[2]" ;
		}		
		elsif ( $line[2] =~ m/lesoir\.be/ ) {
			push @{$output{'LESOIR'}} , "$line[1]::$line[2]" ;
		}
		elsif($line[2] =~ m/lci\.tf1\.fr/ ) {
			push @{$output{'LCI'}} , "$line[1]::$line[2]" ;
		}	

		elsif($line[2] =~ m/lejdd\.feedsportal\.com/) {
			push @{$output{'LEJDD'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/Parismatch\.feedsportal\.com/) {
			push @{$output{'PARISMATCH'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/foot01\.com/) {
			push @{$output{'FOOT01'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/football365\.fr/) {
			push @{$output{'FOOTBALL365'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/footmercato\.net/) {
			push @{$output{'FOOTMERCATO'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/france24\.com/) {
			push @{$output{'FRANCE24'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/francefootball\.fr/) {
			push @{$output{'FRANCEFOOTBALL'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/franceguyane\.fr/) {
			push @{$output{'FRANCEGUYANE'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/franceinfo\.fr/) {
			push @{$output{'FRANCEINFO'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/france-info\.com/) {
			push @{$output{'FRANCEINFO'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/francesoir\.fr/) {
			push @{$output{'FRANCESOIR'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/liberation\.fr/) {
			push @{$output{'LIBERATION'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/europe1\.fr/) {
			push @{$output{'EUROPE1'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/news\.fr\.msn\.com/) {
			push @{$output{'MSN'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/goal\.com/) {
			push @{$output{'GOAL'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/\/afrikfr\//) {
			push @{$output{'AFRIKFR'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/guysen\.com/) {
			push @{$output{'GUYSEN'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/french\.irib\.ir/) {
			push @{$output{'IRIB'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/jeanmarcmorandini\.com/) {
			push @{$output{'JMM'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/ladepeche\.fr/) {
			push @{$output{'LADEPECHE'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/laprovence\.com/) {
			push @{$output{'LAPROVENCE'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/lavoixdessports\.com/) {
			push @{$output{'LAVOIXDESSPORTS'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/lavoixdunord\.fr/) {
			push @{$output{'LAVOIXDUNORD'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/lefigaro\.fr/) {
			push @{$output{'LEFIGARO'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/lematin\.c/) {
			push @{$output{'LEMATIN'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/lemonde\.fr/) {
			push @{$output{'LEMONDE'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/leparisien\.fr/) {
			push @{$output{'LEPARISIEN'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/lephoceen\.fr/) {
			push @{$output{'LEPOCHEEN'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/lepoint\.fr/) {
			push @{$output{'LEPOINT'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/lepost\.fr/) {
			push @{$output{'LEPOST'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/lequipe\.fr/) {
			push @{$output{'LEQUIPE'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/lexpress\.fr/) {
			push @{$output{'LEXPRESS'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/lindependant\.fr/) {
			push @{$output{'LINDEPENDANT'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/linternaute\.com/) {
			push @{$output{'LINTERNAUTE'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/lunion\.presse\.fr/) {
			push @{$output{'LUNION'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/maxifoot\.fr/) {
			push @{$output{'MAXIFOOT'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/mediapart\.fr/) {
			push @{$output{'MEDIAPART'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/melty\.fr/) {
			push @{$output{'MELTY'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/midilibre\.fr/) {
			push @{$output{'MIDILIBRE'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/fr\.news\.yahoo\.com/) {
			push @{$output{'YAHOO'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/nordeclair\.fr/) {
			push @{$output{'NORDECLAIR'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/nouvelobs\.com/) {
			push @{$output{'NOUVELOBS'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/paristeam\.fr/) {
			push @{$output{'PARISTEAM'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/french\.people\.com/) {
			push @{$output{'FRENCHPEOPLE'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/premiere\/fr/) {
			push @{$output{'PREMIERE'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/purepeople\.com/) {
			push @{$output{'PUREPEOPLE'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/puretrend\.com/) {
			push @{$output{'PURETREND'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/rfi\.fr/) {
			push @{$output{'RFI'}} , "$line[1]::$line[2]" ;
		}			
		elsif($line[2] =~ m/fr\.rian\.ru/) {
			push @{$output{'RIAN'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/romandie\.com/) {
			push @{$output{'ROMANDIE'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/rtbf\.be/) {
			push @{$output{'RTBF'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/rue89\.com/) {
			push @{$output{'RUE89'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/rue89\.feedsportal/) {
			push @{$output{'RUE89'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/sofoot\.com/) {
			push @{$output{'SOFOOT'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/sport24\.com/) {
			push @{$output{'SPORT24'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/sport365\.fr/) {
			push @{$output{'SPORT365'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/sport\.fr/) {
			push @{$output{'SPORT'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/staragora\.com/) {
			push @{$output{'STARAGORA'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/sudouest\.fr/) {
			push @{$output{'SUDOUEST'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/ouest-france\.fr/) {
			push @{$output{'OUESTFRANCE'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/toilef1\.com/) {
			push @{$output{'TOILEF1'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/toulouse7\.com/) {
			push @{$output{'TOULOUSE7'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/tv5\.org/) {
			push @{$output{'TV5'}} , "$line[1]::$line[2]" ;
		}		
		elsif($line[2] =~ m/varmatin\.com/) {
			push @{$output{'VARMATIN'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/lavieeco\.com/) {
			push @{$output{'LAVIEECO'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/yabiladi\.com/) {
			push @{$output{'YABILADI'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/\.maville\.com/) {
			push @{$output{'MAVILLE'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/courrierinternational\.com/) {
			push @{$output{'COURRIERINTERNATIONAL'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/nicematin\.com/) {
			push @{$output{'NICEMATIN'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/abidjan\.net/) {
			push @{$output{'ABIDJAN'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/humanite\.fr/) {
			push @{$output{'HUMANITE'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/la-croix\.fr/) {
			push @{$output{'LACROIX'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/la-croix\.com/) {
			push @{$output{'LACROIX'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/francetv\.fr/) {
			push @{$output{'FRANCETV'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/cinema\.jeuxactu\.com/) {
			push @{$output{'CINEMAJEUXACTU'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/tele\.premiere\.fr/) {
			push @{$output{'TELEPREMIERE'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/publicsenat\.fr/) {
			push @{$output{'PUBLICSENAT'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/premiere\.fr/) {
			push @{$output{'PREMIERE'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/people\.premiere\.fr/) {
			push @{$output{'PEOPLE-PREMIERE'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/rugby365\.feedsportal\.fr/) {
			push @{$output{'RUGBY365'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/rugby365\.feedsportal\.com/) {
			push @{$output{'RUGBY365'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/rugby365\.fr/) {
			push @{$output{'RUGBY365'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/football365\.feedsportal\.fr/) {
			push @{$output{'FOOTBALL365'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/football365\.feedsportal\.com/) {
			push @{$output{'FOOTBALL365'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/entrevue\.fr/) {
			push @{$output{'ENTREVUE'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/programme-tv\.net/) {
			push @{$output{'PROGRAMMETV'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/metrofrance\.com/) {
			push @{$output{'METROFRANCE'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/lamontagne\.fr/) {
			push @{$output{'LAMONTAGNE'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/sport365\.feedsportal\.com/) {
			push @{$output{'SPORT365'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/plurielles\.fr/) {
			push @{$output{'PLURIELLES'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/people\.plurielles\.fr/) {
			push @{$output{'PEOPLE-PLURIELLES'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/ozap\.com/) {
			push @{$output{'OZAP'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/musicactu\.com/) {
			push @{$output{'MUSICACTU'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/feedproxy\.google\.com/) {
			push @{$output{'GOOGLE'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/feeds2\.terrafemina\.com/) {
			push @{$output{'TERRAFEMINA'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/fr\.euronews\.net/) {
			push @{$output{'EURONEWS'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/corsematin\.com/) {
			push @{$output{'CORSEMATIN'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/lasemainedansleboulonnais\.fr/) {
			push @{$output{'LASEMAINEDANSLEBOULONNAIS'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/rss\.challenge\.fr/) {
			push @{$output{'CHALLENGE'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/latribune\.fr/) {
			push @{$output{'LATRIBUNE'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/marianne2\.fr/) {
			push @{$output{'MARIANNE2'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/mercato365\.feedsportal\.com/) {
			push @{$output{'MERCATO365'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/lagazettedescommunes\.com/) {
			push @{$output{'LAGAZETTEDESCOMMUNES'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/mediafed\.rmc\.fr/) {
			push @{$output{'RMC'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/fr\.uefa\.com/) {
			push @{$output{'UEFA'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/minutebuzz\.com/) {
			push @{$output{'MINUTEBUZZ'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/itespresso\.fr/) {
			push @{$output{'ITESPRESSO'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/pro\.clubic\.com/) {
			push @{$output{'CLUBIC'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/musique\.jeuxactu\.com/) {
			push @{$output{'JEUXACTU'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/lesinrocks\.com/) {
			push @{$output{'LESINROCKS'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/radio-canada\.ca/) {
			push @{$output{'RADIOCANADA'}} , "$line[1]::$line[2]" ;
		}	
		elsif($line[2] =~ m/lest-eclair\.fr/) {
			push @{$output{'LESTECLAIR'}} , "$line[1]::$line[2]" ;
		}	
		# cas pariculiers des pages redirigées par feedsportal
		elsif($line[2] =~ m/rss\.feedsportal\.com/ ) {
			if ( $line[2] =~ m/Slesechos/ ) {
				push @{$output{'LESECHOS'}} , "$line[1]::$line[2]" ;
			}
			elsif ( $line[2] =~ m/lexpress/ ) {
				push @{$output{'LEXPRESS'}} , "$line[1]::$line[2]" ;
			}
			elsif ( $line[2] =~ m/letelegramme/ ) {
				push @{$output{'LETELEGRAMME'}} , "$line[1]::$line[2]" ;
			}
			elsif ( $line[2] =~ m/football/ ) {
				push @{$output{'FOOTBALL'}} , "$line[1]::$line[2]" ;
			}
			elsif ( $line[2] =~ m/lesoir/ ) {
				push @{$output{'LESOIR'}} , "$line[1]::$line[2]" ;
			}
			elsif ( $line[2] =~ m/gala/ ) {
				push @{$output{'GALA'}} , "$line[1]::$line[2]";
			}
			elsif ( $line[2] =~ m/lavoixdunord/ ) {
				push @{$output{'LAVOIXDUNORD'}} , "$line[1]::$line[2]" ;
			}
			elsif ( $line[2] =~ m/autonews/ ) {
				push @{$output{'AUTONEWS'}} , "$line[1]::$line[2]" ;
			}
			elsif ( $line[2] =~ m/toutlecine/ ) {
				push @{$output{'TOUTLECINE'}} , "$line[1]::$line[2]" ;
			}
			elsif ( $line[2] =~ m/lejdd/ ) {
				push @{$output{'LEJDD'}} , "$line[1]::$line[2]" ;
			}	
			elsif ( $line[2] =~ m/actustar/ ) {
				push @{$output{'ACTUSTARCOM'}} , "$line[1]::$line[2]" ;
			}	
			elsif ( $line[2] =~ m/voici/ ) {
				push @{$output{'VOICI'}} , "$line[1]::$line[2]" ;
			}	
			elsif ( $line[2] =~ m/rtl/ ) {
				push @{$output{'RTL'}} , "$line[1]::$line[2]" ;
			}	
			elsif ( $line[2] =~ m/lci/ ) {
				push @{$output{'LCI'}} , "$line[1]::$line[2]" ;
			}	
			elsif ( $line[2] =~ m/tf1/ ) {
				push @{$output{'TF1'}} , "$line[1]::$line[2]" ;
			}	
			elsif ( $line[2] =~ m/rmc/ ) {
				push @{$output{'RMC'}} , "$line[1]::$line[2]" ;
			}	
			elsif ( $line[2] =~ m/lexpansion/ ) {
				push @{$output{'LEXPANSION'}} , "$line[1]::$line[2]" ;
			}	
			elsif ( $line[2] =~ m/ecranlarge/ ) {
				push @{$output{'ECRANLARGE'}} , "$line[1]::$line[2]" ;
			}	
			elsif ( $line[2] =~ m/linternaute/ ) {
				push @{$output{'LINTERNAUTE'}} , "$line[1]::$line[2]" ;
			}	
			elsif ( $line[2] =~ m/journaldunet/ ) {
				push @{$output{'JOURNALDUNET'}} , "$line[1]::$line[2]" ;
			}	
			elsif ( $line[2] =~ m/jeuxvideo/ ) {
				push @{$output{'JEUXVIDEO'}} , "$line[1]::$line[2]" ;
			}	
			elsif ( ( $line[2] =~ m/nice/ )  && ( $line[2] =~ m/premium/ ) ) {
				push @{$output{'NICEPREMIUM'}} , "$line[1]::$line[2]" ;
			}	
			elsif ( ( $line[2] =~ m/1net/ )  && ( $line[2] =~ m/editorial/ ) ) {
				push @{$output{'01NET'}} , "$line[1]::$line[2]" ;
			}	

			# les étiquettes sous feedsportal pour lesquels une regles d'attribution 
			# n'a pu etre trouvé sont placé dans la liste sous le label FEEDSPORTAL
			else{
				push @{$output{'FEEDSPORTAL'}} , "$line[1]::$line[2]" ;
			}
		}	

		# les labels pour lesquels un label d'attribution n'a pu être trouvé sont placés sous 
		# le label AUTRE
		else{
			push @{$output{'AUTRE'}} , "$line[1]::$line[2]" ;
		}	
	}
}


#^^^^^^^^^^^^^^^^^^^^^^#
# writting output File #
#----------------------#
if( $noWrite == 0){
	print "write to $sortAdFile\n";
	open(OUT, "> $sortAdFile") or die "unable to open $sortAdFile\n";
	foreach my $s (keys (%output) ){
		#print "$s\n";
		foreach my $link ( @{$output{$s}} ){
			print OUT "$s"."::"."$link\n";
		}
	}
	close(OUT);
}

#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^#
# --------  Report output routines  -------------- #
#__________________________________________________#
#--------------------------------------------------#


if ($reportFeedsportal) {
	print "\n=====  liens sous feedsportal sans autre affiliation === \n";
	foreach (@{$output{'FEEDSPORTAL'}}){
		print "$_\n";
	}

}



if ($reportSite){
	foreach (keys(%output)){
		print  scalar( @{$output{$_}}) . " links : \t $_  \n";
	}
}


if ($reportOther){
	print "\n########### web sites without a rule #########\n";
	print "########### if you observe a large number of occurrences add this site to the main list #########\n";
	my %otherStat = ();
	foreach (@{$output{'AUTRE'}}){
		my $line = (split(/\:\:/, $_))[1];
		my $web = (split(/\//, (split(/\/\//, $line))[1]))[0];
		push @{$otherStat{$web}} , $line ;
	}
	foreach (keys(%otherStat)){
        	print scalar( @{$otherStat{$_}}) . " occurrence(s) \t : $_ \n";
	}
}




__END__


=head1 NAME
	sortQueries - is part of the siteUtilsPackage 

=head1 SYNOPSIS

	perl sortQueries -i raw_link_file  -o outputFile -reportfeedsportal -reportClass -reportOther -help -man

	Options : 
		-i 	input file provided by the first step of the package
		-o	output file that will be used to get the articles 
		-help	brief help description
		-man	manual page

=head1 OPTIONS

=over 8

=item B<-feedsportal> edit report concerning links related to feedsportal web site

=item B<-help>
	Print a brief description of usage

=item B<-man>
	Print the manual page

=back

=head1 DESCRIPTION

B<sortQueries> is ran over the output provided by B<buildQueries.pl> in order to
determinate their affiliation website and rules for article extraction.

=head1 AUTHOR

Developped by Benjamin Bigot


=cut
