#!/bin/bash

prefix=delex_

for d in ~/Desktop/RDF-TextGeneration/data/predictions/*/ ; do
    source relexicalise.sh $(basename $d) $d 
    source ../metrics/run_eval.sh $d$prefix$(basename $d).txt.lex
done

