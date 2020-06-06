ref=../data/datasets/preprocessed/test/test-webnlg-all-notdelex.lex.low.camel
hyp=$1

python3 eval.py -R $ref -H $hyp -nr 1 -m bleu,meteor,chrf++,ter

