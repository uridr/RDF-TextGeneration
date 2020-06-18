data=../data/benchmark/preprocessed
name=-webnlg-all-notdelex

for split in train test dev; do
	rm $data/$split/$split$name.triple.low.camel
	rm $data/$split/$split$name.lex.low.camel

	python3 lower_camel.py $data/$split/$split$name.triple $data/$split/$split$name.triple.low.camel
	python3 lower_camel.py $data/$split/$split$name.lex $data/$split/$split$name.lex.low.camel

done


