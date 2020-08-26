src=triple
tgt=lex

# set data path
TEXT=../data/benchmark/preprocessed

# set data type: notdelex or delex
train=$TEXT/train/train-webnlg-all-notdelex
valid=$TEXT/dev/dev-webnlg-all-notdelex
test=$TEXT/test/test-webnlg-all-notdelex

# set extension
extension=low.camel

# set MOSESDECODER variable to mosesdecoder folder
TOKENIZER=$MOSESDECODER/scripts/tokenizer/tokenizer.perl

# tokenize train valid and test:
for file in $train $valid $test; do
   perl $TOKENIZER -l en < $file.$src.$extension > $file.tok.$extension.$src
   perl $TOKENIZER -l en < $file.$tgt.$extension > $file.tok.$extension.$tgt
done

# set BPE variable to subword-nmt folder
BPEROOT=$BPE/subword_nmt
BPE_TOKENS=1000
BPE_CODE=codes

# merge files to learn BPE
cat $train.tok.$extension.$src $train.tok.$extension.$tgt > $train.$extension.$src-$tgt

#echo "learn_bpe.py on train.triple-lex..."
python3 $BPEROOT/learn_bpe.py -s $BPE_TOKENS < $train.$extension.$src-$tgt > $BPE_CODE

for L in $src $tgt; do
    for f in $train.tok.$extension.$L $valid.tok.$extension.$L $test.tok.$extension.$L; do
        echo "apply_bpe.py to ${f}..."
        python3 $BPEROOT/apply_bpe.py -c $BPE_CODE < $f > $f.bpe
    done
done

mv $BPE_CODE $TEXT/$BPE_CODE 
