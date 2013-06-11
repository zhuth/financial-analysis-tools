# -*- coding:utf-8 -*-
import urllib2,os,time,datetime,sys

def download(stock,date):
	day = date[0:4]+'-'+date[4:6]+'-'+date[6:8]
	url = 'http://market.finance.sina.com.cn/downxls.php?date='+day+'&symbol='+stock.lower()
	try:
		text = urllib2.urlopen(url).read()
	except:
		print 'Download Error',stock,date
		fname = '../sinaStockData/StockTickError/Down_'+stock.upper()+'_'+date
		f = open(fname,'w')
		f.close()
		return 0
	try:
		text = text.decode('gbk','ignore').encode('utf-8')
	except:
		print 'Code Error',stock,date
	if text[0:7] == '<script':
		fname = '../sinaStockData/StockTickError/Blank_'+stock.upper()+'_'+date
		f = open(fname,'w')
		f.close()
		return 0
	fname = '../sinaStockData/StockTick/'+stock.upper()+'/'+stock.upper()+'_'+date+'.txt'
	f = open(fname,'w')
	f.write(text)
	f.close()
	return 1

if __name__ == '__main__':
	no = sys.argv[1]
	tname = '../sinaStockData/TickList/tickList'+ no +'.txt'
	ticks = open(tname).read().split('\n')
	if len(ticks[-1])==0:
		ticks = ticks[:-1]
	count = 1
	for i in ticks:
		count += download(i[0:8],i[9:])
		if count%100 == 0:
			print no,'\t',count
	print 'Done'