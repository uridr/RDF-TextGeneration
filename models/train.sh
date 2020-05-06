fairseq-train ../data/datasets/preprocessed/train/triple-lex  \
			--lr 0.25 --clip-norm 0.1 --dropout 0.2 --max-tokens 4000 \
			--arch fconv_iwslt_de_en \
			--source-lang en --target-lang en \

