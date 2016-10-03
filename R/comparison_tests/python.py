# Generate output in python to compare ot R output

# package import
import phrasemachine
import json
import os

# set wd
os.chdir('/Users/matthewjdenny/Documents/Research/Congressional_Bill_Language/EMNLP_2016/phrasemachine/testdata/sotu')

# read in example data
infile = open("1985.txt")
text = infile.read()
infile.close()

# get phrases
phrases = phrasemachine.get_phrases(text)

# write to json
os.chdir('/Users/matthewjdenny/Documents/Research/Congressional_Bill_Language/EMNLP_2016/phrasemachine/R/comparison_tests')

with open('python_phrase_extractions.json', 'w') as outfile:
    json.dump(phrases, outfile)