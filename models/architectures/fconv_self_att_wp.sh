#!/bin/bash

# Global parameters
ARCHITECTURE=fconv_self_att_wp
CONFIG_FILES=$1
DATA_VERSION=$2

# Source config file variables to current bash session
. "$CONFIG_FILES"

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
    echo "Dropout: $3" >> $VERSION/config.txt
    echo "Embedding dimension: $4" >> $VERSION/config.txt
    echo "Use pretrained embeddings: $5" >> $VERSION/config.txt
    echo "Attention heads: $6" >> $VERSION/config.txt
}


# Train the network
for epoch in "${EPOCHS[@]}"; do
    for b in "${BATCH_SIZE[@]}"; do
        for drop in "${DROPOUT[@]}"; do
            for emb_dim in "${EMB_DIM[@]}"; do
                for heads in "${ATT_HEADS[@]}"; do
                    for pretrained in "${PRETRAINED[@]}"; do
                        # Determine version and build directories
                        determineVersion
                        # Write config version into .txt file
                        writeVersionConfig "$epoch" "$b" "$drop" "$emb_dim" "$pretrained" "$heads" 

                        # Determine pretrained embeddings path
                        if [ "$pretrained" == "True" ]; then
                          pretrained="--encoder-embed-path ../glove.6B.200d.txt --decoder-embed-path ../glove.6B.200d.txt"
                          use_emb_dim=200
                        else
                          pretrained=""
                          use_emb_dim="$emb_dim"
                        fi

                        # Train the model
                        fairseq-train $DATA_VERSION \
                                      --task translation -s triple -t lex \
                                      --criterion label_smoothed_cross_entropy --label-smoothing 0.1 \
                                      --optimizer adam --adam-betas '(0.9, 0.98)' --clip-norm 0.1 \
                                      --lr 1e-03 --lr-scheduler inverse_sqrt --warmup-updates 4000 --warmup-init-lr 1e-07 \
                                      --max-epoch $epoch --batch-size $b \
                                      --arch fconv_self_att_wp $pretrained --dropout $drop \
                                      --encoder-embed-dim $use_emb_dim --decoder-embed-dim $use_emb_dim --decoder-out-embed-dim $use_emb_dim \
                                      --multihead-self-attention-nheads $heads \
                                      --gated-attention True --self-attention True \
                                      --save-dir $SUB_CHE --no-epoch-checkpoints \
                                      --log-format json --tensorboard-logdir $SUB_LOG
done; done; done; done; done; done
