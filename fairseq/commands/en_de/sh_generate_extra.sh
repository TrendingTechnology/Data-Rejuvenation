#!/usr/bin/env bash
cd ../../
DATASET=wmt14_en_de_base
DATA=data-bin/$DATASET
CP_PATH=./checkpoints/$DATASET
CP=checkpoint_best.pt

CHECKPOINT=$CP_PATH/$CP
mkdir ./results/$DATASET
VALID_DECODE_PATH=./results/$DATASET/valid
mkdir $VALID_DECODE_PATH

SUBSET=valid
echo "Evaluate on $DATA with $CHECKPOINT"
CUDA_VISIBLE_DEVICES=0 python generate.py \
  data-bin/$DATASET \
  --fp16 \
  -s en \
  -t de \
  --path $CHECKPOINT \
  --gen-subset $SUBSET \
  --lenpen 0.6 \
  --beam 4 \
  --decoding-path $VALID_DECODE_PATH \
  --num-ref $DATASET=1 \
  --multi-bleu-path ./scripts/ \
  --valid-decoding-path $VALID_DECODE_PATH \
  > ./results/$DATASET/$CP.gen

sh ./scripts/compound_split_bleu.sh ./results/$DATASET/$CP.gen

