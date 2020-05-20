#!/bin/bash

prefix=delex_

for d in ~/Desktop/RDF-TextGeneration/data/predictions/*/ ; do
     sh ../postprocessing/relexicalise.sh $(basename $d) $d 
     sh run_eval.sh $d$prefix$(basename $d).txt.lex
done

