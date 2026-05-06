#!/usr/bin/env bash
# TODO_STUDENT: Hoàn thiện test round-trip encrypt -> decrypt.
# Gợi ý: sau khi em viết thêm giải mã, cần kiểm tra decrypt(encrypt(plaintext)) = plaintext.
set -euo pipefail

# Compile
g++ -std=c++17 -Wall -Wextra -pedantic des.cpp -o des_test

# Use a plaintext longer than one block to exercise multi-block
PLAINTEXT="$(printf '01%.0s' {1..130})" # 260 bits
KEY="0001001100110100010101110111100110011011101111001101111111110001"

# Encrypt
CIPHERTEXT=$(printf "1\n%s\n%s\n" "$PLAINTEXT" "$KEY" | ./des_test)

# Decrypt
DECRYPTED=$(printf "2\n%s\n%s\n" "$CIPHERTEXT" "$KEY" | ./des_test)

# After decrypt we should get the plaintext padded with zeros to multiple of 64
PADDED_PLAINTEXT="$PLAINTEXT"
while (( ${#PADDED_PLAINTEXT} % 64 != 0 )); do PADDED_PLAINTEXT+="0"; done

if [[ "$DECRYPTED" != "$PADDED_PLAINTEXT" ]]; then
  echo "[FAIL] Round-trip decrypt(encrypt(plaintext)) did not match (after padding)"
  exit 1
fi

echo "[PASS] Round-trip encrypt->decrypt matched (after padding)."
rm -f des_test
exit 0
