src=triple
tgt=lex

TEXT=../data/benchmark/preprocessed

train=$TEXT/train/train-webnlg-all-notdelex
valid=$TEXT/dev/dev-webnlg-all-notdelex
test=$TEXT/test/test-webnlg-all-notdelex

# set MOSESDECODER variable to mosesdecoder folder
TOKENIZER=$MOSESDECODER/scripts/tokenizer/tokenizer.perl

# tokenize train valid and test:
for file in $train $valid $test; do
   perl $TOKENIZER -l en < $file.$src.low.camel > $file.tok.low.camel.$src
   perl $TOKENIZER -l en < $file.$tgt.low.camel > $file.tok.low.camel.$tgt
done

# set BPE variable to subword-nmt folder
BPEROOT=$BPE/subword_nmt
BPE_TOKENS=20000
BPE_CODE=codes
BPE_THRS=50

# merge files to learn BPE
cat $train.tok.low.camel.$src $train.tok.low.camel.$tgt > $train.low.camel.$src-$tgt


python3 $BPEROOT/learn_joint_bpe_and_vocab.py --input $train.tok.low.camel.$src $train.tok.low.camel.$tgt -s $BPE_TOKENS -o $BPE_CODE --write-vocabulary vocabulary.$src vocabulary.$tgt

#echo "learn_bpe.py on train.triple-lex..."
#python3 $BPEROOT/learn_bpe.py -s $BPE_TOKENS < $train.low.camel.$src-$tgt > $BPE_CODE

for L in $src $tgt; do
    for f in $train.tok.low.camel.$L $valid.tok.low.camel.$L $test.tok.low.camel.$L; do
        echo "apply_bpe.py to ${f}..."
        python3 $BPEROOT/apply_bpe.py -c $BPE_CODE --vocabulary vocabulary.$L --vocabulary-threshold $BPE_THRS < $f > $f.bpe
    done
done



