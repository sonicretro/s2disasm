#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "sha256.h"

int main(int argc, char *argv[])
{
	if (argc < 3)
	{
		printf("Usage: checkhash [filename] [hash]\nCompares file to SHA-256 hash. Returns 0 if they match, and 1 if they don't.\n");
	}
	else if (strlen(argv[2]) != 64)
	{
		printf("Hash is wrong size (should be 64-digits long)\n");
	}
	else
	{
		FILE *file = fopen(argv[1], "rb");

		if (!file)
		{
			printf("Could not open file '%s'\n", argv[1]);
		}
		else
		{
			// Read file into buffer
			fseek(file, 0, SEEK_END);
			const long file_size = ftell(file);
			rewind(file);

			unsigned char *file_buffer = malloc(file_size);
			fread(file_buffer, 1, file_size, file);
			fclose(file);

			// Generate hash
			SHA256_CTX sha256_ctx;
			sha256_init(&sha256_ctx);
			sha256_update(&sha256_ctx, file_buffer, file_size);

			free(file_buffer);

			unsigned char hash[32];
			sha256_final(&sha256_ctx, hash);

			// Convert hash to string, so we can compare with the argument
			const char lookup[0x10] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'};

			char hash_string[64];

			for (unsigned int i = 0; i < 32; ++i)
			{
				hash_string[i * 2] = lookup[hash[i] >> 4];
				hash_string[(i * 2) + 1] = lookup[hash[i] & 0xF];
			}

			// Compare hashes
			if (memcmp(hash_string, argv[2], 64))
			{
				printf("File does not match hash\n");
			}
			else
			{
				printf("File matches hash\n");
				return 0;
			}
		}
	}

	return 1;
}
