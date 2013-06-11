# -*- coding:utf-8 -*-
import urllib2,datetime

def check1(code):
	# Delist Status
	checkURL = "http://money.finance.sina.com.cn/corp/go.php/vCI_CorpOtherInfo/stockid/"+code[2:]+"/menu_num/0.phtml"
	text = urllib2.urlopen(checkURL).read().split('\n')
	for t in xrange(0,len(text)):
		if '上市状态' in text[t].decode('gbk','ignore').encode('utf-8'):
			break
	start = text[t+1].find("\">")+2
	end   = text[t+1].find("</")
	check = text[t+1][start:end]
	return check
	
def check2(code):
	# Latest Price
	checkURL = "http://money.finance.sina.com.cn/corp/go.php/vMS_FuQuanMarketHistory/stockid/"+code[2:]+".phtml"
	text = urllib2.urlopen(checkURL).read().split('\n')
	checkA = 0
	checkB = 0
	for t in xrange(0,len(text)):
		if 'FundHoldSharesTable' in text[t]:
			if checkA ==0:
				checkA = t
			else:
				checkB = t
				break
	if (checkB - checkA)>21:
		return 1
	return "-1"

def check3(code):
	# One Year Price 
	# Warning ! It's current year NOT past one year !!!
	year = str(datetime.datetime.now())[0:4]
	for season in xrange(1,4+1):
		checkURL = "http://vip.stock.finance.sina.com.cn/corp/go.php/vMS_FuQuanMarketHistory/stockid/"+code[2:]+".phtml?year="+year+"&jidu="+str(season)
		text = urllib2.urlopen(checkURL).read().split('\n')
		checkA = 0
		checkB = 0
		for t in xrange(0,len(text)):
			if 'FundHoldSharesTable' in text[t]:
				if checkA ==0:
					checkA = t
				else:
					checkB = t
					break
		if (checkB-checkA)>21:
			return 1
	return "-1"

if __name__ == '__main__':
	print 'StockName Start.'
	# Lists Dic
	lists = {}
	delists = {}
	
	# Get Lists from Stock Forum
	x = datetime.datetime.now()
	count = 0
	delist = 0
	for i in xrange(1,100):
		state = 0
		url = "http://guba.sina.com.cn/?s=category&cid=1&page="+str(i)
		web = urllib2.urlopen(url).read().split('\n')
		for line in web:
			if 's=bar&name=s' in line:
				state += 1
				# Get Stock
				line = line.decode('gbk','ignore').encode('utf-8')
				name = line[line.find('>')+1:line.find('(')]
				code = line[line.find('(')+1:line.find('(')+9]
				# Check Delist
				if check2(code) == "-1": 
					if check1(code) == "-1":
						delist += 1
						print 'Delist',delist,code,name
						delists[code] = name
					else:
						if check3(code) == "-1":
							delist += 1
							print 'Delist',delist,code,name
							delists[code] = name
						else:
							count += 1
							print '\t',count,code,name
							lists[code] = name
				else:
					count += 1
					print '\t',count,code,name
					lists[code] = name
				###
		if state<120:
			break
	
	# List Sort and Output
	lists = sorted(lists.iteritems(), key=lambda d:d[0], reverse = False)
	f1 = open('../StockData/NameList.txt','w')
	f2 = open('../StockData/CNameList.txt','w')
	for l in lists:
		#print l[0],l[1]
		f1.write(l[0].upper()+'\n')
		f2.write(l[0].upper()+'\t'+l[1]+'\n')
	f1.close()
	f2.close()
	
	# Delist Sort and Output
	delists = sorted(delists.iteritems(), key=lambda d:d[0], reverse = False)
	f1 = open('../StockData/Delist.txt','w')
	f2 = open('../StockData/CDelist.txt','w')
	for l in delists:
		#print l[0],l[1]
		f1.write(l[0].upper()+'\n')
		f2.write(l[0].upper()+'\t'+l[1]+'\n')
	f1.close()
	f2.close()
	
	print 'StockName Done.'