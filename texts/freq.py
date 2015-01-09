import time
from string import punctuation

N = 10
words = {}
start_time = time.time()
words_gen = (word.strip(punctuation).lower() for line in open("big.txt")
                                             for word in line.split())

print words_gen

for word in words_gen:
    words[word] = words.get(word, 0) + 1

top_words = sorted(words.iteritems(), 
                   key=lambda(word, count): (-count, word))[:N] 

elapsed  = time.time() -start_time
print "seconds count: " 
print elapsed
for word, frequency in top_words:
    print "%s: %d" % (word, frequency)


