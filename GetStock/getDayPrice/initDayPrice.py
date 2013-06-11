# -*- coding:utf-8 -*-
import os

def folderGenerator(fname):
	# Stock Folder
	if os.path.exists('../sinaStockData/TickLists') == False:
		os.mkdir('../sinaStockData/TickLists')
	if os.path.exists('../sinaStockData/StockDay') == False:
		os.mkdir('../sinaStockData/StockDay')
	if os.path.exists('../sinaStockData/StockDayError') == False:
		os.mkdir('../sinaStockData/StockDayError')			
	return 
	
def listGenerator(fname):
	# Stock List
	if os.path.exists('../sinaStockData/DayList') == False:
		os.mkdir('../sinaStockData/DayList')
	stocks = open(fname).read().split('\n')
	if len(stocks[-1])==0:
		stocks=stocks[:-1]
	num = 20
	count = 0
	for stock in stocks:
		flist = '../sinaStockData/DayList/dayList'+str(count+1)+'.txt'
		f = open(flist,'a')
		f.write(stock+'\n')
		f.close()
		count = (count+1)%num
	
if __name__ == '__main__':
	# Two Steps
	fname = '../sinaStockData/nameList.txt'
	
	listGenerator(fname)
	print 'List Done'
	
	folderGenerator(fname)
	print 'Folder Done'
	
	
	