src=triple
tgt=lex

TEXT=../data/datasets/preprocessed

train=$TEXT/train
valid=$TEXT/dev
test=$TEXT/test

name=train-webnlg-all-delex.tok

mkdir $train/format
mkdir $valid/format
mkdir $test/format

#../data/datasets/preprocessed/train/

for file in $train $valid $test; do
    cp $file/*.$src.bpe $file/format/language.$src
    cp $file/*.$tgt.bpe $file/format/language.$tgt
done

fairseq-preprocess --source-lang $src --target-lang $tgt \
    --trainpref $TEXT/train/format/language --validpref $TEXT/dev/format/language --testpref $TEXT/test/format/language \
    --destdir ../data/datasets/format --joined-dictionary --cpu
