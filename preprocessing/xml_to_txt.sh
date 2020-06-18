python3 webnlg_baseline_input.py -i ../data/benchmark/original/

rm all*.lex ../data/datasets/preprocessed/all/
rm all*.triple ../data/datasets/preprocessed/all/

rm dev*.lex ../data/benchmark/preprocessed/dev/
rm dev*.triple ../data/benchmark/preprocessed/dev/


mv test*.lex ../data/benchmark/preprocessed/test/
mv test*.triple ../data/benchmark/preprocessed/test/

rm train*.lex ../data/benchmark/preprocessed/train/
rm train*.triple ../data/benchmark/preprocessed/train/
