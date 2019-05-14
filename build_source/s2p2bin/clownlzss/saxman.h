#pragma once

#include <stdbool.h>
#include <stddef.h>

unsigned char* SaxmanCompress(unsigned char *data, size_t data_size, size_t *compressed_size, bool header);
unsigned char* ModuledSaxmanCompress(unsigned char *data, size_t data_size, size_t *compressed_size, bool header, size_t module_size);
