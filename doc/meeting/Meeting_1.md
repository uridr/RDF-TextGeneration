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



-------



proposal OK
primer vistazo sobre preprocesado, el de morse es el más usado y evaluación da un poco igualq bleu pero sacral bleu es como el estandard ahora (el bleu depende de como tokenices, hay pequeñas cosas, tendríamos que hacer la misma comprovación)

mismo challange con ruso + tarea inversa de texto pasar a RBF --> li sembla genial, ens pot ajudar, està motivat, aviam si podem publicar algo :) --> fins setembre

la tarea inversa es muy interesante

afegir el profe al Git

PIPELINE:
- datos hacemos procesado con su scripts --> tripletas --> frases
-  para hacer compatible estos formatos con noseq, no entendemos como transformarlo, está en script de bash --> fer-lo servir tal qual

val la pena treballar amb minúscules i majúcules

parte entrada no pasem tokenizador, con bp tokenizador no tan importante, nos va a trocear cosas raras

tractem tot processat com una traducció normal --> el transformer ja s'apanyarà

ell faria servir BD més petites 

per desfer el output fem servir el mateix script? t'ajunta les paraules vp inverso x entendre'ns la detokenizador (tonrar a juntar comes) s'hauria de fer amb el mateix moses, suposa q té la versió inversa també

train y validation tenemos, pero de test no tenemos labels no tenemos referencia (hay forma de enviarlo, alternativamente hay una BD pero no hay benchmark)

https://github.com/pytorch/fairseq/blob/master/examples/translation/prepare-iwslt14.sh
https://gitlab.com/shimorina/webnlg-dataset

usar versión2.1 puede q haya gente q haya publicado ya resultados con este. podríamos también entrenar con el nuevo y comparar con el viejo. no vale la pena esfuerzo de ser super precisos, él trabajaría directamente con esta

per poder entrenar el sistema Kaggle
se puede instalar con pip y utilizar en Kaggle
podemos hacer alguna prova al servidor de PE
EL PROFE ÉS RIC EN SERVIDORS, ELL ET DÓNA SERVEI X UN MES, NO TÉ CRÈDITS PER TOTS PERÒ SOM MOLT BONS I ELL ENS DÓNA A NOSALTRES :) TAMBÉ POT OBRIR UN A GOOGLE CLOUD :) EL PROFE TÉ CRÈDITS, PER PODER COMPLETAR ELS 300€

prepararem amb VP i tokenizer x si la setmana q ve podem començar a entrenar coses, el model tardarà molt poc