#include <stdio.h>
#include <stdlib.h>
#include "io.h"



int main(int argc, char *argv[]) {
    if (argc < 3 || argc > 4) {
        fprintf(stderr, "Usage: %s <input_file> <key_file> [output_file]\n", argv[0]);
        return 1;
    }
    const char* fileName = argv[1];
    const char* keyFileName = argv[2];
    const char* out_filename = (argc == 4) ? argv[3] : "output.txt";
    size_t data_len = 0;
    unsigned char *key_buf = read_key_file(keyFileName);
    unsigned char *buf = read_file(fileName, &data_len);
    if (buf == NULL) {
        fprintf(stderr, "Failed to read file: %s\n", fileName);
        return 1;
    }
    if (key_buf == NULL) {
        fprintf(stderr, "Failed to read key file: %s\n", keyFileName);
        free(buf);
        return 1;
    }
    unsigned char * expanded_keys_ptr = key_expansion(key_buf);
    if (expanded_keys_ptr == NULL) {
        fprintf(stderr, "Key expansion failed\n");
        free(buf);
        free(key_buf);
        return 1;
    }
    free(key_buf);














    write_buf_to_file(buf, data_len, out_filename);
    free(expanded_keys_ptr);
    free(buf);
    return 0;
}