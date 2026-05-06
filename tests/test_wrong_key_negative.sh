#!/usr/bin/env bash
# TODO_STUDENT: Hoàn thiện negative test cho wrong key / incorrect key / sai key.
# Gợi ý: giải mã với khóa sai và chứng minh không khôi phục đúng plaintext.
set -euo pipefail
# Compile
g++ -std=c++17 -Wall -Wextra -pedantic des.cpp -o des_test

PLAINTEXT="$(printf '10%.0s' {1..120})"
KEY="0001001100110100010101110111100110011011101111001101111111110001"
WRONG_KEY="1111111100000000111111110000000011111111000000001111111100000000"

# Encrypt
CIPHERTEXT=$(printf "1\n%s\n%s\n" "$PLAINTEXT" "$KEY" | ./des_test)

# Decrypt with wrong key
DECRYPTED=$(printf "2\n%s\n%s\n" "$CIPHERTEXT" "$WRONG_KEY" | ./des_test)

# Ensure decrypted output does not equal original padded plaintext
PADDED="$PLAINTEXT"
while (( ${#PADDED} % 64 != 0 )); do PADDED+="0"; done

if [[ "$DECRYPTED" == "$PADDED" ]]; then
  echo "[FAIL] Decryption with wrong key unexpectedly recovered the original plaintext"
  exit 1
fi

echo "[PASS] Wrong-key negative test passed (wrong key did not recover plaintext)."
rm -f des_test
exit 0
