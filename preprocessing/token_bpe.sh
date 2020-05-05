src=triple
tgt=lex

TEXT=../data/datasets/preprocessed

train=$TEXT/train/train-webnlg-all-delex
valid=$TEXT/dev/dev-webnlg-all-delex
test=$TEXT/test/test-webnlg-all-delex

# set MOSESDECODER variable to mosesdecoder folder
TOKENIZER=$MOSESDECODER/scripts/tokenizer/tokenizer.perl

# tokenize train valid and test:
for file in $train $valid $test; do
   perl $TOKENIZER -l en < $file.triple > $file.tok.triple
   perl $TOKENIZER -l en < $file.lex  > $file.tok.lex
done

# set BPE variable to subword-nmt folder
BPEROOT=$BPE/subword_nmt
BPE_TOKENS=10000
BPE_CODE=code

# merge files to learn BPE
cat train.tok.triple train.tok.lex > train.triple-lex

echo "learn_bpe.py on train.triple-lex..."
python3 $BPEROOT/learn_bpe.py -s $BPE_TOKENS < train.triple-lex > $BPE_CODE

for L in $src $tgt; do
    for f in $train.$L $valid.$L $test.$L; do
        echo "apply_bpe.py to ${f}..."
        python3 $BPEROOT/apply_bpe.py -c $BPE_CODE < $tmp/$f > $prep/$f
    done
done
