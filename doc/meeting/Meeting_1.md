### Information

* [WebNLG Challenge 2020](https://webnlg-challenge.loria.fr/challenge_2020/) 
* Github repository
* Working-Pipeline defined
* Data downloaded and pre-processed regarding WebNLG recommendations

### Questions

* How to parse Test xml file into .triple_ 
* For 2017th version, we do not have reference text for test (*evaluation*): Automatic Evaluation for WebNLG Challenge 2017. Alternatively, we could use [version 2](https://gitlab.com/shimorina/webnlg-dataset/-/tree/master/release_v2), which is solved but benchmark is not provided.
* Introduction to [Fairseq](https://fairseq.readthedocs.io/en/latest/getting_started.html):   
  *  `tokenizer.perl` from [mosesdecoder](https://github.com/moses-smt/mosesdecoder).
  * BPE
* Evaluation
  * Which BLEU script is recommended:
    * [SacreBLEU](https://github.com/awslabs/sockeye/tree/master/contrib/sacrebleu)
    * [BLEU](https://www.nltk.org/_modules/nltk/translate/bleu_score.html) from NLTK 
    * [Maluuba metrics](https://github.com/Maluuba/nlg-eval/) for NLG
    * metrics used for [E2E Challenge](https://github.com/tuetschek/e2e-metrics)
  * Alternatives to download [METEOR](http://www.cs.cmu.edu/~alavie/METEOR/) and [TER](http://www.cs.umd.edu/~snover/tercom/)
