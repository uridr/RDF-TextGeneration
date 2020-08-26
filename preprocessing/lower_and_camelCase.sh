# set data path
data=../data/benchmark/preprocessed

# set data type: notdelex or delex
name=-webnlg-all-notdelex

# set data experiment
experiment=''
length=$(echo $experiment | wc -c)

for split in train test dev; do

	if [ $length -gt 1 ]
	then
		rm $data/$split/$split$name.triple.$experiment.low.camel
		rm $data/$split/$split$name.lex.$experiment.low.camel

		python3 lower_camel.py $data/$split/$split$name.triple.$experiment $data/$split/$split$name.triple.$experiment.low.camel
		python3 lower_camel.py $data/$split/$split$name.lex.$experiment $data/$split/$split$name.lex.$experiment.low.camel
	
	else
		rm $data/$split/$split$name.triple.low.camel
		rm $data/$split/$split$name.lex.low.camel

		python3 lower_camel.py $data/$split/$split$name.triple $data/$split/$split$name.triple.low.camel
		python3 lower_camel.py $data/$split/$split$name.lex $data/$split/$split$name.lex.low.camel

	fi
done


