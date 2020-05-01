TEXT=../data/datasets/preprocessed

fairseq-preprocess --trainpref $TEXT/train/train-webnlg-all-delex.triple --validpref $TEXT/dev/dev-webnlg-all-delex.triple --testpref  $TEXT/test/test-webnlg-all-delex.triple --cpu --tokenizer moses --bpe bert

mv data-bin/train* $TEXT/train/
mv data-bin/valid* $TEXT/dev/
mv data-bin/test* $TEXT/test/

mv data-bin/dict.txt $TEXT

rmdir data-bin