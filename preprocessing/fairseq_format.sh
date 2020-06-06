src=triple
tgt=lex

TEXT=../data/datasets/preprocessed

sub_folder=format/DELEX_BPE_500

train=$TEXT/train
valid=$TEXT/dev
test=$TEXT/test

name=-webnlg-all-delex

mkdir $train/$sub_folder
mkdir $valid/$sub_folder
mkdir $test/$sub_folder


for file in $train $valid $test; do
	rm $file/$sub_folder/language.$src
    cp $file/*$name.tok.$src.bpe_500 $file/$sub_folder/language.$src
    rm $file/$sub_folder/language.$tgt
    cp $file/*$name.tok.$tgt.bpe_500 $file/$sub_folder/language.$tgt
done

fairseq-preprocess --source-lang $src --target-lang $tgt \
    --trainpref $TEXT/train/$sub_folder/language --validpref $TEXT/dev/$sub_folder/language --testpref $TEXT/test/$sub_folder/language \
    --destdir ../data/datasets/$sub_folder --joined-dictionary --cpu
