#!/bin/bash

# Global parameters
ARCHITECTURE=back_transformer
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
    echo "Activation function: $3" >> $VERSION/config.txt
    echo "Dropout: $4" >> $VERSION/config.txt
    echo "Number of encoder/decoder layers: $5" >> $VERSION/config.txt
    echo "Embedding dimension: $6" >> $VERSION/config.txt
    echo "FFN dimension: $7" >> $VERSION/config.txt
    echo "Attention heads: $8" >> $VERSION/config.txt
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
                                # Determine version and build directories
                                determineVersion
                                # Write config version into .txt file
                                writeVersionConfig "$epoch" "$b" "$act" "$drop" "$layers" "$emb_dim" "$ffn_dim" "$heads"
                                # Train the model
                                fairseq-train $DATA_VERSION \
                                              --task translation -s lex -t triple \
                                              --criterion label_smoothed_cross_entropy --label-smoothing 0.1 \
                                              --optimizer adam --adam-betas '(0.9, 0.98)' --clip-norm 0.0 \
                                              --lr 1e-03 --lr-scheduler inverse_sqrt --warmup-updates 4000 --warmup-init-lr 1e-07 \
                                              --max-epoch $epoch --batch-size $b \
                                              --arch transformer_iwslt_de_en --share-all-embeddings \
                                              --activation-fn $act --dropout $drop \
                                              --encoder-layers $layers --decoder-layers $layers \
                                              --encoder-embed-dim $emb_dim --decoder-embed-dim $emb_dim \
                                              --encoder-ffn-embed-dim $ffn_dim --decoder-ffn-embed-dim $ffn_dim \
                                              --encoder-embed-path ../glove.6B.200d.txt --decoder-embed-path ../glove.6B.200d.txt \
                                              --encoder-attention-heads $heads --decoder-attention-heads $heads \
                                              --save-dir $SUB_CHE --no-epoch-checkpoints \
                                              --tensorboard-logdir $SUB_LOG --log-format json
done; done; done; done; done; done; done; done
