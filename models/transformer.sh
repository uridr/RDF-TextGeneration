#!/bin/bash

echo "trainModel requires 1. loss criterion | 2.optimizer | 3.lr | 4.dropout | 5.batch-size | 6.clip-norm | 7.encoder-layers | 8.decoder-layers | 9.max-epoch"

trainModel()
{
	fairseq-train ../data/datasets/format \
			--criterion $1 --optimizer $2 --lr $3 --dropout $4 --batch-size $5 \
			--clip-norm $6 \
			--arch transformer \
			--encoder-layers $7 --decoder-layers $8\
			--max-epoch $9 \
			--save-dir ./checkpoints_transformer \
			--source-lang triple --target-lang lex \
			--eval-bleu-detok moses \
			--eval-bleu-remove-bpe \
}