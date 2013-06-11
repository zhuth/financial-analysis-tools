# -*- coding=utf-8 -*-
import sys
import re
import collections
import math

def info_entropy(words):
    result = 0
    total = sum([val for _, val in words.iteritems()])
    for word, cnt in words.iteritems():
        p = float(cnt) / total
        result -= p * math.log(p)
    return result

max_word_len = 5
entropy_threshold = 0.2

content = u'';
file_object = open(sys.argv[1]);
for line in file_object:
    content += line.decode('utf-8');
file_object.close()
	 
content = content.replace(' ', '');

sentences = re.split("\W+|[a-zA-Z0-9]+", content, 0, re.UNICODE)
freq = collections.Counter()
for sentence in sentences:
    if sentence:
        l = len(sentence)
        wl = min(l, max_word_len)
        for i in range(1, wl + 1): 
            for j in range(0, l - i + 1): 
                freq[sentence[j:j + i]] += 1
total = sum([val for _, val in freq.iteritems()])
ps = collections.defaultdict(int)
for word, val in freq.iteritems():
    ps[word] = float(val) / total

words = set()
for word, word_p in ps.items():
    if len(word) > 1:
        p = 0
        for i in range(1, len(word)):
            t = ps[word[0:i]] * ps[word[i:]]
            p = max(p, t)
        if freq[word] >= 3 and word_p / p > 100:
            words.add(word)

final_words = set()
for word in words:
    lf = rf = True
    left_words = collections.Counter()
    right_words = collections.Counter()
    pattern = re.compile(word.join(['.?', '.?']))
    for sentence in sentences:
        l = pattern.findall(sentence)
        if l:
            if l[0][0] != word[0]:
                left_words[l[0][0]] += 1
            else:
                lf = False
            if l[0][-1] != word[-1]:
                right_words[l[0][-1]] += 1
            else:
                rf = False
    left_info_entropy = info_entropy(left_words)
    right_info_entropy = info_entropy(right_words)
    if lf and len(left_words) > 0 and left_info_entropy < entropy_threshold:
        continue
    if rf and len(right_words) > 0 and right_info_entropy < entropy_threshold:
        continue
    final_words.add(word)
words_list = list(final_words)
words_list.sort(cmp = lambda x, y: cmp(freq[y], freq[x]))
file_object = open(sys.argv[2], 'w')
for word in words_list:
	file_object.write(word.encode('utf8') + '\t' + str(freq[word]) + '\n')
