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

Monolingual data can be obtained by means of [WikiExtractor](https://github.com/attardi/wikiextractor ). Alternatively, the targeted approach mentioned in the work, which improves results in comparison with previous monolingual, can be generated from `data/monolingual/`:

```bash
pyhton3 scrapper.py > [OUTPUT_TEXT-1]
```

This script requires to place the [Wikipedia2Vec](https://wikipedia2vec.github.io/wikipedia2vec/) embeddings, pickle format, in `data/vocab`.

In order to clean the Wikipedia text and fix instance lenght, two scripts must be executed.

```bash
python3 preprocessing_wiki.py [OUTPUT_TEXT-1] > [OUTPUT_TEXT-2]
python3 filter.py [OUTPUT_TEXT-2] > [OUTPUT_CLEAN_TEXT-3]
```



### Synthetic Data

Synthetic data can be generated with Transformer model or parsing techniques, the later showed better results and will be detailed below. How to execute Transformer architecture with another data will be presented later on, only change data directory if synthetic data wants to be generated from th Transformer.

Parsing method requires the installation of [Stanford CoreNLP](https://stanfordnlp.github.io/CoreNLP/download.html). The parsing algorithm is taken from the author: [TPetrou](https://github.com/calosh/RDF-Triple-API), some updates and modifications have been introduced to make it compatible with our task. 

In order to parse the monolingual text, we have to execute a java-process in background to initiate the parsing instance, then, we can start parsing, everything from `data/monolingual/`.

```bas
java -mx4g -cp "*" edu.stanford.nlp.pipeline.StanfordCoreNLPServer -preload tokenize,ssplit,pos,lemma,ner,parse,depparse -status_port 9000 -port 9000 -timeout 15000
 
python3 RDF_Triple.py [OUTPUT_CLEAN_TEXT-3] > [OUTPUT_RDF-4]
```

Finally, we can clean this output, removing empty RDF, and aligned it with the monolingual data.

```bash
python3 corpus_alignment.py [OUTPUT_RDF-4] [OUTPUT_CLEAN_TEXT-3] 
```

This will generate two files `rdf_aligned.txt` and `text_aligned.txt` corresponding to the output of the Back Translation model.



### Preprocessing 

We show how to preprocess from the original data in `.xml` format to fairseq format. Notice that some preprocessing steps can be skipped, as in some experiments, but we show how to do the entire preprocessing pipeline described in our work.

Turning the `.xml` files into  source and target plain text splitted acording to default train, dev, test separation. It also outputs a lexicalised and delexicalised verision. Being in the `./preprocessing` directory, follow these commands.

```bash
sh xml_to_text.sh
```

Then, we apply Byte Pair Encoding and Moses tokenization.

```sh 
export MOSESDECODER=../mosesdecoder/  #Provide the directory of the cloned repository
export BPE=../subword-nmt/			#Provide the directory of the cloned repository
sh token_and_bpe.sh
```

The `token_and_bpe.sh` script can be modified to read from any path. 

Lastly, we preprocess with fairseq to make data compatible with the software.

```bash
sh fairseq_format.sh
```

It will dump data in `data/datasets/format/` or in `data/benchmark/format/`. The `faireq_format.sh` script can be modified to read from any path. 



### Model

In order to run the models, we provide a wrapping script `./models/run_model.sh` that accepts several parameters to adjust the training procedure. 

```bash
sh run_model.sh -a | --architecture) [ARCHITECTURE_NAME]
                -c | --config-file) [CONFIGURATION_FILE]
                -p | --data-path) [RELATIVE_DATA_PATH]
                -f | --format) [DATA_FORMAT]
                -b | --bpe) [BPE_WORDS_NUMBER]
                -s | --emb-source) [EMBEDDINGS_SOURCE]
                -d | --emb-dimension) [EMBEDDINGS_DIMENSION]
```

The option ```-p [RELATIVE_DATA_PATH]``` will read the data directly from the specified path. Options `-f [DATA_FORMAT]` and `-b [BPE_WORDS_NUMBER]` are optimized for server execution and the data directories should by modified according to that.


Bellow, we provide several examples to reproduce the best results obtained in the network, however, third parties can feel free to reproduce other experiments since experimental data is processed and available in this repository.


**Vanilla Convolutional Model** 

```bash
sh run_model.sh -a fconv_self_att_wp -c 2 -p '../data/datasets/format/DELEX_BPE_5_000/'
```

**Byte Pair Encoding**

```bash
sh run_model.sh -a fconv_self_att_wp -c 8 -p '../data/datasets/format/DELEX_BPE_5_000/'
```

**Pretrained Embedding**

```bash
sh run_model.sh -a transformer -c 13 -s glove -d 300 -p '../data/datasets/format/LEX_LOW_CAMEL'
```

**Back Translation**

```bash
sh run_model.sh -a back_transformer -c 3 -p '../data/datasets/format/LEX_LOW_CAMEL_SYNTHETIC_BPE'
```



### Postprocessing

Once the model is trained, we can predict using fairseq software. If needed, the output will be delexicalised, this is automatically infered. The software randomly predict the instances, hence, we have to process the output format before delexicalising predictions. Fairseq predictions directly remove the BPE and Moses tokenization. It can be done as follows from the `./postprocessing` directory.

```bash
sh predict.sh [MODEL_CHECKPOINTS] [DATA] [OUTPUT_FILE]
sh relexicalise.sh [FILE_NAME] [FILE_PATH]
```

This will create one folder in the `../data/predictions/[OUTPUT_FILE]`, which has to be provided in `[FILE_PATH]` and `[OUTPUT FILE]` in `[FILE NAME]`,  with the predicted output, the aligned w.r.t. source and postprocess.



### Evaluation

To compute performance metrics: BLEU, TER, METEOR and chrF++, we have adopted the script provided by the [WebNLG Challenge 2020](https://github.com/WebNLG/GenerationEval) placed in  `./metrics` . This requires to download METEOR in `metrics/metrics`, it is ignored to be pushed.

```bash
wget https://www.cs.cmu.edu/~alavie/METEOR/download/meteor-1.5.tar.gz
tar -xvf meteor-1.5.tar.gz
mv meteor-1.5 metrics
rm meteor-1.5.tar.gz
```

One can run single evaluation or evaluate all predictions in the `data/predictions/`directory. The model's name and performance metrics are stored in  `models_metrics.json` to history tracking, plotting, etc.

```sh
sh run_eval.sh [PREDICTIONS] [TARGET]     # Single evaluation  
sh run_full_evaluation.sh                 # Multiple evaluation
```
