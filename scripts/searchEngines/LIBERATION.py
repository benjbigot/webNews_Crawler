# -*- coding: utf-8 -*-
#import urllib2, html5lib
import urllib2, lxml.html, re, requests

###_________________________________________________________________________________####

def produceAddressURL(currentQuery):
	'''
		input (str="name dd-mm-yyyy-dd-mm-yyyy numberOfPage Key")
		output (list=list of article URL)
		
		at first generates the url for the searche engine using typical patterns
		then realizes a query on Liberation.fr and return the output html5 page to a list
		finally parses the html page to extract links to liberation articles
		
	'''

	item = currentQuery.rstrip().split(' ')
	name      = item[0] # pattern
	date      = item[1].split('-') # date
	nbP       = int(item[2]) # nb of pages
	speakerID = item[3] # keyName
	
	if len(date) != 6:
		print 'check date ' + date + '\n'
		exit();
	
	urlList = list()
	
	for idPage in range(1, nbP + 1):
		urlList.append('http://www.liberation.fr/recherche/?q=' + name + '&period=custom' + '&period_start_day=' + str(int(date[0])-1) + '&period_start_month=' + date[1] + '&period_start_year=' + date[2] + '&period_end_day=' + date[3] + '&period_end_month=' + date[4] + '&period_end_year=' + date[5] + '&editorial_source=' + '&paper_channel=' + '&sort=-publication_date_time' + '&page=' + str(idPage) + '&period=custom')



	# ___ pour le test ___ #
	#~ urlList = ['http://www.liberation.fr/recherche/?q=sarkozy&period=custom&period_start_day=1&period_start_month=4&period_start_year=2012&period_end_day=2&period_end_month=4&period_end_year=2012&editorial_source=&paper_channel=&sort=-publication_date_time&page=1', 'http://www.liberation.fr/recherche/?q=sarkozy&period=custom&period_start_day=1&period_start_month=4&period_start_year=2012&period_end_day=2&period_end_month=4&period_end_year=2012&editorial_source=&paper_channel=&sort=-publication_date_time&page=2']



	allReturnedURL = list()
	
	for url in urlList :
		# ce sont les urlQuery soumises au moteur de recherche
				
		try : 
			#urllib2.urlopen(url).getcode() != 200:
			f = urllib2.urlopen(url)
			data = f.read()
			f.close()
		
			doc = lxml.html.document_fromstring(data)
			
			
			#text2 = doc.xpath('//div[@id="body-content"]/div[@class="wrapper line"]/div[@class="grid-2-1 main-content line"]/div[@class="mod"]/section[@class="timeline"]/div[@class="day"]/ul/li/*/h2/a/@href')
		
			
			#______ url des articles retournés par la requête ________#
			for returnedUrl in doc.xpath('////section[@class="timeline"]/div[@class="day"]/ul/li/*/h2/a/@href') :
				if not re.match('^http' , returnedUrl ):
					allReturnedURL.append([url ,  'http://www.liberation.fr/'+returnedUrl ] )
					
					
		except  urllib2.HTTPError, e:
			#~ print('error ' +  str(e.code))
			break
	
	#~ if args.verbose:
	#~ print len(allReturnedURL)
	
	
	
	#~ exit()
	# if verbose 2
	#~ for i in allReturnedURL :
		#~ print i
		
	#~ return (allReturnedURL	, urlList[0])
	return allReturnedURL
		
		
###______________________________________________________________________________####

def cleanResultFile(url):
	''' input : str(one url)
	output : str (utf8 text of the article) 
	'''
	try :
		f =  requests.get(url, timeout=20)
		doc = lxml.html.document_fromstring(f.text)
		text = doc.xpath('//*/div[@class="article-body mod"]/div/*//text()')
		return ' '.join(text)
	except requests.exceptions.Timeout:
		#~ if verbose :
		print 'probleme de timeout'
		return 'error_server_timeout'
		
	
	

