#ifndef LZSS_H
#define LZSS_H

#include <stdio.h>

void Encode(FILE *infile, FILE *outfile, size_t input_length);
void Decode(FILE *infile, FILE *outfile, size_t input_length);

#endif /* LZSS_H */
