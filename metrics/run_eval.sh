ref=$2
hyp=$1

python3 eval.py -R $ref -H $hyp -nr 1 -m bleu,meteor,chrf++,ter

