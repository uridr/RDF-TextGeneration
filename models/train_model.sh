#!/bin/bash

echo "trainModel requires 1. loss criterion | 2.optimizer | 3.lr | 4.dropout | 5.batch-size | 6.clip-norm | 7.architecture"

trainModel()
{
	fairseq-train ../data/datasets/format \
			--criterion $1 --optimizer $2 --lr $3 --dropout $4 --batch-size $5 \
			--clip-norm $6 \
			--arch $7 \
			--encoder-layers 3 --decoder-layers 3\
			--save-dir ./checkpoints \
			--source-lang triple --target-lang lex
}