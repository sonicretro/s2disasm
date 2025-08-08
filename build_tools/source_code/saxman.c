#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "clownlzss/saxman.h"
#include "lz_comp2/LZSS.h"

int main(int argc, char **argv)
{
	int exit_code = EXIT_FAILURE;

	const cc_bool_fast accurate_compression = argc > 1 && strcmp(argv[1], "-a") == 0;

	if ((accurate_compression && argc != 4) || (!accurate_compression && argc != 3))
	{
		puts("Pass the input filename and output filename as arguments.");
	}
	else
	{
		const char* const input_filename = argv[accurate_compression ? 2 : 1];
		const char* const output_filename = argv[accurate_compression ? 3 : 2];

		FILE* const input_file = fopen(input_filename, "rb");

		if (input_file == NULL)
		{
			fprintf(stderr, "Could not open file '%s' for reading.\n", input_filename);
		}
		else
		{
			FILE* const output_file = fopen(output_filename, "wb");

			if (output_file == NULL)
			{
				fprintf(stderr, "Could not open file '%s' for writing.\n", output_filename);
			}
			else
			{
				size_t compressed_size;

				fseek(output_file, 2, SEEK_SET);

				if (accurate_compression)
				{
					Encode(input_file, output_file, -1);

					compressed_size = ftell(output_file) - 2;

					exit_code = EXIT_SUCCESS;
				}
				else
				{
					size_t input_file_size;
					unsigned char *uncompressed_buffer;

					fseek(input_file, 0, SEEK_END);
					input_file_size = ftell(input_file);
					rewind(input_file);

					uncompressed_buffer = (unsigned char*)malloc(input_file_size);

					if (uncompressed_buffer == NULL)
					{
						fputs("Failed to allocate memory for compression buffer.\n", stderr);

						compressed_size = 0;
					}
					else
					{
						unsigned char *compressed_buffer;

						fread(uncompressed_buffer, input_file_size, 1, input_file);

						compressed_buffer = ClownLZSS_SaxmanCompress(uncompressed_buffer, input_file_size, &compressed_size, CC_FALSE);
						free(uncompressed_buffer);
						fwrite(compressed_buffer, compressed_size, 1, output_file);
						free(compressed_buffer);

						exit_code = EXIT_SUCCESS;
					}
				}

				rewind(output_file);
				fputc((compressed_size >> 0) & 0xFF, output_file);
				fputc((compressed_size >> 8) & 0xFF, output_file);

				fclose(output_file);
			}

			fclose(input_file);
		}
	}

	return exit_code;
}
