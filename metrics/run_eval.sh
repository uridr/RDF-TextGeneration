ref=../data/datasets/preprocessed/test/test-webnlg-all-notdelex.lex
hyp=../data/predictions/delex_output.txt.lex

python3 eval.py -R $ref -H $hyp -nr 1 -m bleu,meteor,chrf++,ter

