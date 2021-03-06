# Enhancing Sequence-to-Sequence Modelling for RDF triples to Natural Text

Implementation of the Seq2Seq models proposed in the paper **[Enhancing Sequence-to-Sequence Modelling for RDF triples to Natural Text](https://webnlg-challenge.loria.fr/files/2020.webnlg-papers.5.pdf)**  using [Fairseq](https://fairseq.readthedocs.io/en/latest/) a sequence modeling toolkit. Also, instructions to reproduce experiments are delivered.



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

+ Original data taken from [WebNLG corpus](https://gitlab.com/shimorina/webnlg-dataset): 
  + `data/datasets/original` in the paper is mentioned as `release_v2.1` version.
  + `data/benchmark/original` in the paper is mentioned as `webnlg_challenge_2017` version.
+ Preprocessed data: `data/datasets/preprocessed` `data/benchmark/preprocessed`
+ Fairseq data format: `data/datasets/format ` `data/benchmark/format`
+ Monolingual data and its predicted RDF triples: `data/monolingual/data` 

In this directory, we also included data related to train-valid loss , `data/loss`, and predictions, `data/predictions`, to allow analysis. The `data/vocab` is a folder for pretrained embeddings, evertyhing included here will be ignored.



### Monolingual Data

Monolingual data can be obtained by means of [WikiExtractor](https://github.com/attardi/wikiextractor ). Alternatively, the targeted approach mentioned in the work, which improves results in comparison with previous monolingual, can be generated from `data/monolingual/`:

```bash
pyhton3 scrapper.py [DATASET] > [OUTPUT_TEXT-1]
```

If `data/datasets/original` is going to be used as real data in BT, then , `[DATASET]` argument must be `release_v2.1`, and if `data/datasets/benchmark` is going to be used, then,  provide `webnlg` as argument. This script requires to place the [Wikipedia2Vec](https://wikipedia2vec.github.io/wikipedia2vec/) embeddings, pickle format, in `data/vocab`.

In order to clean the Wikipedia text and fix instance lenght, two scripts must be executed.

```bash
python3 preprocessing_wiki.py [OUTPUT_TEXT-1] [OUTPUT_TEXT-2]
python3 filter.py [OUTPUT_TEXT-2] [OUTPUT_CLEAN_TEXT-3]
```



### Synthetic Data

Synthetic data can be generated with Transformer model or parsing techniques, the latter showed better results and will be detailed below. How to execute Transformer architecture with other data will be presented later on, only change data directory if synthetic data wants to be generated from the Transformer.

Parsing method requires the installation of [Stanford CoreNLP](https://stanfordnlp.github.io/CoreNLP/download.html) and [Stanford Parser](https://nlp.stanford.edu/software/lex-parser.shtml). Both can be installed in main directory, where will be ignored. If so, no modification needs to be done in the code, otherwise, adapt global variables of `data/monolingual/RDF_Triple.py` with the corresponding path of the Stanford Parser.

The parsing algorithm is taken from the author: [TPetrou](https://github.com/calosh/RDF-Triple-API), some updates and modifications have been introduced to improve it and make it compatible with our task. 

In order to parse the monolingual text, we have to execute a java-process in background to initiate the parsing instance, then, we can start parsing, everything from `data/monolingual/`. Notice that the java process must be executed inside the Stanford CoreNLP folder.

```bas
java -mx4g -cp "*" edu.stanford.nlp.pipeline.StanfordCoreNLPServer -preload tokenize,ssplit,pos,lemma,ner,parse,depparse -status_port 9000 -port 9000 -timeout 15000
 
python3 RDF_Triple.py [OUTPUT_CLEAN_TEXT-3] > [OUTPUT_RDF-4]
```

Finally, we can clean this output removing empty RDF and aligning the remaining ones with the monolingual data.

```bash
python3 corpus_alignment.py [OUTPUT_RDF-4] [OUTPUT_CLEAN_TEXT-3] 
```

This will generate two files `rdf_aligned.txt` and `text_aligned.txt` corresponding to the output of the Back Translation model.

If Tagged Back Translation wants to be reproduced, follow the same steps, however, during preprocessing and before making compatible with Fairseq software, explained below, do the following from `./preprocessing/`:

```bash
python3 tagged_bt -f | --file ) [INPUT_PATH]
		  -l | --line ) [LINE_TAGGING]
                  -o | --overwrite ) [OVERWRITE]
```

The option `-f [INPUT_PATH]` is for the generated corpus path, and `-l [LINE_TAGGING]` allow user to specify from which line should taggs be added. Then, `-o [OVERWRITE]` is a boolean value whether overwrite the generated file or not.



### Preprocessing 

We show how to preprocess from the original data in `.xml` format to fairseq format. Notice that some preprocessing steps can be skipped, as in some experiments, but we show how to do the entire preprocessing pipeline described in our work.

Turning the `.xml` files into  source and target plain text, splitted acording to default train, dev, test separation. It also outputs a lexicalised and delexicalised version. Being in the `./preprocessing` directory, follow these commands.

```bash
sh xml_to_text.sh
```

In some experiments, where the entire pipeline is not followed, one needs to remove camelCase style and lowercase all words. This can be done as follows:

```bash
sh lower_and_camelCase.sh 
```

The `lower_and_camelCase.sh` script can be modified to read and write from-to any path.  

Then, we apply Byte Pair Encoding and Moses tokenization.

```sh 
export MOSESDECODER=../mosesdecoder/  #Provide the directory of the cloned repository
export BPE=../subword-nmt/			#Provide the directory of the cloned repository
sh token_and_bpe.sh
```

The `token_and_bpe.sh` script can be modified to read and write from-to any path. 

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
                -s | --emb-source) [EMBEDDINGS_SOURCE]
                -d | --emb-dimension) [EMBEDDINGS_DIMENSION]
		-fp16 | --fp16) [MIXED PRECISION TRAINING]
```

All of the provided options are keyword arguments, except for ```-fp16``` which is a flag that it indicates wheter or not `float16` mixed precision training should be used.


Bellow, we provide several examples to reproduce the best results obtained in the network, however, third parties can feel free to reproduce other experiments since experimental data is processed and available in this repository.


**Vanilla Convolutional Model** 

```bash
sh run_model.sh -a fconv_self_att_wp -c 2 -p '../data/datasets/format/DELEX_BPE_5_000/'
```

**Byte Pair Encoding**

```bash
sh run_model.sh -a transformer -c 1 -p '../data/datasets/format/DELEX_BPE_5_000/'
```

**Pretrained Embeddings**

```bash
sh run_model.sh -a transformer -c 2 -s glove -d 300 -p '../data/datasets/format/LEX_LOW_CAMEL_BPE'
```

**Back Translation**

```bash
sh run_model.sh -a transformer -c 3 -p '../data/datasets/format/LEX_LOW_CAMEL_SYNTHETIC_2_ENRICHED_BPE'
```



### Postprocessing

Once the model is trained, we can predict using fairseq software. If needed, the output will be delexicalised, this is automatically inferred. The software randomly predicts the instances, hence, we have to process the output format before delexicalising predictions. Fairseq predictions directly remove the BPE and Moses tokenization. It can be done as follows from the `./postprocessing` directory.

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

### Citation

If you find our work or the code useful, please consider cite our paper using:

```
@inproceedings{domingo-etal-2020-rdf2text, 
    title = "Enhancing Sequence-to-Sequence Modelling for {RDF} triples to Natural Text",
    author = "Oriol Domingo and David Bergés and Roser Cantenys and Roger Creus and José A.R. Fonollosa",
    booktitle = {Proceedings of the 3rd WebNLG Workshop on Natural Language Generation from the Semantic Web (WebNLG+ 2020)},
    year = "2020",
    address =      {Dublin, Ireland (Virtual)},
    publisher = {"Association for Computational Linguistics"},
}
```
