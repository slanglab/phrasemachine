# Generate output in python to compare ot R output
# can only be run from the py directory, and only in interactive shell

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
 
# output POS tags   
pos_tags = phrasemachine.get_phrases(text, output='pos')

with open('python_pos_tags.json', 'w') as outfile:
    json.dump(pos_tags, outfile)

# output tokens    
tokens = phrasemachine.get_phrases(text, output='tokens')

with open('python_tokens.json', 'w') as outfile:
    json.dump(tokens, outfile)
    