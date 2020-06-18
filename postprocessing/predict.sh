model=$1
data=$2
output_file=$3

fairseq-generate $data --cpu --remove-bpe --batch-size 128 --beam 4 --path $model/v$i/che/checkpoint_best.pt \
	 --tokenizer moses  --bpe subword_nmt --bpe-codes $data \
	 --source-lang triple --target-lang lex \
	 --task translation > $output_file.txt


mkdir ../data/predictions/$output_file
mv $output_file.txt ../data/predictions/$output_file