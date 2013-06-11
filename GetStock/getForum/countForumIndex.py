# -*- coding:utf-8 -*-
import sqlite3,datetime

def count(c,sql):
	c.execute(sql)
	r = c.fetchall()
	return r[0][0]

def countIndex(stock):
	cc = sqlite3.connect('../StockData/ForumIndex/INDEX'+stock+'.db')
	c = cc.cursor()
	# Post
	sql = 'select count(*) from index'+stock
	post = count(c,sql)
	# Visit
	sql = 'select sum(click) from index'+stock
	visit = count(c,sql)
	# VisitPage
	visitpage = post/100+1
	# Reply
	sql = 'select sum(reply) from index'+stock
	reply = count(c,sql)
	# ReplyPage
	sql = 'select sum(reply/50+1) from index'+stock+' where reply>0'
	replypage = count(c,sql)
	print stock,post,visit,reply,visitpage,replypage
	return post,visit,reply,visitpage,replypage

def countClick(stock,date):
		cc = sqlite3.connect('../StockData/ForumClick/CLICK'+stock+'.db')
		c = cc.cursor()
		# Post
		sql = 'select count(*) from click'+stock+' where date like \''+date+'%\''
		post = count(c,sql)
		# Visit
		sql = 'select sum(click) from click'+stock+' where date like \''+date+'%\''
		click = count(c,sql)
		# Reply
		sql = 'select sum(reply) from click'+stock+' where date like \''+date+'%\''
		reply = count(c,sql)

		#print stock,click,reply,post
		return click,reply,post


def countClickDay(date):
	SumPost = 0
	SumClick = 0
	SumReply = 0
	stocks = open('../StockData/NameList.txt').read().split('\n')
	for stock in stocks:
		Click, Reply, Post = countClick(stock[2:],date)
		SumPost += Post
		SumClick += Click
		SumReply += Reply
	print date,SumClick,SumReply,SumPost
	
if __name__ == '__main__':
	countClickDay('2012-12-23')
	countClickDay('2012-12-24')
	countClickDay('2012-12-25')
