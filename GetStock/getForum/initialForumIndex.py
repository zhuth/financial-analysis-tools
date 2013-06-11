# -*- coding:utf-8 -*-
import string,urllib2,datetime,os,sqlite3,multiprocessing

def download(url): # Robust Downloader
	error = 0
	while error < 3: # Max Download Error
		try:
			web = urllib2.urlopen(url).read().decode('gbk','ignore').encode('utf-8')
			return web
		except:
			error += 1
	
	print 'Download Error:',error
	return 'error'

def findClass(line,no): # Find Content
	if no!=3:
		start = line.find('<li class=l'+str(no)+'>')
		end = line.find('</li>')
		text = line[start+13:end]
		line = line[end+5:]
	else:
		start = line.find('a href')
		end   = line.find('.html')
		link = line[start+8:end+5]
		start = line.find('html')+line[line.find('html'):].find('>')
		end = line.find('</a>')
		text = link+'#'+line[start+1:end]
		line = line[end+9:]
	return text.replace('\'',''),line

def logError(stock,error,text): # Error Log
	f=open(error+'Error.log','a')
	f.write(stock+'\t'+text+'\n')
	f.close()
	return

def getForumIndex(stock):
	start = datetime.datetime.now()
	if os.path.exists('../StockData/ForumIndex/INDEX'+stock+'.db') == True:
		print stock,'Existed'
		return 0
	# Find Max Pages
	topic = download('http://guba.eastmoney.com/topic,'+stock+'.html')
	if topic == 'error':
		print 'Stock Error:',stock
		logError(stock,'Stock','')
		return 0
	pos = topic.find('var page_num=') # Num of Post: var num
	try:
		pages = string.atoi(topic[pos+13:pos+topic[pos:].find(';')])
		print stock,'Start',pages # max pages
	except:
		print 'Max Error:',stock
		print stock,'Start'
		logError(stock,'Max','')
		pages = 250 # Average Pages

	# Initial 
	num = 0	# post count
	# Create Database
	conn = sqlite3.connect('../StockData/ForumIndex/INDEX'+stock+'.db')
	c = conn.cursor()
	sql = 'CREATE TABLE index'+str(stock)+' (click integer , reply integer, title text, author text, upgrade text, release text)'
	c.execute(sql)

	# Crawler
	for page in range(1,pages+1):
		text = download('http://guba.eastmoney.com/topic,'+stock+'_'+str(page)+'.html')
		if text=='error':
			print 'Page Error:',stock,'/',page
			logError(stock,'Page',str(page))
			continue
			
		line = text[text.find('div class=\'h'):] # Find Item
		while 'class=l1' in line:
			click,line = findClass(line,1)
			reply,line = findClass(line,2)
			title,line = findClass(line,3)
			author,line= findClass(line,4)
			upgrade,line= findClass(line,5)
			release,line=findClass(line,6)
			num += 1
			#print num,click,reply,title,author,upgrade,release
			try:
				sql= 'INSERT INTO index'+str(stock)+' values ('+click+','+reply+',\''+title+'\',\''+author+'\',\''+upgrade+'\',\''+release+'\' )'
				c.execute(sql)
			except:
				print 'SQL Error:',stock,'/',page
				logError(stock,'SQL',str(page)+':'+sql)
		#print page,':',count

	conn.commit()
	end = datetime.datetime.now()
	print stock,'MaxPage:',pages,'Posts:',num,'Time:',end-start
	return 0 

if __name__ == '__main__':
	print 'InitialForumIndex Start'
	stocks = open('../StockData/NameList.txt').read().split('\n')
	pool = multiprocessing.Pool(processes=20) # MultiProcessor
	for stock in stocks:
		pool.apply_async(getForumIndex,(stock[2:],))
	pool.close()
	pool.join()
	print 'InitialForumIndex Done'
