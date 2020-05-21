src=triple
tgt=lex

TEXT=../data/benchmark/preprocessed

train=$TEXT/train/train-webnlg-all-delex
valid=$TEXT/dev/dev-webnlg-all-delex
test=$TEXT/test/test-webnlg-all-delex

# set MOSESDECODER variable to mosesdecoder folder
TOKENIZER=$MOSESDECODER/scripts/tokenizer/tokenizer.perl

# tokenize train valid and test:
for file in $train $valid $test; do
   perl $TOKENIZER -l en < $file.$src > $file.tok.$src
   perl $TOKENIZER -l en < $file.$tgt  > $file.tok.$tgt
done

# set BPE variable to subword-nmt folder
BPEROOT=$BPE/subword_nmt
BPE_TOKENS=1000
BPE_CODE=codes

# merge files to learn BPE
cat $train.tok.$src $train.tok.$tgt > $train.$src-$tgt

echo "learn_bpe.py on train.triple-lex..."
python3 $BPEROOT/learn_bpe.py -s $BPE_TOKENS < $train.$src-$tgt > $BPE_CODE

for L in $src $tgt; do
    for f in $train.tok.$L $valid.tok.$L $test.tok.$L; do
        echo "apply_bpe.py to ${f}..."
        python3 $BPEROOT/apply_bpe.py -c $BPE_CODE < $f > $f.bpe
    done
done

mv $BPE_CODE $TEXT/$BPE_CODE
