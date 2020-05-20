#!/bin/bash

prefix=delex_

for d in ~/Desktop/RDF-TextGeneration/data/predictions/*/ ; do
     . ../postprocessing/relexicalise.sh $(basename $d) $d 
     . run_eval.sh $d$prefix$(basename $d).txt.lex
done

