# assuming this is run by pytest: http://doc.pytest.org/en/latest/
# e.g.
# py.test tests/unittests.py
# or
# py.test -s tests/unittests.py

import sys,os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
import phrasemachine as pm

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
    assert set(go(tags, include_unigrams=True)) == set([(0,1)])

# def test_basic_tagging():
#     # Have to pick an example easy for the tagger
#     pp = pm.get_phrases("Red stock market",output=['pos','tokens','token_spans'])
#     assert pp['pos']=="JJ NN NN".split(), "this test failure may be due to tagger uncertainty... though unlikely..."
#     assert set(pp['token_spans']) == set([ (0,2), (0,3), (1,3) ])
