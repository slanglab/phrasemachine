import sys,os,random
from phrasemachine import phrasemachine as pm; reload(pm)
text=open("sloths.txt").read()
# text = open("testdata/wine-nltk.txt").read().decode("utf8",'ignore')
# tt=pm.get_stdeng_spacy_tagger()
d=tt.tag_text(text)

def loop():
    while True:
        pat = raw_input("Pattern: ")
        # p = pm.get_phrases(tokens=d['tokens'], postags=d['pos'], regex=pat, minlen=1)['counts']
        p = pm.get_phrases(open("sloths.txt").read(), tagger='spacy', regex=pat, minlen=1)['counts']
        phrases = p.keys()
        ptok = []
        for phrase in phrases:
            # print [phrase]
            ptok += [phrase]*p[phrase]
        if len(ptok) < 10:
            xx = ptok
        else:
            xx = [random.choice(ptok) for i in xrange(10)]
        # xx = [random.choice(phrases) for i in xrange(10)]
        # print xx
        print u', '.join(xx).encode("utf8")


