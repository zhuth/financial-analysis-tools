# -*- coding=utf-8 -*-
import collections
import re
import os

# Usage:
#   我的做法是把WordsDetector.py里的结果输出到文件，
#   然后把文件名放到下面的names列表中，运行本程序。

names = os.listdir('D:\\temp\\fq');
#names = ['000001.txt_fq.txt', '000002.txt_fq.txt', '000004.txt_fq.txt', '000005.txt_fq.txt', '000006.txt_fq.txt', '000007.txt_fq.txt', '000008.txt_fq.txt'];

words = dict([(i, collections.Counter()) for i in names])
total_words = collections.Counter()

for name in names:
	f = open('D:\\temp\\fq\\' + name)
	for line in f:
		try:
			word, freq = line.split('\t')
		except:
			continue;
		if not re.findall('[\x80-\xff].', word) or len(word) < 4: continue
		words[name][word] += int(freq)
	total_words += words[name]

ps = dict([(i, collections.defaultdict(int)) for i in names])

for name in names:
	print name[0:8], '\t', 
	cnt = total = avg = 0.0 
	for word, freq in words[name].iteritems():
		cnt += 1
		total += total_words[word]
		avg += float(freq) / total_words[word]
	total /= cnt 
	avg /= cnt 
	avg_times_total = total * avg 
	for word, freq in words[name].iteritems():
		ps[name][word] = (float(freq) + avg_times_total) / (total_words[word] + total)
	word_list = list(set(words[name]))
	word_list.sort(cmp = lambda x, y: cmp(ps[name][y], ps[name][x]))
	cnt = 0 
	for word in word_list:
		#print '* ', word, ps[name][word]
		print word,
		cnt += 1
		if cnt >= 30: break
	print ''