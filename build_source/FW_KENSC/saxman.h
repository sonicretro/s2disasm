/* -*- Mode: C++; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- */
/*
 * Copyright (C) Flamewing 2013 <flamewing.sonic@gmail.com>
 *
 * Modified by MainMemory
 *
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as published
 * by the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef _SAXMAN_H_
#define _SAXMAN_H_

#include <iosfwd>

class saxman {
private:
	static void encode_internal(std::ostream &Dst, unsigned char const *&Buffer,
	                            std::streamsize const BSize);
public:
	static bool encode(char *const Buffer, std::streamsize BSize, std::ostream &Dst, bool WithSize, size_t *CompSize);
};

#endif // _SAXMAN_H_