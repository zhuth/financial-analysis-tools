# -*- coding:utf-8 -*-
import os

if __name__ == '__main__':
	# Done Dic
	dic = {}
	
	# Error
	lists = os.listdir('../sinaStockData/StockTickError')
	for l in lists:
		dic[l] = 0
	lenError = len(dic)
	print 'Error:\t',lenError
	
	# Data
	stocks = open('../sinaStockData/nameList.txt').read().split('\n')
	if len(stocks[-1])==0:
		stocks = stocks[:-1]
	for stock in stocks:
		spath = '../sinaStockData/StockTick/' + stock
		lists = os.listdir(spath)
		for l in lists:
			if os.path.getsize(spath+'/'+l)>0:
				dic[l[0:17]] = 0
	print 'Done:\t',len(dic)-lenError
	# Dic Finish
	
	# Clean List
	count = 0
	for i in xrange(1,20+1):
		lists = open('../sinaStockData/TickList/tickList'+str(i)+'.txt').read().split('\n')
		if len(lists[-1])==0:
			lists = lists[:-1]
		f = open('../sinaStockData/TickList/tickList'+str(i)+'.txt','w')
		for l in lists:
			try:
				x = dic[l]
			except:
				f.write(l+'\n')
				count += 1
		f.close()
	print 'TODO:\t',count