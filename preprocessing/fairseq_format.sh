src=triple
tgt=lex

TEXT=../data/datasets/preprocessed

sub_folder=format/LEX_LOW_CAMEL_BPE

train=$TEXT/train
valid=$TEXT/dev
test=$TEXT/test

name=-webnlg-all-notdelex

mkdir $train/$sub_folder
mkdir $valid/$sub_folder
mkdir $test/$sub_folder


for file in $train $valid $test; do
	rm $file/$sub_folder/language.$src
    cp $file/*$name.tok.low.camel.$src.low.camel.bpe_5000 $file/$sub_folder/language.$src
    rm $file/$sub_folder/language.$tgt
    cp $file/*$name.tok.low.camel.$tgt.low.camel.bpe_5000 $file/$sub_folder/language.$tgt
done

fairseq-preprocess --source-lang $src --target-lang $tgt \
    --trainpref $TEXT/train/$sub_folder/language --validpref $TEXT/dev/$sub_folder/language --testpref $TEXT/test/$sub_folder/language \
    --destdir ../data/datasets/$sub_folder --joined-dictionary --cpu
