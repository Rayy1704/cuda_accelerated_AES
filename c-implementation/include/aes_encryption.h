#ifndef AES_H
#define AES_H

// Key expansion function to generate round keys from the original key
typedef struct {
    unsigned char matrix[4][4];
} aes_state;
unsigned char* key_expansion(const unsigned char *key);
// AES encryption function that takes input data, expanded keys, and the length of the data
void aes_encrypt(unsigned char * data,unsigned char * expanded_keys, size_t len);
void populate_state(aes_state * state, unsigned char * input);
void add_round_key(aes_state * state, unsigned char * round_key);
#endif
