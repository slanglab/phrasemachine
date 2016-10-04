# run with: bash run_POS_to_spans_test.sh
# should not print anything to the console if all went well
# checks R and Python POS span finding results against eachother
echo "generating R results..."
# note that a .Rout file will be generated which records what R did
# This can be ignored and deleted
R CMD Batch --no-save --no-restore R_POS_to_spans_test.R R_POS_to_spans_test.Rout
echo "generating Python results..."
python Python_POS_to_spans_test.py
echo "comparing results: if no output is printed below, then results are identical..."
# should produce no output if there are no differences
comm -3 Python_POS_span_results.txt R_POS_span_results.txt