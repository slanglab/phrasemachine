Have you ever tried using word counts to analyze a collection of documents?
Lots of important concepts get missed, since they don't appear as single words
(unigrams).  For example, the words "social" and "security" don't fully
represent the concept "social security"; the words "New" and "York" don't
really represent "New York." Phrasemachine identifies these sort of multiword
phrases automatically.

    import phrasemachine
    text = "Barack Obama supports expanding social security."
    print phrasemachine.get_phrases(text)
    {'counts': Counter({'social security': 1, 'barack obama': 1})}

#### Installation

    pip install phrasemachine

#### Merging

TODO

#### Special configurations  

phrasemachine depends on [NLTK](http://www.nltk.org/) for its part-of-speech
tagger; it uses NLTK by default.  (Or, it can be used with the higher accuracy
[spaCy](https://spacy.io/) tagger; or any other you want.)

TODO:
- twitter pos tagger
- normalization (Barack Obama => barack obama)
- tokenization
- not just noun phrases (noun-verb?)
- custom regex
- custom pos tagging

#### Natural language processing

If you've spent some time working with text data you've probably heard of named
entities. Maybe you’ve used tools like StanfordCoreNLP or AlchemyAPI to extract
entities from text. Phrasemachine is related but a little different.  Instead
of trying to just label, for example, people or places, it tries to extract all
of the important **noun phrases** from documents.  This includes names, but also
more general concepts like "defense spending," "estate tax," or "car mechanic."
The downside is it doesn't place phrases into categories like "New
York"=LOCATION.

If you are familiar with the idea of a "bag of words" you can think of
phrasemachine as finding extra phrases to place into this bag.  For example, it
can be used to find frequently occurring terms in political debates.
Mathematically, its output can be used to augment the term-document matrix.

Phrasemachine is an elaboration of work from Justeston and Katz (1995);
they found that many technical terms such as ''gaussian distribution'' matched
a regular expression over the part of speech tags for a sequence of words.
Researchers have found the approach useful in
[many](http://vis.stanford.edu/papers/keyphrases)
[different](http://personalpages.manchester.ac.uk/staff/sophia.ananiadou/ijodl2000.pdf)
[contexts](http://www.aclweb.org/anthology/Q14-1029).

phrasemachine was written by Abram Handler, Matthew J. Denny, and Brendan O'Connor.

More details can be found in [this paper](http://brenocon.com/handler2016phrases.pdf): "Bag of What? Simple Noun Phrase Extraction for Text Analysis," Handler, Denny, Wallach, and O'Connor, 2016.

