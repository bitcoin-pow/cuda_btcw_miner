#!/usr/bin/env bash
set -euo pipefail
cd -- "$(dirname -- "${BASH_SOURCE[0]}")"
MAX_REGS="${1:-${CUDA_MAX_REGS:-160}}"
if [[ ! "$MAX_REGS" =~ ^[1-9][0-9]{1,2}$ ]] || (( MAX_REGS < 32 || MAX_REGS > 255 )); then
  echo "Register cap must be an integer from 32 to 255" >&2
  exit 2
fi
mkdir -p release
OUTPUT="release/btcw_cuda_miner_4070_super"
# Native Ada code only; no unused PTX fallback in this dedicated release.
nvcc -O3 -std=c++17 -gencode arch=compute_89,code=sm_89 \
  --maxrregcount "$MAX_REGS" -DBTCW_SIGN_BATCH=128 -DBTCW_HYBRID_RX=0 \
  -Xptxas=-v,-warn-spills btcw_cuda_miner.cu -o "$OUTPUT" -lrt -lpthread
echo "Built $OUTPUT (W24/W9, batch128, sm_89, maxrregcount=$MAX_REGS)"
