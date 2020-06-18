# Sequence-to-Sequence Modelling for RDF triples to Natural Text

Implementation of the Seq2Seq models proposed in the paper **Sequence-to-Sequence Modelling for RDF triples to Natural Text**  using [Fairseq](https://fairseq.readthedocs.io/en/latest/) a sequence modeling toolkit. Also, instructions to reproduce experiments are delivered.



### Requirements

The following repositories must be downloaded, please install them in main directory, `.gitignore` wil ignore them to be pushed.

```bash
git clone https://github.com/rsennrich/subword-nmt.git 
git clone https://github.com/moses-smt/mosesdecoder.git
```

Next steps requires **Python >= 3.6** and  **PyTorch >= 1.2.0**. One can install all requiremets executing:

```bash
pip install -r requirements.txt
```

Once all requirements are met, install Fairseq software.

```bas
pip install fairseq
```



### Data

The `./data` directory holds different type of data:

+ Original data taken from [WebNLG corpus](https://gitlab.com/shimorina/webnlg-dataset): `data/datasets/original` `data/benchmark/original`
+ Preprocessed data: `data/datasets/preprocessed` `data/benchmark/original`
+ Fairseq data format: `data/datasets/format ` `data/benchmark/original`
+ Monolingual data and its predicted RDF triples: `data/monolingual/data` 

In this directory, we also included data related to train-valid loss , `data/loss`, and predictions, `data/predictions`, to allow analysis. The `data/vocab` is a folder for pretrained embeddings, evertyhing included here will be ignored.



### Monolingual Data

Monolingual data can be obtained by means of (JOSE ADRIAN SCRIPT) . Alternatively, the targeted approach mentioned in the work, which improves results in comparison with previous monolingual, can be generated from `data/monolingual/`:

```bash
pyhton3 scrapper.py > monolingual.txt
```

This script requires to place the [Wikipedia2Vec](https://wikipedia2vec.github.io/wikipedia2vec/) embeddings, pickle format, in `data/vocab`.

In order to clean the Wikipedia text and fix instance lenght, two scripts must be executed.

```bash
python3 preprocessing_wiki.py monolingual.txt > preprocessed_monolingual.txt
python3 filter.py preprocessed_monolingual.txt > clean_monolingual.txt
```



### Synthetic Data

Synthetic data can be generated with Transformer model or parsing techniques, the later showed better results and will be detailed below. How to execute Transformer architecture with another data will be presented later on, only change data directory if synthetic data wants to be generated from th Transformer.

Parsing method requires the installation of [Stanford CoreNLP](https://stanfordnlp.github.io/CoreNLP/download.html). The parsing algorithm is taken from the author: [TPetrou](https://github.com/calosh/RDF-Triple-API), some updates and modifications have been introduced to make it compatible with our task. 

In order to parse the monolingual text, we have to execute a java-process in background to initiate the parsing instance, then, we can start parsing.

```bas
java -mx4g -cp "*" edu.stanford.nlp.pipeline.StanfordCoreNLPServer -preload tokenize,ssplit,pos,lemma,ner,parse,depparse -status_port 9000 -port 9000 -timeout 15000
 
python3 RDF_Triple.py clean_monolingual.txt > rdf_synthetic.txt
```

Finally, we can clean this output, removing empty RDF, and aligned it with the monolingual data.

```bash
python3 rdf_synthetic clean_monolingual 
```

This will generate two files `rdf_aligned.txt` and `text_aligned.txt` corresponding to the output of the Back Translation model.



### Preprocessing 



### Model

We provide several examples to reproduce the best results obtained in the work, however, third parties can feel free to reproduce other experiments since experimental data is processed and available in this repository.



**Vanilla Convolutional Model** 



**Byte Pair Encoding**



**Pretrained Embedding**



**Back Translation**





### Postprocessing



### Evaluation

