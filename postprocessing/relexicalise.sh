part=test
file_name=$1.txt


predict=$2

python3 ../postprocessing/output_targets.py $predict $file_name

prefix=delex_
file_name_sorted=$predict$prefix$file_name

python3 ../postprocessing/custom_relexicalise.py $part $file_name_sorted
