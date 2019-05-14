
// Modified in 2007 by Xenowhirl for Sonic 2 sound driver compression.
// Such compression was already supported and correct, but did not exactly invert
// the decompression of the original data. Also, the function signature
// has been changed (and the function renamed to SComp3), for my convenience.
//
// Additionally, ALL of the library except this one C++ function has been deleted.
// I believe the result still qualifies as a "library" as described in section 0 of the LGPL.

/*-----------------------------------------------------------------------------*\
|																				|
|	Saxman.dll: Compression / Decompression of data in Saxman format			|
|	Copyright © 2002-2004 The KENS Project Development Team						|
|																				|
|	This library is free software; you can redistribute it and/or				|
|	modify it under the terms of the GNU Lesser General Public					|
|	License as published by the Free Software Foundation; either				|
|	version 2.1 of the License, or (at your option) any later version.			|
|																				|
|	This library is distributed in the hope that it will be useful,				|
|	but WITHOUT ANY WARRANTY; without even the implied warranty of				|
|	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU			|
|	Lesser General Public License for more details.								|
|																				|
|	You should have received a copy of the GNU Lesser General Public			|
|	License along with this library; if not, write to the Free Software			|
|	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA	|
|																				|
\*-----------------------------------------------------------------------------*/

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//-----------------------------------------------------------------------------------------------
// Name: SComp3
// Desc: Compresses the data using the Saxman compression format
// Returns: Length of compressed data written
//-----------------------------------------------------------------------------------------------
long SComp3(FILE *Src, int srcStart, int srcLen, FILE *Dst, int dstStart, bool WithSize)
{
// Info Byte, IBP and Size
	unsigned char InfoByte;
	unsigned char IBP;
	unsigned short Size;

// Buffer Infos
	unsigned char *Buffer;
	int BSize;
	int BPointer;
	int dstBytesWritten = 0;

// Data info (temp)
	unsigned char Data[64];
	unsigned char DS;
	
// Count and Offest & Info
	int Count = 0;
	int Offset = 0;
	int IOffset = 0;
	unsigned short Info;

// Counters
	int i, j=0, k;

//----------------------------------------------------------------------------------------------------------------

	if (Src==NULL) return 0;
	BSize=srcLen+18;
	Buffer = (unsigned char*)malloc(BSize);
	if (Buffer==NULL) return 0;
	memset(Buffer, 0, 18);
	fseek(Src, srcStart, SEEK_SET);
	fread(Buffer+18,BSize-18,1,Src);
	if (WithSize) { fseek(Dst, 2+dstStart, SEEK_SET); dstBytesWritten += 2; }

	InfoByte=0;
	IBP=0;
	BPointer=18;
	DS=0;

//----------------------------------------------------------------------------------------------------------------

start:
	Count=18; if (BSize-BPointer<18) { Count=BSize; Count-=BPointer; }
	k=1; // Minimal recurrence length, will contain the total recurrence length
	i=BPointer-0x1000; if (i<0) i=0;
	do {
		j=0; // Will contain the total recurrence length for one loop, then will be set to 0
		while ( Buffer[i+j] == Buffer[BPointer+j] ) { if(++j>=Count) break; }
		// let me know if you can find a more logical pattern to these exceptions...
		if (j>k || (j==k && (i == 0x13C || i == 0x140 || i == 0x141 || i == 0x8BB || i == 0x11BB || i == 0x111D || i == 0x112D || i == 0x1133 || i == 0x11A7 || i == 0x11CF || i == 0x11E3) ))
			{ k=j; Offset=i; }
		if (i==0) i=17;
	} while (++i<BPointer);
	Count=k;

//----------------------------------------------------------------------------------------------------------------

	if (Count==1)
	{
		InfoByte|=1<<IBP; // 2^IBP
		
		Data[DS]=Buffer[BPointer];
		DS+=1;

		if (++IBP==8) { fwrite(&InfoByte,1,1,Dst); fwrite(&Data,DS,1,Dst); dstBytesWritten += 1+DS; InfoByte=IBP=DS=0; }	
	}

	else if (Count==2)
	{
		InfoByte|=1<<IBP; // 2^IBP

		Data[DS]=Buffer[BPointer];
		DS+=1;

		if (++IBP==8) { fwrite(&InfoByte,1,1,Dst); fwrite(&Data,DS,1,Dst); dstBytesWritten += 1+DS; InfoByte=IBP=DS=0; }	

		--Count;
	}

	else
	{
		IOffset = ((Offset - 0x12) & 0x0FFF) - 0x12;

		Info = ( (IOffset & 0xFF) << 8 ) | ( (IOffset & 0xF00) >> 4 ) | ( (Count - 3) & 0x0F );

		Data[DS]=(unsigned char)(Info >> 8);
		Data[DS+1]=(unsigned char)(Info & 0xFF);
		DS+=2;

		if (++IBP==8) { fwrite(&InfoByte,1,1,Dst); fwrite(&Data,DS,1,Dst); dstBytesWritten += 1+DS; InfoByte=IBP=DS=0; }	
	}

//----------------------------------------------------------------------------------------------------------------

	BPointer+=Count;
	if (BPointer<BSize) goto start;

//----------------------------------------------------------------------------------------------------------------

	fwrite(&InfoByte,1,1,Dst); fwrite(&Data,DS,1,Dst); dstBytesWritten += 1+DS; InfoByte=IBP=DS=0;
	if (WithSize)
	{
		Size=dstBytesWritten-2;
		fseek(Dst, dstStart, SEEK_SET);
		fwrite(&Size, 2, 1, Dst);
	}
	fseek(Dst, dstStart+dstBytesWritten, SEEK_SET);
	if (dstBytesWritten & 1) { fputc(0x4E, Dst); dstBytesWritten++; } // I don't know what 0x4E is, but it was at the end of the compressed data in the rom.
	free(Buffer);
	return dstBytesWritten;
}
