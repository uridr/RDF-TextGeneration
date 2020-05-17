part=test
file_name=output.txt

predict=../data/predictions/

python3 output_targets.py $predict $file_name

prefix=delex_
file_name_sorted=$prefix$file_name

python3 custom_relexicalise.py $part $predict$file_name_sorted