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



### Monolingual and Synthetic Generation 



### Preprocessing 



### Model

We provide several examples to reproduce the best results obtained in the work, however, third parties can feel free to reproduce other experiments since experimental data is processed and available in this repository.



**Vanilla Convolutional Model** 



**Byte Pair Encoding**



**Pretrained Embedding**



**Back Translation**





### Evaluation

