python3 webnlg_baseline_input.py -i ../data/datasets/original/

mv all*.lex ../data/datasets/preprocessed/all/
mv all*.triple ../data/datasets/preprocessed/all/

mv dev*.lex ../data/datasets/preprocessed/dev/
mv dev*.triple ../data/datasets/preprocessed/dev/


mv test*.lex ../data/datasets/preprocessed/test/
mv test*.triple ../data/datasets/preprocessed/test/

mv train*.lex ../data/datasets/preprocessed/train/
mv train*.triple ../data/datasets/preprocessed/train/
