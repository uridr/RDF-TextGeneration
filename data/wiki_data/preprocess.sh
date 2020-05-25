fairseq-preprocess \
        --only-source \
        --source-lang lex --target-lang triple \
        --joined-dictionary \
        --srcdict ../datasets/format_lex_full/dict.lex.txt \
        --testpref test/format_lex/language \
        --destdir data-bin/ 