data=../data/benchmark/preprocessed
name=-webnlg-all-notdelex

for split in train test dev; do
	rm $data/$split/$split$name.triple.synthetic.low.camel
	rm $data/$split/$split$name.lex.synthetic.low.camel

	python3 lower_camel.py $data/$split/$split$name.triple.synthetic $data/$split/$split$name.triple.synthetic.low.camel
	python3 lower_camel.py $data/$split/$split$name.lex.synthetic $data/$split/$split$name.lex.synthetic.low.camel

done


