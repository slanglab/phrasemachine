# Output phrase instance extractions in a format intended to be diffable
import sys
sys.path.insert(0, "../py")
import phrasemachine

for filename in sys.argv[1:]:
    print "\n=== FILE", filename
    text = open(filename).read().decode("utf-8",'replace')
    pp = phrasemachine.get_phrases(text, output=['token_spans', 'tokens', 'pos'])
    spans = pp['token_spans']
    spans.sort()  ## (s,e) in lexicographic order
    for s,e in spans:
        phrase = u" ".join(pp['tokens'][s:e]).lower()
        tagstr = " ".join(pp['pos'][s:e])
        out = u"%d %d\t%s\t%s" % (s,e, phrase, tagstr)
        print out.encode("utf-8")
