#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys, os, argparse, re
sys.path.append("searchEngines/")
sys.path.append("scripts/searchEngines/")
#~ import LIBERATION



if __name__=='__main__':
	parser = argparse.ArgumentParser(description='From a list of query contained in a file, poduce xml documents conaining text articles')
	parser.add_argument('-i', '--input' , dest='input', help='Query file', required=True )
	parser.add_argument('-o', '--outputDir', dest='outputDir', help='OutputDirectory', required=True)
	parser.add_argument('-d', '--done'  , dest='listDone', help='Defines the list of query to process and already processed idStart="0" idEnd="0" idDone="0" included, if -1 project to maxima', required=True)
	parser.add_argument('-v', '--verbose'  , dest='verbose', help='verbose mode', action='store_true')
	args = parser.parse_args()

	
	########## ___loading or creating listDone___ ########	
	
	# default values #
	idStart = -1
	idEnd   = -1
	idDone  = -1
		
	if os.path.exists(args.listDone):
		f = open(args.listDone, 'r')
		listDoneFile = f.readlines()
		f.close()
		
		# check file length
		if len(listDoneFile) > 0:
			for l in listDoneFile :
				if 'idStart="' in l : 
					idStart =  int(l.split('idStart="')[1].split('"')[0].rstrip())
				if 'idEnd="' in l : 
					idEnd =  int(l.split('idEnd="')[1].split('"')[0].rstrip())
				if 'idDone="' in l : 
					idDone =  int(l.split('idDone="')[1].split('"')[0].rstrip())
		

	if args.verbose:
		print 'initial conditions  start=' + str(idStart) + ' end=' + str(idEnd) + ' done='+ str(idDone)
	
	##############################
	
	
	
	#___loading rule file___#
	if not os.path.exists(args.input):
		print('no input file! exiting...')
		exit();

	elif os.path.exists(args.input):
		f = open(args.input, 'r')
		fContent = f.readlines()
		f.close()
		
		
		# check end condition		
		if (idEnd == -1) or (idEnd < idStart):
			idEnd = len(fContent)
		
		
		for line in fContent : 
			if re.match('^<query ', line) :
				#~ print line
				queryId 	= int(line.rstrip().split(' id="')[1].split('"')[0])
				source  	= line.rstrip().split(' source="')[1].split('"')[0]
				pattern 	= line.rstrip().split(' pattern="')[1].split('"')[0]
				startY  	= line.rstrip().split(' startY="')[1].split('"')[0]
				startM  	= line.rstrip().split(' startM="')[1].split('"')[0]
				startD  	= line.rstrip().split(' startD="')[1].split('"')[0]
				endY  		= line.rstrip().split(' endY="')[1].split('"')[0]
				endM  		= line.rstrip().split(' endM="')[1].split('"')[0]
				endD  		= line.rstrip().split(' endD="')[1].split('"')[0]
				nbLink  	= line.rstrip().split(' nbLink="')[1].split('"')[0]
				key  		= line.rstrip().split(' key="')[1].split('"')[0]
				
				# verification que cette item n'a pas déjà été traitée queryId est unique pour un fichier d'entrée #
				if (queryId > idDone) and (queryId <= idEnd) and (queryId >= idStart):
					
					currentQuery =pattern + ' ' + startD+'-'+startM+'-'+startY+'-'+endD+'-'+endM+'-'+endY + ' ' + nbLink + ' ' + key
				
					urlList = list()
					
					if source == 'alvinet' :
						print "alvinet"
						# ajout de la modification de la source
						
						#~ urlList = &ALVINET::produceAddressURL(currentQuery);
						#~ foreach (@list){print "$_\n";}
						#~ &write2ListFile($outputFile, @list);
			
					elif source == 'liberation':
						# peut permettre de généraliser la gestion de modules en les chargeant si nécessaire.
						module = __import__(source.upper())
						
						#~ (urlList, urlQuery) = LIBERATION.produceAddressURL(currentQuery)
						#~ (urlList, urlQuery) = module.produceAddressURL(currentQuery)
						urlList = module.produceAddressURL(currentQuery)
						
						print( str(queryId) + ' ' + currentQuery + ": " + str(len(urlList)) + ' documents trouvés') 
						
						#~ print urlList
						
						

					
					# ___________ extraction contenu article ______________#
					
					if len(urlList) > 0:
						try:
							os.makedirs(args.outputDir+'/'+key+'/')
						except OSError :
							pass
													
						# recuperation des conenus de articles dans une structure pour une écriture en une seule fois						
						contenu = list()

						#~ print 'extracting content'
						for link in urlList :
							requete = link[0]
							article = link[1]
							
															
							# peut permettre de généraliser la gestion de modules en les chargeant si nécessaire.
							#~ contenu.append([link , LIBERATION.cleanResultFile(link)])
							
							module = __import__(source.upper())
							contenu.append([requete, article , module.cleanResultFile(article)])
												
						#___ ecriture du contenu de l'article_____#
						#~ print 'writing output'
						
						f = open( args.outputDir +'/'+key+'/'+ key+'.'+str(queryId) +'.xml'  ,'w')

						f.write('<?xml version="1.0" encoding="UTF-8"?>'+'\n' + '<corpus key="' +key+'" id="' + str(queryId) + '" source="' + source +'" date="'+ str(startY)+'-'+str(startM)+'-'+str(startD) +'-'+str(endY)+'-'+str(endM)+'-'+str(endD)+'">'+'\n')
							
						
						for i in contenu:
							#~ ligne = ''.join(i[1]).encode('utf-8')
							ligne = i[2].encode('utf-8').replace('<', '&lt;').replace('>', '&gt;').replace(' & ', ' &amp; ').replace('&nbsp', ' ')
							f.write('<doc key="'+key+'" link="'+ i[1].replace('&', '&amp;') +'" query="'+ i[0].replace('&', '&amp;') +'" date="'+str(startY)+'-'+str(startM)+'-'+str(startD) +'-'+str(endY)+'-'+str(endM)+'-'+str(endD) +'" id="'+str(queryId)+'">'+ligne+'</doc>'+'\n')
						f.write('</corpus>')
						f.close()
							
							
							
					
					
					f = open(args.listDone, 'w')
					f.write('idStart="'+str(idStart)+'" idEnd="'+str(idEnd)+'" idDone="'+str(queryId)+'"')
					f.close()					

				elif (queryId > idEnd) :
					break
						
					


			
			

	
		

