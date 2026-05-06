#!/usr/bin/env bash
set -euo pipefail
# Compile
g++ -std=c++17 -Wall -Wextra -pedantic des.cpp -o des_test

# Sample from original starter code
PLAINTEXT="0001001000110100010101100111100010011010101111001101111011110001"
KEY="0001001100110100010101110111100110011011101111001101111111110001"

# Encrypt (mode 1)
CIPHERTEXT=$(printf "1\n%s\n%s\n" "$PLAINTEXT" "$KEY" | ./des_test)

if [[ -z "$CIPHERTEXT" ]]; then
  echo "[FAIL] Empty ciphertext produced by sample DES run"
  exit 1
fi

if (( ${#CIPHERTEXT} % 64 != 0 )); then
  echo "[FAIL] Ciphertext length is not a multiple of 64"
  exit 1
fi

echo "[PASS] Sample DES produced ciphertext of length ${#CIPHERTEXT}."
echo "$CIPHERTEXT" > ../logs/run-output.txt || true
rm -f des_test
exit 0
