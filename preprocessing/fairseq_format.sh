src=lex
tgt=triple

TEXT=../data/wiki_data

sub_folder=format_lex

train=$TEXT/train
valid=$TEXT/dev
test=$TEXT/test

name=-webnlg-all-delex

mkdir $train/$sub_folder
mkdir $valid/$sub_folder
mkdir $test/$sub_folder


for file in $train $valid $test; do
    cp $file/*$name.tok.$src.bpe $file/$sub_folder/language.$src
    cp $file/*$name.tok.$tgt.bpe $file/$sub_folder/language.$tgt
done

fairseq-preprocess --source-lang $src --target-lang $tgt \
    --trainpref $TEXT/train/$sub_folder/language --validpref $TEXT/dev/$sub_folder/language --testpref $TEXT/test/$sub_folder/language \
    --destdir ../data/wiki_data/$sub_folder --joined-dictionary --cpu
