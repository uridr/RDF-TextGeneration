fairseq-preprocess --trainpref ../data/datasets/preprocessed/train/train-webnlg-all-delex.triple --validpref ../data/datasets/preprocessed/dev/dev-webnlg-all-delex.triple --testpref  ../data/datasets/preprocessed/test/test-webnlg-all-delex.triple --cpu --tokenizer moses --bpe bert

mv data-bin/train* ../data/datasets/preprocessed/train/
mv data-bin/valid* ../data/datasets/preprocessed/dev/
mv data-bin/test* ../data/datasets/preprocessed/test/

mv data-bin/dict.txt ../data/datasets/preprocessed/

rmdir data-bin