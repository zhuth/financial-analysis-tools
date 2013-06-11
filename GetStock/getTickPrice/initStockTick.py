# -*- coding:utf-8 -*-
import os

def num2str(i):
	if i>9:
		return str(i)
	else:
		return '0'+str(i)

def folderGenerator(fname):
	# Stock Folder
	if os.path.exists('../sinaStockData/StockTickError') == False:
		os.mkdir('../sinaStockData/StockTickError')
	if os.path.exists('../sinaStockData/StockTick') == False:
		os.mkdir('../sinaStockData/StockTick')
	stocks = open(fname).read().split('\n')
	if len(stocks[-1])==0:
		stocks = stocks[:-1]
	for stock in stocks:
		spath = '../sinaStockData/StockTick/'+stock
		if os.path.exists(spath) == False:
			os.mkdir(spath)
	return 
	
def listGenerator(fname):
	# Stock List
	if os.path.exists('../sinaStockData/TickList') == False:
		os.mkdir('../sinaStockData/TickList')
	stocks = open(fname).read().split('\n')
	if len(stocks[-1])==0:
		stocks=stocks[:-1]
	num = 20
	count = 0
	total = open('../sinaStockData/TickList/tickList0.txt','w')
	for stock in stocks:
		flist = '../sinaStockData/TickList/tickList'+str(count+1)+'.txt'
		f = open(flist,'a')
		ff = open('../sinaStockData/TickLists/'+stock+'.txt').read()
		total.write(ff)
		f.write(ff)
		f.close()
		count = (count+1)%num
	total.close()
	
if __name__ == '__main__':
	# Two Steps
	fname = '../sinaStockData/nameList.txt'
	listGenerator(fname)
	print 'List Done'
	folderGenerator(fname)
	print 'Folder Done'	