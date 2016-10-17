Have you ever tried using word counts to analyze a collection of documents?
Lots of important concepts get missed, since they don't appear as single words
(unigrams).  For example, the words "social" and "security" don't fully
represent the concept "social security"; the words "New" and "York" don't
really represent "New York." Phrasemachine identifies these sort of multiword
phrases automatically so you can use them in text analysis. Here's how it works in Python.

    import phrasemachine
    text = "Barack Obama supports expanding social security."
    print phrasemachine.get_phrases(text)
    {'counts': Counter({'social security': 1, 'barack obama': 1})}

For more details, see our paper: [Bag of What?](http://brenocon.com/handler2016phrases.pdf), or [this slidedeck](http://brenocon.com/oconnor_textasdata2016.pdf).  By default, this package uses the (FilterFSA, k=8, SimpleNP) method from the paper.

The software only supports English texts.

#### Installation

We have implementations in both R and Python.

For Python, install with:

    pip install phrasemachine

For R: we have not released on CRAN yet, but this may work in the meantime:

    library(devtools)
    install_github("slanglab/phrasemachine/R/phrasemachine")

The rest of this document gives examples in Python; R-specific documentation is
forthcoming.

#### Near duplicates and merging

You might notice that phrasemachine sometimes extracts nested phrases. For instance,  

    text = "The Omnibus Crime Control and Safe Streets Act of 1968 was signed into law by President Lyndon B. Johnson"
    phrasemachine.get_phrases(text)

extracts 'lyndon b. johnson' and 'b. johnson'. 

This is intentional: phrasemachine tries to extract **all** phrases that might be useful for downstream analysis. In some cases, you might want to try to merge similar, overlapping or cofererent terms. For strategies, see section 4.3.1 from our paper: [Bag of What?](http://brenocon.com/handler2016phrases.pdf)

#### Special configurations  

phrasemachine depends on [NLTK](http://www.nltk.org/) for its part-of-speech
tagger; it uses NLTK by default. It can also be used with the higher accuracy
[spaCy](https://spacy.io/) tagger. To use a custom POS tagging from some other
package, pass a list of tokens and a list of POS tags to the get_phrases method
in [phrasemachine.py](py/phrasemachine/phrasemachine.py).  If you are familiar
and comfortable with POS tagging yourself, all you really need is the
[phrasemachine.py](py/phrasemachine/phrasemachine.py) file.

In the future, we will add discussion of the following:
- twitter pos tagger
- normalization (Barack Obama => barack obama)
- tokenization
- not just noun phrases (noun-verb? adj phrases, any coordinations, verb groups?)
- custom regex

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

More details can be found in [this paper](http://brenocon.com/handler2016phrases.pdf): "Bag of What? Simple Noun Phrase Extraction for Text Analysis," Handler, Denny, Wallach, and O'Connor, 2016; or, [this slidedeck](http://brenocon.com/oconnor_textasdata2016.pdf).


#### Repository structure

 * `py/`: the Python implementation
 * `R/`: the R implementation
 * `fst/`: the OpenFST/pyfst implementation, which is not packaged for use by
 default.  It does the FullNP grammar as specified in the paper.  Since the
 dependencies can be difficult to run, the main implementations above use what
 the paper calls SimpleNP grammar with the FilterFSA matching method.

#### Acknowledgment

"phrasemachine" is named after [Michael Heilman](http://www.cs.cmu.edu/~mheilman/)'s
"phraseomatic" script.
