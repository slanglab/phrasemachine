# assuming this is run by pytest: http://doc.pytest.org/en/latest/
# e.g.
# py.test tests/unittests.py
# or
# py.test -s tests/unittests.py

from __future__ import print_function


import sys,os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
import phrasemachine as pm
import pytest

def test_pos():
    def go(tags, **kwargs):
        pp = pm.get_phrases(postags=tags, output='token_spans', **kwargs)
        return pp['token_spans']

    tags = "JJ NN NN".split()
    assert set(go(tags)) == set([ (0,2), (0,3), (1,3) ])
    tags = "VB JJ NN NN".split()
    assert set(go(tags)) == set([ (1,3), (1,4), (2,4) ])
    tags = "VB JJ NN".split()
    assert set(go(tags)) == set([ (1,3) ])
    tags = "NN".split()
    assert set(go(tags)) == set()

def test_minmaxlen():
    tags = "NN NN NN".split()
    assert (0,3) in pm.extract_ngram_filter(tags)

    assert (0,3) in pm.extract_ngram_filter(tags, maxlen=3)
    assert (0,3) not in pm.extract_ngram_filter(tags, maxlen=2)
    assert len(pm.extract_ngram_filter(tags, maxlen=0)) == 0

    assert (0,) not in pm.extract_ngram_filter(tags), "default should exclude unigrams"
    assert (0,) not in pm.extract_ngram_filter(tags, minlen=2)
    assert (0,1) not in pm.extract_ngram_filter(tags, minlen=3)
    assert (0,3) in pm.extract_ngram_filter(tags, minlen=3)

def test_basic_tagging():
    # Have to pick an example easy for the tagger
    pp = pm.get_phrases("Red stock market",output=['pos','tokens','token_spans','counts'])
    assert pp['pos']=="JJ NN NN".split(), "this test failure may be due to tagger uncertainty... though unlikely..."
    assert set(pp['token_spans']) == set([ (0,2), (0,3), (1,3) ])

    assert len(pp['counts'])==3
    assert pp['counts']['red stock']==1
    assert pp['counts']['red stock market']==1
    assert pp['counts']['stock market']==1

def test_len_toks_equals_len_tags_nltk():
    text = "Hi I like this. OK another sentence."
    docutils = pytest.importorskip("nltk")
    # http://doc.pytest.org/en/latest/skipping.html#skipping-on-a-missing-import-dependency
    x = pm.get_stdeng_nltk_tagger().tag_text(text)
    assert len(x['tokens']) == len(x['pos'])

def test_bad_counts_example():
    phrases = pm.get_phrases("Social security is a law. Gravity is one too. Cheeseburgers are tasty.")
    assert phrases['counts']['social security'] == 1

def test_bad_counts_example_2():
    phrases = pm.get_phrases("Social security is a law. Gravity is one too. Cheeseburgers are tasty. Social security is in a lockbox.")
    assert phrases['counts']['social security'] == 2

def test_multisentence():
    pp = pm.get_phrases("blue table. blue table. blue table.")
    print(pp)
    assert len(pp['counts'])==1  ## should be just 'blue table'.  if buggy, it can pick up spans across sentences
