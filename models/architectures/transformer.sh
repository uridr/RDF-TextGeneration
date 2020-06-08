#!/bin/bash

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    # Parse configuration file path
    -c) CONFIG="$2"; shift 2;;
    # Parse data path
    -f) FORMAT="$2"; shift 2;;
    # Parse pretrained embeddings path
    -e) EMB="$2"; shift 2;;
    # Parse pretrained embeddings dimension
    -d) DIM="$2"; shift 2;;
    # Handle unknown parameters
    -*|--*|*) echo "Unknown parameter: $1"; exit 2;;
    # Store positional arguments
    #*) POSITIONAL+=("$1"); shift 1;;
  esac
done


# Global parameters
ARCHITECTURE=transformer

# Source config file variables to current bash session
. "$CONFIG"

CHECKPOINTS="checkpoints/$ARCHITECTURE"


determineVersion ()
{
    # Count number of architecture executions
    N=($(ls $CHECKPOINTS | wc -l))
    VERSION="$CHECKPOINTS/v$N"
    # Make version directory
    mkdir $VERSION
    
    # Sub checkpoint and log directories
    SUB_LOG="$VERSION/log"
    SUB_CHE="$VERSION/che"
    mkdir $SUB_LOG
    mkdir $SUB_CHE
}


writeVersionConfig ()
{
    # Create text file and write all the configuration parameters
    echo "Training epochs: $1" >> $VERSION/config.txt
    echo "Batch size: $2" >> $VERSION/config.txt
    echo "Activation function: $3" >> $VERSION/config.txt
    echo "Dropout: $4" >> $VERSION/config.txt
    echo "Number of encoder/decoder layers: $5" >> $VERSION/config.txt
    echo "Embedding dimension: $6" >> $VERSION/config.txt
    echo "FFN dimension: $7" >> $VERSION/config.txt
    echo "Attention heads: $8" >> $VERSION/config.txt
    echo "Learned encoder position embeddings: $9" >> $VERSION/config.txt
    echo "Learned decoder position embeddings: ${10}" >> $VERSION/config.txt
    echo "Use cross + self-attention: ${11}" >> $VERSION/config.txt
}


# Train the network
for epoch in "${EPOCHS[@]}"; do
  for b in "${BATCH_SIZE[@]}"; do
    for act in "${ACTIVATION[@]}"; do
      for drop in "${DROPOUT[@]}"; do
        for layers in "${LAYERS[@]}"; do
          for emb_dim in "${EMB_DIM[@]}"; do
            for ffn_dim in "${FFN_DIM[@]}"; do
              for heads in "${ATT_HEADS[@]}"; do
                for enc_pos in "${ENC_POS[@]}"; do
                  for dec_pos in "${DEC_POS[@]}"; do
                    for cross in "${CROSS[@]}"; do
                      # Determine version and build directories
                      determineVersion
                      # Write config version into .txt file
                      writeVersionConfig "$epoch" "$b" "$act" "$drop" "$layers" "$emb_dim" \
                                         "$ffn_dim" "$heads" "$enc_pos" "$dec_pos" "$cross"

                      if [ ! -z "$EMB" ]; then
                        pretrained="--encoder-embed-path $EMB --decoder-embed-path $EMB"
                        # Determine embedding dimension
                        use_emb_dim="$DIM"
                      else
                        pretrained=""
                        use_emb_dim="$emb_dim"
                      fi

                      # Determine learned position embeddings flags
                      if [[ "$enc_pos" == "True" && "$dec_pos" == "True" ]]; then
                        learned_pos="--encoder-learned-pos --decoder-learned-pos"
                      elif [ "$enc_pos" == "True" ]; then
                        learned_pos="--encoder-learned-pos"
                      elif [ "$dec_pos" == "True" ]; then
                        learned_pos="--decoder-learned-pos"
                      else
                        learned_pos=""
                      fi

                      # Perform cross+self-attention
                      if [ "$cross" == "True" ]; then
                        cross="--cross-self-attention"
                      else
                        cross=""
                      fi

                      # Train the model
                      fairseq-train $FORMAT \
                                    --task translation -s triple -t lex \
                                    --criterion label_smoothed_cross_entropy --label-smoothing 0.1 \
                                    --optimizer adam --adam-betas '(0.9, 0.98)' --clip-norm 0.0 \
                                    --lr 1e-03 --lr-scheduler inverse_sqrt --warmup-updates 4000 --warmup-init-lr 1e-07 \
                                    --max-epoch $epoch --batch-size $b \
                                    --arch transformer_iwslt_de_en --share-all-embeddings $learned_pos $pretrained \
                                    --activation-fn $act --dropout $drop $cross \
                                    --encoder-layers $layers --decoder-layers $layers \
                                    --encoder-embed-dim $use_emb_dim --decoder-embed-dim $use_emb_dim \
                                    --encoder-ffn-embed-dim $ffn_dim --decoder-ffn-embed-dim $ffn_dim \
                                    --encoder-attention-heads $heads --decoder-attention-heads $heads \
                                    --save-dir $SUB_CHE --no-epoch-checkpoints \
                                    --tensorboard-logdir $SUB_LOG --log-format json

done; done; done; done; done; done; done; done; done; done; done
