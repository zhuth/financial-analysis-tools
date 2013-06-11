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

def updateForumIndex(stock): # Update
	print stock,'Start'
	start = datetime.datetime.now()

	'''
	# Define Max Page
	topic = download('http://guba.eastmoney.com/topic,'+stock+'.html')
	if topic == 'error':
		print 'Stock Error:',stock
		logError(stock,'Stock','')
		return 0
	pos = topic.find('var page_num=') # Num of Post: var num
	try:
		pages = string.atoi(topic[pos+13:pos+topic[pos:].find(';')])
		#print stock, 'Max Page:',pages
		#return pages
	except:
		print 'Max Error:',stock
		logError(stock,'Max','')
		pages = 250
	'''

	# Connect Database
	num = 0	
	conn = sqlite3.connect('../StockData/ForumIndex/INDEX'+stock+'.db')
	c = conn.cursor()
	vconn = sqlite3.connect('../StockData/ForumClick/CLICK'+stock+'.db')
	vc = vconn.cursor()
	
	# Dictionary
	clickDic = {}
	replyDic = {}
	try:
		sql = 'select click,reply,title from index'+stock
		c.execute(sql)
		result = c.fetchall()
		for i in result:
			clickDic[i[2].encode('utf-8')]=string.atoi(str(i[0]))
			replyDic[i[2].encode('utf-8')]=string.atoi(str(i[1]))
	except:
		# New Stock Index
		sql = 'create table index'+str(stock)+' (click integer, reply integer, title text, author text, upgrade text, release text)'
		c.execute(sql)
	try:	
		# New Click
		sql = 'create table click'+str(stock)+' (date text, click integer, reply integer, title text)'
		vc.execute(sql)
	except:
		error = 1
		
	for page in range(1,20):

		# Latest 20 Pages
		text = download('http://guba.eastmoney.com/topic,'+stock+'_'+str(page)+'.html')
		if text=='error':
			print 'Page Error:',stock,'/',page
			logError(stock,'Page',str(page))
			continue

		# Find Post
		line = text[text.find('div class=\'h'):]
		while 'class=l1' in line:
			click,line = findClass(line,1)
			reply,line = findClass(line,2)
			title,line = findClass(line,3)
			author,line = findClass(line,4)
			upgrade,line = findClass(line,5)
			release,line = findClass(line,6)
			current = str(datetime.datetime.now())[0:19] # Update Time
			num += 1

			try:
				#print 'New Click'
				previousClick = clickDic[title]
				previousReply = replyDic[title]
				currentClick = string.atoi(click)
				currentReply = string.atoi(reply)
				if previousClick!=currentClick or previousReply!=currentReply:
					try:					
						sql= 'insert into click'+str(stock)+' values (\''+current+'\','+str(currentClick-previousClick)+','+str(currentReply-previousReply)+',\''+title+'\' )'
						vc.execute(sql)
					except:
						print 'SQL Error: New Click',stock,'/',page
						logError(stock,'SQL',str(page)+':'+sql)
					try:					
						sql= 'update index'+str(stock)+' set click='+click+',reply='+reply+',author=\''+author+'\',upgrade=\''+upgrade+'\' where title = \''+str(title)+'\''
						c.execute(sql)
					except:
						print 'SQL Error: Update Index',stock,'/',page
						logError(stock,'SQL',str(page)+':'+sql)
			except:
				# New Post
				try:					
					sql= 'insert into index'+str(stock)+' values ('+click+','+reply+',\''+title+'\',\''+author+'\',\''+upgrade+'\',\''+release+'\' )'
					c.execute(sql)
				except:
					print 'SQL Error: New Post',stock,'/',page
					logError(stock,'SQL',str(page)+':'+sql)
				try:					
					sql= 'insert into click'+str(stock)+' values (\''+current+'\','+click+','+reply+',\''+title+'\' )'
					vc.execute(sql)
				except:
					print 'SQL Error: New Index',stock,'/',page
					logError(stock,'SQL',str(page)+':'+sql)
		#print page,':',count
		
	# Update Database
	conn.commit()
	vconn.commit()
	end = datetime.datetime.now()
	print stock,'Updated' #,'MaxPage:',pages,'Posters:',num,'Time:',end-start
	return 0 

if __name__ == '__main__':

	print 'UpdateForumIndex Start'

	stocks = open('../StockData/NameList.txt').read().split('\n')

	pool = multiprocessing.Pool(processes=20)	
	for stock in stocks:
		pool.apply_async(updateForumIndex,(stock[2:],))
	pool.close()
	pool.join()

	print 'UpdateForumIndex Finished'
