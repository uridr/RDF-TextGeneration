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
   perl $TOKENIZER -l en < $file.$src.bt.low.camel > $file.tok.bt.low.camel.$src
   perl $TOKENIZER -l en < $file.$tgt.bt.low.camel > $file.tok.bt.low.camel.$tgt
done

# set BPE variable to subword-nmt folder
BPEROOT=$BPE/subword_nmt
BPE_TOKENS=5000
BPE_CODE=codes

# merge files to learn BPE
cat $train.tok.bt.low.camel.$src $train.tok.bt.low.camel.$tgt > $train.bt.low.camel.$src-$tgt

#echo "learn_bpe.py on train.triple-lex..."
python3 $BPEROOT/learn_bpe.py -s $BPE_TOKENS < $train.bt.low.camel.$src-$tgt > $BPE_CODE

for L in $src $tgt; do
    for f in $train.tok.bt.low.camel.$L $valid.tok.bt.low.camel.$L $test.tok.bt.low.camel.$L; do
        echo "apply_bpe.py to ${f}..."
        python3 $BPEROOT/apply_bpe.py -c $BPE_CODE < $f > $f.bpe
    done
done

mv $BPE_CODE $TEXT/$BPE_CODE 
