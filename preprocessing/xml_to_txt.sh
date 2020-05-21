python3 webnlg_baseline_input.py -i ../data/benchmark/original/

mv all*.lex ../data/datasets/preprocessed/all/
mv all*.triple ../data/datasets/preprocessed/all/

mv dev*.lex ../data/benchmark/preprocessed/dev/
mv dev*.triple ../data/benchmark/preprocessed/dev/


mv test*.lex ../data/benchmark/preprocessed/test/
mv test*.triple ../data/benchmark/preprocessed/test/

mv train*.lex ../data/benchmark/preprocessed/train/
mv train*.triple ../data/benchmark/preprocessed/train/
