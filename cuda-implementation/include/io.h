#ifndef IO_H
#define IO_H

#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

void write_buf_to_file(const unsigned char *buf, size_t len, const char *out_filename);
unsigned char* read_file(const char* fileName, size_t *out_len);
unsigned char * read_key_file(const char *keyFileName);

#ifdef __cplusplus
}
#endif

#endif