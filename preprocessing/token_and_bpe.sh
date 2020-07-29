src=triple
tgt=lex

TEXT=../data/datasets/preprocessed

train=$TEXT/train/train-webnlg-all-notdelex
valid=$TEXT/dev/dev-webnlg-all-notdelex
test=$TEXT/test/test-webnlg-all-notdelex

# set MOSESDECODER variable to mosesdecoder folder
TOKENIZER=$MOSESDECODER/scripts/tokenizer/tokenizer.perl

# tokenize train valid and test:
for file in $train $valid $test; do
   perl $TOKENIZER -l en < $file.$src.synthetic_enriched.low.camel > $file.tok.synthetic_enriched.low.camel.$src
   perl $TOKENIZER -l en < $file.$tgt.synthetic_enriched.low.camel > $file.tok.synthetic_enriched.low.camel.$tgt
done

# set BPE variable to subword-nmt folder
BPEROOT=$BPE/subword_nmt
BPE_TOKENS=5000
BPE_CODE=codes

# merge files to learn BPE
cat $train.tok.synthetic_enriched.low.camel.$src $train.tok.synthetic_enriched.low.camel.$tgt > $train.synthetic_enriched.low.camel.$src-$tgt

#echo "learn_bpe.py on train.triple-lex..."
python3 $BPEROOT/learn_bpe.py -s $BPE_TOKENS < $train.synthetic_enriched.low.camel.$src-$tgt > $BPE_CODE

for L in $src $tgt; do
    for f in $train.tok.synthetic_enriched.low.camel.$L $valid.tok.synthetic_enriched.low.camel.$L $test.tok.synthetic_enriched.low.camel.$L; do
        echo "apply_bpe.py to ${f}..."
        python3 $BPEROOT/apply_bpe.py -c $BPE_CODE < $f > $f.bpe
    done
done

mv $BPE_CODE $TEXT/$BPE_CODE 
