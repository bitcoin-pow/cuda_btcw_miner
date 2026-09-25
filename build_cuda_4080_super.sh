#!/usr/bin/env bash
set -euo pipefail
mkdir -p release
ARCH="${CUDA_ARCH:-sm_89}"
MAX_REGS="${1:-${CUDA_MAX_REGS:-160}}"
nvcc -O3 -std=c++17 -arch="$ARCH" --maxrregcount "$MAX_REGS" \
  -DBTCW_SIGN_BATCH=128 -DBTCW_LUT_BITS=26 \
  -Xptxas=-v,-warn-spills btcw_cuda_miner.cu \
  -o release/btcw_cuda_miner_4080_super -lrt -lpthread
echo "Built release/btcw_cuda_miner_4080_super for $ARCH W26 batch128 maxrregcount=$MAX_REGS"
