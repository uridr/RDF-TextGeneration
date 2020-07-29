data=../data/datasets/preprocessed
name=-webnlg-all-notdelex

for split in train test dev; do
	rm $data/$split/$split$name.triple.synthetic_enriched.low.camel
	rm $data/$split/$split$name.lex.synthetic_enriched.low.camel

	python3 lower_camel.py $data/$split/$split$name.triple.synthetic_enriched $data/$split/$split$name.triple.synthetic_enriched.low.camel
	python3 lower_camel.py $data/$split/$split$name.lex.synthetic_enriched $data/$split/$split$name.lex.synthetic_enriched.low.camel

done


