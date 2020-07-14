data=../data/benchmark/preprocessed
name=-webnlg-all-notdelex

for split in train test dev; do
	rm $data/$split/$split$name.triple.bt.low.camel
	rm $data/$split/$split$name.lex.bt.low.camel

	python3 lower_camel.py $data/$split/$split$name.triple.bt $data/$split/$split$name.triple.bt.low.camel
	python3 lower_camel.py $data/$split/$split$name.lex.bt $data/$split/$split$name.lex.bt.low.camel

done


