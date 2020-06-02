fairseq-preprocess \
        --source-lang lex --target-lang triple \
        --joined-dictionary \
        --srcdict ../data/datasets/format/LEX_FULL_LOW_CAMEL_BT_MONO/dict.lex.txt \
        --testpref ../data/monolingual/data/language \
		--only-source \
        --destdir ../data/monolingual/data-fairseq/
