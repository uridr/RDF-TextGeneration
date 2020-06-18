#!/bin/bash

prefix=delex_


for d in ../data/predictions/*/ ; do
    for filename in $d*.txt; do
    	#echo $(basename $filename)
    	. ../postprocessing/relexicalise.sh $(basename $filename) $d 
    	. run_eval.sh $d$prefix$(basename $filename).lex ./data/datasets/preprocessed/test/test-webnlg-all-notdelex.lex.low.camel
    done
done

