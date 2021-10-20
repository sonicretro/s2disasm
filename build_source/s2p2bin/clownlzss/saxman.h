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

#ifndef CLOWNLZSS_SAXMAN_H
#define CLOWNLZSS_SAXMAN_H

#include <stddef.h>

#include "clowncommon.h"

unsigned char* ClownLZSS_SaxmanCompress(const unsigned char *data, size_t data_size, size_t *compressed_size, cc_bool_fast header);
unsigned char* ClownLZSS_ModuledSaxmanCompress(const unsigned char *data, size_t data_size, size_t *compressed_size, cc_bool_fast header, size_t module_size);

#endif /* CLOWNLZSS_SAXMAN_H */
