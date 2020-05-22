src=lex
tgt=triple

TEXT=../data/datasets/preprocessed

sub_folder=format_lex_full

train=$TEXT/train
valid=$TEXT/dev
test=$TEXT/test

name=-webnlg-all-notdelex




fairseq-preprocess --source-lang $src --target-lang $tgt \
    --trainpref $TEXT/train/$sub_folder/language --validpref $TEXT/dev/$sub_folder/language --testpref $TEXT/test/$sub_folder/language \
    --destdir ../data/datasets/$sub_folder --joined-dictionary --cpu
