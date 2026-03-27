#ifndef AES_H
#define AES_H

// Key expansion function to generate round keys from the original key
unsigned char* key_expansion(const unsigned char *key);
#endif

// AES state matrix representation 
// typedef struct {
//     unsigned char matrix[4][4];
// } aes_state;
// Populate AES state matrix from input bytes (column-major order) 
// void populate_state(aes_state * state, unsigned char * input, size_t len);
// SubBytes transformation: substitute bytes using S-box 
// void sub_bytes(aes_state* state);
// ShiftRows transformation: rotate rows 
// void shift_rows(aes_state* state);
// Rotate a 4-byte word left by one byte 
// void rot_word(unsigned char *word);
// Substitute each byte in a 4-byte word using the S-box 
// void sub_word(unsigned char *word);
// XOR the first byte of the word with the round constant for the given round
// void rcon(unsigned char * word,int round);

