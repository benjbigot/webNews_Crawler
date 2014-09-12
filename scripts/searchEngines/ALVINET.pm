#!/usr/bin/perl -w
package ALVINET;
use HTML::TreeBuilder::XPath;
use HTML::Parser;
use LWP::UserAgent;
use Data::Dumper;


#+++++++++++++++++++++++++++++++++++++++#
# List of available source from Alvinet #
#+++++++++++++++++++++++++++++++++++++++#

my %sourceList = (
'Toutes' => 'TOUTES' ,
'01Net' => '01NET' ,
'20 Minutes' => '20-MINUTES' ,
'7sur7' => '7SUR7' ,
'Abidjan.net' => 'ABIDJAN.NET' ,
'ABP' => 'ABP' ,
'activ radio' => 'ACTIV-RADIO' ,
'actu environnement' => 'ACTU-ENVIRONNEMENT' ,
'actuafoot' => 'ACTUAFOOT' ,
'Actualité_Française.com' => 'ACTUALITE_FRANCAISE.COM' ,
'Actualitté' => 'ACTUALITTE' ,
'Actustar.com' => 'ACTUSTAR.COM' ,
'ActuWiki' => 'ACTUWIKI' ,
'Afrik.com' => 'AFRIK.COM' ,
'Afrique-en-ligne' => 'AFRIQUE-EN-LIGNE' ,
'Agoravox' => 'AGORAVOX' ,
'Air-Journal' => 'AIR-JOURNAL' ,
'albi-info' => 'ALBI-INFO' ,
'Algérie_Focus' => 'ALGERIE_FOCUS' ,
'Allociné' => 'ALLOCINE' ,
'Alternatives-Economiques' => 'ALTERNATIVES-ECONOMIQUES' ,
'Android-et-Vous-!' => 'ANDROID-ET-VOUS' ,
'Ariase' => 'ARIASE' ,
'Ariège-News' => 'ARIEGE-NEWS' ,
'Arrêt-sur-Images' => 'ARRET-SUR-IMAGES' ,
'Atlantico' => 'ATLANTICO' ,
'Au-Feminin' => 'AU-FEMININ' ,
'Autohebdo.fr' => 'AUTOHEBDO.FR' ,
'Autonews.fr' => 'AUTONEWS.FR' ,
'Bakchich' => 'BAKCHICH' ,
'BBC-Afrique' => 'BBC-AFRIQUE' ,
'BBoyKonsian' => 'BBOYKONSIAN' ,
'Be-Geek' => 'BE-GEEK' ,
'Biofocus' => 'BIOFOCUS' ,
'Bondy-Blog' => 'BONDY-BLOG' ,
'Boursier' => 'BOURSIER' ,
'Canal-Street' => 'CANAL-STREET' ,
'Canoë' => 'CANOE' ,
'Capital' => 'CAPITAL' ,
'cBanque' => 'CBANQUE' ,
'Centre-Presse' => 'CENTRE-PRESSE' ,
'Challenges' => 'CHALLENGES' ,
'Charente-Libre' => 'CHARENTE-LIBRE' ,
'Charts-in-France' => 'CHARTS-IN-FRANCE' ,
'Châteaubriant-actualités' => 'CHATEAUBRIANT-ACTUALITES' ,
'Cinemateaser' => 'CINEMATEASER' ,
'CitiZen-Nantes' => 'CITIZEN-NANTES' ,
'Clicanoo' => 'CLICANOO' ,
'Clubic' => 'CLUBIC' ,
'CNETFrance' => 'CNETFRANCE' ,
'Come4News' => 'COME4NEWS' ,
'Comment-Ca-Marche' => 'COMMENT-CA-MARCHE' ,
'Corse_matin' => 'CORSE_MATIN' ,
'Corsica' => 'CORSICA' ,
'Courrier-International' => 'COURRIER-INTERNATIONAL' ,
'Cowcotland' => 'COWCOTLAND' ,
'Culture' => 'CULTURE' ,
'D!CI-Radio' => 'D!CI-RADIO' ,
'DailyNord' => 'DAILYNORD' ,
'Deco.fr' => 'DECO.FR' ,
'DegroupNews' => 'DEGROUPNEWS' ,
'Dernières-Nouvelles-d\'Alsace' => 'DERNIERES-NOUVELLES-DALSACE' ,
'Dernières Nouvelles d\'Alsace' => 'DERNIERES-NOUVELLES-DALSACE' ,
'Diploweb.com' => 'DIPLOWEB.COM' ,
'Doctissimo' => 'DOCTISSIMO' ,
'DOMactu' => 'DOMACTU' ,
'Don\'t-Miss' => 'DONT-MISS' ,
'Easybourse' => 'EASYBOURSE' ,
'eBouquin' => 'EBOUQUIN' ,
'Echos-du-Net' => 'ECHOS-DU-NET' ,
'EcranLarge.com' => 'ECRANLARGE.COM' ,
'Ecrans' => 'ECRANS' ,
'EiTB.com' => 'EITB.COM' ,
'El-Watan' => 'EL-WATAN' ,
'Entrevue' => 'ENTREVUE' ,
'Enviro2B' => 'ENVIRO2B' ,
'Euronews' => 'EURONEWS' ,
'Europe-1' => 'EUROPE-1' ,
'Europe-Camions' => 'EUROPE-CAMIONS' ,
'Eurosport' => 'EUROSPORT' ,
'Evene' => 'EVENE' ,
'Faits-Religieux' => 'FAITS-RELIGIEUX' ,
'Famili' => 'FAMILI' ,
'Fan_F1.com' => 'FAN_F1.COM' ,
'Fenêtre-sur-l\'Europe' => 'FENETRE-SUR-LEUROPE' ,
'Fest' => 'FEST' ,
'FilmsActu.com' => 'FILMSACTU.COM' ,
'Foot-Mercato' => 'FOOT-MERCATO' ,
'Foot-National' => 'FOOT-NATIONAL' ,
'Foot01' => 'FOOT01' ,
'Football-365' => 'FOOTBALL-365' ,
'Football.fr' => 'FOOTBALL.FR' ,
'France-24' => 'FRANCE-24' ,
'France-3' => 'FRANCE-3' ,
'France-Antilles' => 'FRANCE-ANTILLES' ,
'France-Football' => 'FRANCE-FOOTBALL' ,
'France-Guyane' => 'FRANCE-GUYANE' ,
'France-Info' => 'FRANCE-INFO' ,
'France-Soir' => 'FRANCE-SOIR' ,
'France-Télévisions' => 'FRANCE-TELEVISIONS' ,
'Francetv-info' => 'FRANCETV-INFO' ,
'Fredzone' => 'FREDZONE' ,
'FrenchWeb' => 'FRENCHWEB' ,
'Futura_Sciences' => 'FUTURA_SCIENCES' ,
'Gala' => 'GALA' ,
'GAMEBLOG' => 'GAMEBLOG' ,
'Gamekult' => 'GAMEKULT' ,
'Génération-3D' => 'GENERATION-3D' ,
'Generation-Nouvelles-Technologies' => 'GENERATION-NOUVELLES-TECHNOLOGIES' ,
'Global-Voices' => 'GLOBAL-VOICES' ,
'Goal' => 'GOAL' ,
'Guysen-International-News' => 'GUYSEN-INTERNATIONAL-NEWS' ,
'HardWare' => 'HARDWARE' ,
'Hominidés' => 'HOMINIDES' ,
'i>TELE' => 'I>TELE' ,
'Info_Palestine' => 'INFO_PALESTINE' ,
'Information-Hospitaliere' => 'INFORMATION-HOSPITALIERE' ,
'Infotech' => 'INFOTECH' ,
'Inside-Basket' => 'INSIDE-BASKET' ,
'Iran-Focus' => 'IRAN-FOCUS' ,
'IRIB-_-Radio-Francophone' => 'IRIB-_-RADIO-FRANCOPHONE' ,
'IRNA' => 'IRNA' ,
'ITespresso' => 'ITESPRESSO' ,
'Jean_Marc-Morandini.com' => 'JEAN_MARC-MORANDINI.COM' ,
'Jeune-Afrique' => 'JEUNE-AFRIQUE' ,
'JeuxActu.com' => 'JEUXACTU.COM' ,
'JeuxVideo.com' => 'JEUXVIDEO.COM' ,
'JeuxVideo.fr' => 'JEUXVIDEO.FR' ,
'L\'Alsace' => 'LALSACE' ,
'L\'Automobile-Magazine' => 'LAUTOMOBILE-MAGAZINE' ,
'L\'Avenir-de-l\'Artois' => 'LAVENIR-DE-LARTOIS' ,
'L\'écho-Républicain' => 'LECHO-REPUBLICAIN' ,
'L\'Equipe' => 'LEQUIPE' ,
'L\'Est-Eclair' => 'LEST-ECLAIR' ,
'L\'Est-Républicain' => 'LEST-REPUBLICAIN' ,
'L\'Expansion' => 'LEXPANSION' ,
'L\'Express' => 'LEXPRESS' ,
'L\'humanité' => 'LHUMANITE' ,
'L\'Indépendant' => 'LINDEPENDANT' ,
'L\'informaticien' => 'LINFORMATICIEN' ,
'L\'Internaute' => 'LINTERNAUTE' ,
'L\'Union' => 'LUNION' ,
'L\'Yonne-républicaine' => 'LYONNE-REPUBLICAINE' ,
'La-1ère' => 'LA-1ERE' ,
'La-Chaine-Météo' => 'LA-CHAINE-METEO' ,
'La-Chronique-Agora' => 'LA-CHRONIQUE-AGORA' ,
'La-Croix' => 'LA-CROIX' ,
'La-Dépêche' => 'LA-DEPECHE' ,
'La-Gazette-des-Communes' => 'LA-GAZETTE-DES-COMMUNES' ,
'La-lettre-du-libraire' => 'LA-LETTRE-DU-LIBRAIRE' ,
'La-Marseillaise' => 'LA-MARSEILLAISE' ,
'La-Mayenne,-on-adore-!' => 'LA-MAYENNE-ON-ADORE' ,
'La-Montagne' => 'LA-MONTAGNE' ,
'La-Parisienne' => 'LA-PARISIENNE' ,
'La-Provence' => 'LA-PROVENCE' ,
'La-Semaine-dans-le-Boulonnais' => 'LA-SEMAINE-DANS-LE-BOULONNAIS' ,
'La-semaine-du-Roussillon' => 'LA-SEMAINE-DU-ROUSSILLON' ,
'La-Tribune' => 'LA-TRIBUNE' ,
'La-Vie-éco' => 'LA-VIE-ECO' ,
'La-Voix-de-la-Russie' => 'LA-VOIX-DE-LA-RUSSIE' ,
'La-Voix-du-Nord' => 'LA-VOIX-DU-NORD' ,
'La-Voix-Eco' => 'LA-VOIX-ECO' ,
'LaptopSpirit.fr' => 'LAPTOPSPIRIT.FR' ,
'LCM' => 'LCM' ,
'Le-Berry-Républicain' => 'LE-BERRY-REPUBLICAIN' ,
'Le-Courrier-Picard' => 'LE-COURRIER-PICARD' ,
'Le-Dauphiné-Libéré' => 'LE-DAUPHINE-LIBERE' ,
'Le-Figaro' => 'LE-FIGARO' ,
'Le-Figaro-Madame' => 'LE-FIGARO-MADAME' ,
'Le-Huffington-Post' => 'LE-HUFFINGTON-POST' ,
'Le-JDD' => 'LE-JDD' ,
'Le-Journal-de-la-Haute_Marne' => 'LE-JOURNAL-DE-LA-HAUTE_MARNE' ,
'Le-Journal-des-Arts' => 'LE-JOURNAL-DES-ARTS' ,
'Le-Journal-du-Centre' => 'LE-JOURNAL-DU-CENTRE' ,
'Le-journal-du-net' => 'LE-JOURNAL-DU-NET' ,
'Le-Journal-du-Pays-Basque' => 'LE-JOURNAL-DU-PAYS-BASQUE' ,
'Le-Maine-Libre' => 'LE-MAINE-LIBRE' ,
'Le-Matin' => 'LE-MATIN' ,
'Le-Mensuel-de-Rennes' => 'LE-MENSUEL-DE-RENNES' ,
'Le-Mensuel-du-Golfe-du-Morbihan' => 'LE-MENSUEL-DU-GOLFE-DU-MORBIHAN' ,
'Le-Monde' => 'LE-MONDE' ,
'Le-Monde-diplomatique' => 'LE-MONDE-DIPLOMATIQUE' ,
'Le-Monde-Informatique' => 'LE-MONDE-INFORMATIQUE' ,
'Le-Nord-Bretagne' => 'LE-NORD-BRETAGNE' ,
'Le-Parisien' => 'LE-PARISIEN' ,
'Le-Pays' => 'LE-PAYS' ,
'Le-Phare-Dunkerquois' => 'LE-PHARE-DUNKERQUOIS' ,
'Le-Phoceen' => 'LE-PHOCEEN' ,
'Le-Point' => 'LE-POINT' ,
'Le-Populaire-du-Centre' => 'LE-POPULAIRE-DU-CENTRE' ,
'Le-Progrès.fr' => 'LE-PROGRES.FR' ,
'Le-Quotidien-du-Peuple-en-ligne' => 'LE-QUOTIDIEN-DU-PEUPLE-EN-LIGNE' ,
'Le-Républicain-Lorrain' => 'LE-REPUBLICAIN-LORRAIN' ,
'Le-Télégramme' => 'LE-TELEGRAMME' ,
'LeBuzz' => 'LEBUZZ' ,
'Les-Echos' => 'LES-ECHOS' ,
'Les-Nouvelles-News' => 'LES-NOUVELLES-NEWS' ,
'Les-Numériques' => 'LES-NUMERIQUES' ,
'Lesinrocks' => 'LESINROCKS' ,
'lesoir.be' => 'LESOIR.BE' ,
'Libération' => 'LIBERATION' ,
'Libnanews' => 'LIBNANEWS' ,
'Linfo' => 'LINFO' ,
'Longueur-d\'Ondes' => 'LONGUEUR-DONDES' ,
'Lyon-Info' => 'LYON-INFO' ,
'LyonCapitale.fr' => 'LYONCAPITALE.FR' ,
'M6-MSN' => 'M6-MSN' ,
'Mac4Ever' => 'MAC4EVER' ,
'Macplus' => 'MACPLUS' ,
'Marchés-Tropicaux-et-Méditerranéens' => 'MARCHES-TROPICAUX-ET-MEDITERRANEENS' ,
'Marianne2' => 'MARIANNE2' ,
'Maxifoot' => 'MAXIFOOT' ,
'Mediapart' => 'MEDIAPART' ,
'melty' => 'MELTY' ,
'meltyFashion' => 'MELTYFASHION' ,
'MemoClic' => 'MEMOCLIC' ,
'Mercato-365' => 'MERCATO-365' ,
'Metamag' => 'METAMAG' ,
'Metro' => 'METRO' ,
'Midi-Libre' => 'MIDI-LIBRE' ,
'MinuteBuzz' => 'MINUTEBUZZ' ,
'mLyon' => 'MLYON' ,
'Motors-TV' => 'MOTORS-TV' ,
'mowno' => 'MOWNO' ,
'MTV' => 'MTV' ,
'MusicActu' => 'MUSICACTU' ,
'Musique-Radio' => 'MUSIQUE-RADIO' ,
'MusiqueMag' => 'MUSIQUEMAG' ,
'MyPharma-Editions' => 'MYPHARMA-EDITIONS' ,
'News-Press' => 'NEWS-PRESS' ,
'Next51' => 'NEXT51' ,
'Nice-Premium' => 'NICE-PREMIUM' ,
'Nice-Rendez_Vous' => 'NICE-RENDEZ_VOUS' ,
'Nice_Matin' => 'NICE_MATIN' ,
'Nord-éclair' => 'NORD-ECLAIR' ,
'Nord-Littoral' => 'NORD-LITTORAL' ,
'Notulus' => 'NOTULUS' ,
'Nouvel-Obs' => 'NOUVEL-OBS' ,
'Numerama' => 'NUMERAMA' ,
'Orléans-Infos' => 'ORLEANS-INFOS' ,
'OrSériE' => 'ORSERIE' ,
'Ouest_France' => 'OUEST_FRANCE' ,
'OWNI' => 'OWNI' ,
'Paris-Match' => 'PARIS-MATCH' ,
'Paris-Team' => 'PARIS-TEAM' ,
'Partageons-mon-avis' => 'PARTAGEONS-MON-AVIS' ,
'PC-Impact' => 'PC-IMPACT' ,
'PC-World' => 'PC-WORLD' ,
'Plurielles' => 'PLURIELLES' ,
'Politique.net' => 'POLITIQUE.NET' ,
'POPnews' => 'POPNEWS' ,
'Pour-la-Science' => 'POUR-LA-SCIENCE' ,
'Première' => 'PREMIERE' ,
'Presse-Citron' => 'PRESSE-CITRON' ,
'Presseurop' => 'PRESSEUROP' ,
'Professeur-Forex' => 'PROFESSEUR-FOREX' ,
'Public-Sénat' => 'PUBLIC-SENAT' ,
'Pure-People' => 'PURE-PEOPLE' ,
'PureMédias-by-Ozap' => 'PUREMEDIAS-BY-OZAP' ,
'Radin-Rue' => 'RADIN-RUE' ,
'Radio_Canada' => 'RADIO_CANADA' ,
'RamDam' => 'RAMDAM' ,
'Région-Aquitaine' => 'REGION-AQUITAINE' ,
'Région-Auvergne' => 'REGION-AUVERGNE' ,
'Région-Bourgogne' => 'REGION-BOURGOGNE' ,
'Région-Bretagne' => 'REGION-BRETAGNE' ,
'Région-Champagne_Ardenne' => 'REGION-CHAMPAGNE_ARDENNE' ,
'Région-d\'Ile-de-France' => 'REGION-DILE-DE-FRANCE' ,
'Région-Franche_Comté' => 'REGION-FRANCHE_COMTE' ,
'Région-Limousin' => 'REGION-LIMOUSIN' ,
'Région-Lorraine' => 'REGION-LORRAINE' ,
'Région-Midi-Pyrénées' => 'REGION-MIDI-PYRENEES' ,
'Région-PACA' => 'REGION-PACA' ,
'Région-Pays-de-la-Loire' => 'REGION-PAYS-DE-LA-LOIRE' ,
'Région-Picardie' => 'REGION-PICARDI'     ,
'Région-Poitou_Charentes' => 'REGION-POITOU_CHARENTES' ,
'Région-Rhône_alpes' => 'REGION-RHONE_ALPES' ,
'Reviewer' => 'REVIEWER' ,
'Rezo' => 'REZO' ,
'RFI' => 'RFI' ,
'RIA-Novosti' => 'RIA-NOVOSTI' ,
'RMC' => 'RMC' ,
'Romandie' => 'ROMANDIE' ,
'RTBF' => 'RTBF' ,
'RTL' => 'RTL' ,
'Rue89' => 'RUE89' ,
'Rugby-365' => 'RUGBY-365' ,
'Rugbyrama' => 'RUGBYRAMA' ,
'Sciences-et-avenir' => 'SCIENCES-ET-AVENIR' ,
'Secours-Catholique' => 'SECOURS-CATHOLIQUE' ,
'Senior-actu' => 'SENIOR-ACTU' ,
'Silicon.fr' => 'SILICON.FR' ,
'Slate' => 'SLATE' ,
'So-Foot' => 'SO-FOOT' ,
'Sport' => 'SPORT' ,
'Sport-365' => 'SPORT-365' ,
'SPORT-Stratégies' => 'SPORT-STRATEGIES' ,
'Sport24' => 'SPORT24' ,
'Sportune' => 'SPORTUNE' ,
'Staragora' => 'STARAGORA' ,
'Sud-Ouest' => 'SUD-OUEST' ,
'Technaute' => 'TECHNAUTE' ,
'Techno_Science' => 'TECHNO_SCIENCE' ,
'Télé_Loisirs' => 'TELE_LOISIRS' ,
'Terrafemina' => 'TERRAFEMINA' ,
'TF1' => 'TF1' ,
'TF1-News' => 'TF1-NEWS' ,
'ToileF1' => 'TOILEF1' ,
'Tom\'s-Games' => 'TOMS-GAMES' ,
'Tom\'s-Guide' => 'TOMS-GUIDE' ,
'Toulouse-7' => 'TOULOUSE-7' ,
'Toulouse-Infos' => 'TOULOUSE-INFOS' ,
'Toute-l\'Europe' => 'TOUTE-LEUROPE' ,
'ToutLeCine' => 'TOUTLECINE' ,
'Turbo.fr' => 'TURBO.FR' ,
'TV5-Monde' => 'TV5-MONDE' ,
'TVMag' => 'TVMAG' ,
'UEFA' => 'UEFA' ,
'Undernews' => 'UNDERNEWS' ,
'Var_Matin' => 'VAR_MATIN' ,
'Vendéeinfo.net' => 'VENDEEINFO.NET' ,
'Ventoux-Magazine' => 'VENTOUX-MAGAZINE' ,
'Vie-Publique' => 'VIE-PUBLIQUE' ,
'VOA-News' => 'VOA-NEWS' ,
'Voici' => 'VOICI' ,
'Vosges-Matin' => 'VOSGES-MATIN' ,
'Web_Libre' => 'WEB_LIBRE' ,
'WebRankinfo' => 'WEBRANKINFO' ,
'Yabiladi' => 'YABILADI' ,
'YOUPHIL' => 'YOUPHIL' ,
'ZDNet' => 'ZDNET' ,
'Zebulon.fr' => 'ZEBULON.FR' ,
'zegreenweb' => 'ZEGREENWEB' ,
'Zinfos-974' => 'ZINFOS-974' ,
'Zonebourse' => 'ZONEBOURSE' );

#+++++++++++++++++++++++++++++++++++++++++++#

#http://www.alvinet.com/actualite/?keyword=toto&akeyword=&catid=&source=Toutes&depuis=&periode=entre&ddate=15%2F01%2F2013&fdate=30%2F01%2F2013&or=date&source=Zonebourse

#++++++++++++++++++++++++++++++++++++++++++#

sub produceAddressURL{
	my ($query) = @_ ;
	print "$query\n";
	my $name      = (split(/ /, $query))[0];
	my $date      = (split(/ /, $query))[1];
	my $nbP       = (split(/ /, $query))[2];
	my $speakerID = (split(/ /, $query))[3];


	#$name =~ s/ /+/g; # espace dans les recherche pour ce site
	my @date = split(/\-/, $date);
	if ( @date != 6){ die "check date format dd-mm-yyyy-dd-mm-yyyy\n";}

	my @urlList =(); 

	foreach my $source (keys (%sourceList)){
		#print "$source\n";
		#print "$sourceList{$source}\n";
		my @currentQueryReturned = ();
		my $pageCounter = 0;

		for (my $pageIndex = 1;	$pageCounter <= $nbP; $pageIndex++){		
			my $currentQuery = 'http://www.alvinet.com/actualite/?start='. (($pageIndex - 1 ) * 20 ) .'&keyword=' .$name.'&akeyword=&catid=&periode=entre&ddate='. $date[0] .'%2F'. $date[1] .'%2F'. $date[2] .'&fdate='. $date[3] .'%2F'.$date[4] .'%2F'. $date[5] .'&or=date&source='. $source ; 

			#print "$currentQuery\n";
			my $ua = LWP::UserAgent->new;
			my $response = $ua->get($currentQuery);
			my $content = $response->content;
			#print "$content\n";

			if ($response->is_success) {
				print "". $response->status_line ." : $currentQuery\n";
				my $content = $response->content;
				my @currentQueryReturned = &cleanResultFileALVINET($content);
					
				#print scalar(@currentQueryReturned) ."\n";
				if ( scalar(@currentQueryReturned) == 0){
					last ;
				}
				else{
					$pageCounter += scalar(@currentQueryReturned) ;
					foreach (@currentQueryReturned){
						print "added : $_\n";
						push @urlList, "$sourceList{$source}"."::"."$speakerID"."::"."$_";
					}
				}
				
			}
			else{
				print "". $response->status_line ."::$currentQuery\n";
				#push @urlList, "". $response->status_line ."::$currentQuery";
				last;
			}
		}
	}
	return @urlList;
}
1;

#++++++++++++++++++++++++++++++++++++++++++#

sub cleanResultFileALVINET{
	# parse the output of the query for the site alvinet
	my ( $content  ) = @_;
	my @URLlist = ();
	my $result = HTML::TreeBuilder::XPath->new;
	$result->parse_content($content);

	my @list = $result->findnodes(q{//div[@class="pw-widget pw-size-small"]});
    for my $l (@list){
		push @URLlist, $l->attr('pw:url') ;
	}
	
	if (scalar(@URLlist) > 0){ 
	        print join(' ', (@URLlist, "\n" ));
	}

        return @URLlist;
}1;


