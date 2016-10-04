import sys,os
sys.path.insert(0, "../../py")
import phrasemachine as pm


def go(tags, **kwargs):
    pp = pm.get_phrases(postags=tags, output='token_spans', **kwargs)
    return pp['token_spans']
		

# read in the speech
infile=open("POS_tag_sequences.txt")
lines=infile.readlines()
# close the connection
infile.close()


# loop through the lines of the document
spans = [""] * len(lines)
span_counter = 0
for line in lines:
    current = ""
    tags = line.split()
    if len(tags) > 0:
        cur_spans = go(tags)
        for cur in cur_spans:
            # need to increment start of span by 1 to match up with R output
            current += "{" + str(cur[0] + 1) + "," + str(cur[1]) + "}"
        # print current
        spans[span_counter] = current
        span_counter += 1

# write output to txt file
with open("Python_POS_span_results.txt", "w") as text_file:
    for span in spans:
        text_file.write(str(span)+ "\n")