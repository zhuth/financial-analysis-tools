# -*- coding:utf-8 -*-
import urllib2,os,time,datetime,sys,string

# clean HTML
def clean(news):
	while ('<' in news and '>' in news):
		start = news.find('<')
		end = news.find('>')
		if start<end:
			news = news[:start] + news[end+1:]
		else:
			news = news[:end] + news[end+1:]
	news = news.replace('&nbsp;','')
	news = news.replace('\t','')
	news = news.replace('\xa1\xa1\xa1\xa1','')
	news = news.replace(' ','')
	return news

def download(stock):
	# Day Data
	fday = open('../sinaStockData/StockDay/'+stock+'.txt','w')
	# TickLists
	ftick = open('../sinaStockData/TickLists/'+stock+'.txt','w')
	
	endYear = string.atoi(str(datetime.datetime.now())[0:4])
	startYear = 1990
	
	for year in xrange(endYear,startYear-1,-1):
		for season in xrange(4,0,-1):
			#print stock,year,season
			url = "http://money.finance.sina.com.cn/corp/go.php/vMS_FuQuanMarketHistory/stockid/"+stock[2:]+".phtml?year="+str(year)+"&jidu="+str(season)
			try:
				web = urllib2.urlopen(url).read()
			except:
				print 'Download Error:\t',stock,year,season
				ferr = open('../sinaStockData/StockDayError/Down_'+stock+'_'+str(year)+'_'+str(season)+'.txt','w')
				ferr.close()
				continue
			# To UTF-8
			try:
				web = web.decode('gbk','ignore').encode('utf-8')
			except:
				print 'Code Error:\t',stock,year,season
				ferr = open('../sinaStockData/StockDayError/Code_'+stock+'_'+str(year)+'_'+str(season)+'.txt','w')
				ferr.close()
			web = web.split('\n')
			flag = 0
			data = ''
			
			# Get Data
			for line in web:
				if 'FundHold' in line and flag==1:
						break
				if '<td><div align=\"center\">' in line and 'strong' not in line:
					flag = 1
				if flag == 1:
					text = clean(line)
					if len(text)>0:
						if '-' in text:
							if data != '' and len(data)>0:
								fday.write(data+'\n')
							data = text[0:4]+text[5:7]+text[8:10]
							ftick.write(stock+'_'+data+'\n')
						else:
							data = data +'\t'+text
			if len(data)>0:
				fday.write(data+'\n')			
	fday.close()
	ftick.close()
	return 1

if __name__ == '__main__':
	no = sys.argv[1]
	#no = "1"
	dname = '../sinaStockData/DayList/dayList'+ no +'.txt'
	stocks = open(dname).read().split('\n')
	if len(stocks[-1])==0:
		stocks = stocks[:-1]
	count = 0
	for stock in stocks:
		download(stock)
		count += 1
		print no,count
	print '\t\tDone: ',no