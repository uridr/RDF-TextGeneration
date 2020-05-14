### Information

+ Last Version of Data

* Preprocessing 
  * Moses Tokenizer
  * BPE - BPE_TOKENS=1000

+ Fairseq-preprocess
  + --joined-dictionary
+ Fairseq-train file 

### Questions

* Kaggle Environment
* Architecture Recommendation
  * Provided
    * *Hierarchical Neural Story Generation (Fan et al., 2018)* : fconv_self_att_wp
    * *Neural Machine Translation with Byte-Level Subwords*: gru_transformer 
    * *Non-autoregressive Neural Machine Translation (NAT)* : levenshtein_transformer
  * Custom

+ Extra Technique
  + *Understanding Back-Translation at Scale (Edunov et al., 2018)* 
  + *GloVe Embeddings* 

+ Fairseq-train inplace *BLEU* metric
+ Script to undo *BPE* after train

