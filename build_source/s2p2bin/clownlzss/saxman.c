/*
	(C) 2018-2021 Clownacy

	This software is provided 'as-is', without any express or implied
	warranty.  In no event will the authors be held liable for any damages
	arising from the use of this software.

	Permission is granted to anyone to use this software for any purpose,
	including commercial applications, and to alter it and redistribute it
	freely, subject to the following restrictions:

	1. The origin of this software must not be misrepresented; you must not
	   claim that you wrote the original software. If you use this software
	   in a product, an acknowledgment in the product documentation would be
	   appreciated but is not required.
	2. Altered source versions must be plainly marked as such, and must not be
	   misrepresented as being the original software.
	3. This notice may not be removed or altered from any source distribution.
*/

#include "saxman.h"

#include <assert.h>
#include <stddef.h>

#include "clowncommon.h"

#include "clownlzss.h"
#include "common.h"
#include "memory_stream.h"

#define TOTAL_DESCRIPTOR_BITS 8

typedef struct SaxmanInstance
{
	MemoryStream *output_stream;
	MemoryStream match_stream;

	unsigned int descriptor;
	unsigned int descriptor_bits_remaining;
} SaxmanInstance;

static void FlushData(SaxmanInstance *instance)
{
	size_t match_buffer_size;
	unsigned char *match_buffer;

	MemoryStream_WriteByte(instance->output_stream, instance->descriptor);

	match_buffer_size = MemoryStream_GetPosition(&instance->match_stream);
	match_buffer = MemoryStream_GetBuffer(&instance->match_stream);

	MemoryStream_Write(instance->output_stream, match_buffer, 1, match_buffer_size);
}

static void PutMatchByte(SaxmanInstance *instance, unsigned int byte)
{
	MemoryStream_WriteByte(&instance->match_stream, byte);
}

static void PutDescriptorBit(SaxmanInstance *instance, cc_bool_fast bit)
{
	assert(bit == 0 || bit == 1);

	if (instance->descriptor_bits_remaining == 0)
	{
		FlushData(instance);

		instance->descriptor_bits_remaining = TOTAL_DESCRIPTOR_BITS;
		MemoryStream_Rewind(&instance->match_stream);
	}

	--instance->descriptor_bits_remaining;

	instance->descriptor >>= 1;

	if (bit)
		instance->descriptor |= 1 << (TOTAL_DESCRIPTOR_BITS - 1);
}

static void DoLiteral(const unsigned char *value, void *user)
{
	SaxmanInstance *instance = (SaxmanInstance*)user;

	PutDescriptorBit(instance, 1);
	PutMatchByte(instance, value[0]);
}

static void DoMatch(size_t distance, size_t length, size_t offset, void *user)
{
	SaxmanInstance *instance = (SaxmanInstance*)user;

	(void)distance;

	PutDescriptorBit(instance, 0);
	PutMatchByte(instance, (offset - 0x12) & 0xFF);
	PutMatchByte(instance, (((offset - 0x12) & 0xF00) >> 4) | (length - 3));
}

static size_t GetMatchCost(size_t distance, size_t length, void *user)
{
	(void)distance;
	(void)length;
	(void)user;

	if (length >= 3)
		return 1 + 16;	/* Descriptor bit, offset/length bits */
	else
		return 0;
}

static void FindExtraMatches(const unsigned char *data, size_t data_size, size_t offset, ClownLZSS_GraphEdge *node_meta_array, void *user)
{
	(void)user;

	if (offset < 0x1000)
	{
		size_t i;

		const size_t max_read_ahead = CLOWNLZSS_MIN(0x12, data_size - offset);

		for (i = 0; i < max_read_ahead && data[offset + i] == 0; ++i)
		{
			const unsigned int cost = GetMatchCost(0, i + 1, user);

			if (cost && node_meta_array[offset + i + 1].u.cost > node_meta_array[offset].u.cost + cost)
			{
				node_meta_array[offset + i + 1].u.cost = node_meta_array[offset].u.cost + cost;
				node_meta_array[offset + i + 1].previous_node_index = offset;
				node_meta_array[offset + i + 1].match_length = i + 1;
				node_meta_array[offset + i + 1].match_offset = 0xFFF;
			}
		}
	}
}

static CLOWNLZSS_MAKE_COMPRESSION_FUNCTION(CompressData, 1, 0x12, 0x1000, FindExtraMatches, 1 + 8, DoLiteral, GetMatchCost, DoMatch)

static void SaxmanCompressStream(const unsigned char *data, size_t data_size, MemoryStream *output_stream, void *user)
{
	const cc_bool_fast header = *(cc_bool_fast*)user;

	SaxmanInstance instance;

	size_t file_offset;

	instance.output_stream = output_stream;
	MemoryStream_Create(&instance.match_stream, CC_TRUE);
	instance.descriptor = 0;
	instance.descriptor_bits_remaining = TOTAL_DESCRIPTOR_BITS;

	file_offset = MemoryStream_GetPosition(output_stream);

	if (header)
	{
		/* Blank header */
		MemoryStream_WriteByte(output_stream, 0);
		MemoryStream_WriteByte(output_stream, 0);
	}

	CompressData(data, data_size, &instance);

	instance.descriptor >>= instance.descriptor_bits_remaining;
	FlushData(&instance);

	MemoryStream_Destroy(&instance.match_stream);

	if (header)
	{
		unsigned char *buffer = MemoryStream_GetBuffer(output_stream);
		const size_t compressed_size = MemoryStream_GetPosition(output_stream) - file_offset - 2;

		/* Fill in header */
		buffer[file_offset + 0] = (compressed_size >> 0) & 0xFF;
		buffer[file_offset + 1] = (compressed_size >> 8) & 0xFF;
	}
}

unsigned char* ClownLZSS_SaxmanCompress(const unsigned char *data, size_t data_size, size_t *compressed_size, cc_bool_fast header)
{
	return RegularWrapper(data, data_size, compressed_size, &header, SaxmanCompressStream);
}

unsigned char* ClownLZSS_ModuledSaxmanCompress(const unsigned char *data, size_t data_size, size_t *compressed_size, cc_bool_fast header, size_t module_size)
{
	return ModuledCompressionWrapper(data, data_size, compressed_size, &header, SaxmanCompressStream, module_size, 1);
}
