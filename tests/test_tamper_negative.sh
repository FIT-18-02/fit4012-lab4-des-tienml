#!/usr/bin/env bash
set -euo pipefail
# Compile
g++ -std=c++17 -Wall -Wextra -pedantic des.cpp -o des_test

PLAINTEXT="$(printf '01%.0s' {1..100})"
KEY="0001001100110100010101110111100110011011101111001101111111110001"

# Encrypt
CIPHERTEXT=$(printf "1\n%s\n%s\n" "$PLAINTEXT" "$KEY" | ./des_test)

# Tamper: flip first bit of ciphertext
if [[ -z "$CIPHERTEXT" ]]; then
  echo "[FAIL] empty ciphertext"
  exit 1
fi
TAMPERED="${CIPHERTEXT}"
if [[ "${TAMPERED:0:1}" == "0" ]]; then
  TAMPERED="1${TAMPERED:1}"
else
  TAMPERED="0${TAMPERED:1}"
fi

# Decrypt tampered ciphertext
DECRYPTED=$(printf "2\n%s\n%s\n" "$TAMPERED" "$KEY" | ./des_test)

if [[ "$DECRYPTED" == "" ]]; then
  echo "[FAIL] decryption produced empty output"
  exit 1
fi

if [[ "$DECRYPTED" == "$PLAINTEXT" || "$DECRYPTED" == "${PLAINTEXT}0" ]]; then
  echo "[FAIL] Tamper did not change decrypted output as expected"
  exit 1
fi

echo "[PASS] Tamper negative test passed (tampered ciphertext does not decrypt to original)."
rm -f des_test
exit 0
