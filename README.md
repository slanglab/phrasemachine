Have you ever tried using word counts to analyze a collection of documents? You probably noticed that there were important concepts that could not be represented with single words (''unigrams''). The words ''social'' and ''security'' don't fully represent the concept ''social security''; the words ''New'' and ''York'' don't really represent ''New York.'' Phrasemachine identifies these sort of multiword phrases automatically.

    import phrasemachine
    text = "Barack Obama supports expanding social security."
    print phrasemachine.get_phrases(text)
    {'counts': Counter({'social security': 1, 'barack obama': 1})}

#### Installation

    pip install phrasemachine

#### Merging

TODO

#### Special configurations  

- tokenization
- custom regex
- pos tagging

#### Natural language processing

If you've spent some time working with text data you've probably heard of named entities. Maybe you’ve used tools like StanfordCoreNLP or AlchemyAPI to extract entities from text. Phrasemachine is a little different from these kinds of systems. Instead of trying to label all of the people or places, it tries to extract all of the important **phrases** from documents. It doesn't place the phrases into categories (e.g. ''New York",Location) and will extract things that are less concrete than traditional entities (e.g. ''defense spending'').

If you are familiar with the idea of a ''bag of words'' you can think of phrasemachine as finding extra phrases to place into this bag. Political scientists might want to use phrasemachine to augment the term--document matrix. Data journalists might want to use it to find frequently occurring terms in political debates.

Phrasemachine is an elaboration of work from John Justeston and Slava Katz. Three decades ago, Justeson and Katz pointed out that many technical terms such as ''Gaussian Distribution'' matched a regular expression over the part of speech tags for a sequence of words. Researchers have found the approach useful in [many](http://vis.stanford.edu/papers/keyphrases) [different](http://personalpages.manchester.ac.uk/staff/sophia.ananiadou/ijodl2000.pdf)
[contexts](http://www.aclweb.org/anthology/Q14-1029)

phrasemachine was created at [slanglab](http://slanglab.cs.umass.edu/phrases/) at the University of Massachusetts, Amherst --- with help from collaborators at Penn State and Microsoft Research.

The full philosophy (and details) behind the system can be found [here](http://brenocon.com/handler2016phrases.pdf)


