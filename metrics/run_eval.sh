ref=../data/datasets/preprocessed/test/test-webnlg-all-notdelex.lex
hyp=$1

python3 ../metrics/eval.py -R $ref -H $hyp -nr 1 -m bleu,meteor,chrf++,ter

