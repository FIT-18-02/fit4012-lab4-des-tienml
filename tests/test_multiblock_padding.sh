#!/usr/bin/env bash
# TODO_STUDENT: Hoàn thiện test cho trường hợp multi-block và padding.
# Gợi ý: kiểm tra plaintext dài hơn 64 bit, chia block đúng và zero padding đúng.
set -euo pipefail

# Compile
g++ -std=c++17 -Wall -Wextra -pedantic des.cpp -o des_test

# Plaintext of length not multiple of 64 (e.g., 70 bits)
PLAINTEXT="$(printf '10%.0s' {1..70})"
KEY="0001001100110100010101110111100110011011101111001101111111110001"

# Encrypt then decrypt
CIPHERTEXT=$(printf "1\n%s\n%s\n" "$PLAINTEXT" "$KEY" | ./des_test)
DECRYPTED=$(printf "2\n%s\n%s\n" "$CIPHERTEXT" "$KEY" | ./des_test)

# Plaintext after zero-padding should equal decrypted output
PADDED="$PLAINTEXT"
while (( ${#PADDED} % 64 != 0 )); do PADDED+="0"; done

if [[ "$DECRYPTED" != "$PADDED" ]]; then
  echo "[FAIL] Multi-block padding roundtrip mismatch"
  exit 1
fi

echo "[PASS] Multi-block padding works as expected."
rm -f des_test
exit 0
