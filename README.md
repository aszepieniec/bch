ANSI C implementation Binary BCH codes over GF(2^12), along with Sage implementation with identical outputs. The implementations of Keccak (for testing purposes only) were drawn from the Keccak Code Package and modified accordingly for ANSI compliance.

# Compile:
 $> gcc -o test_bch *.c -ansi -Wpedantic

# Run:
 $> ./test_bch
 $> sage test_bch.sage


