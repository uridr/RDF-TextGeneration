fairseq-preprocess --source-lang lex --target-lang triple \
		   --trainpref ../data/datasets/preprocessed/train/format/LEX_FULL_LOW_CAMEL_BT_MONO_BPE_3000/language \
		   --testpref ../data/datasets/preprocessed/test/format/LEX_FULL_LOW_CAMEL_BT_MONO_BPE_3000/language \
		   --validpref ../data/datasets/preprocessed/dev/format/LEX_FULL_LOW_CAMEL_BT_MONO_BPE_3000/language \
		   --destdir ../data/datasets/format/LEX_FULL_LOW_CAMEL_BT_MONO_BPE_3000 --cpu \
		   --srcdict ../data/datasets/format/LEX_FULL_LOW_CAMEL_BT_MONO_BPE_3000/dict.lex.txt \
		   --tgtdict ../data/datasets/format/LEX_FULL_LOW_CAMEL_BT_MONO_BPE_3000/dict.triple.txt
