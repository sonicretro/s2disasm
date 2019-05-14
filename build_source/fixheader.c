#include <stdio.h>
#include <stdlib.h>

void printUsage(void)
{
	printf("usage: fixheader.exe romname.bin\n");
}

int main(int argc, char *argv[])
{
	if(argc < 2)
	{
		printUsage();
		return 0;
	}
	argc--, argv++;

	char* romfilename = argv[0];
	FILE* romfile = fopen(romfilename,"rb+");
	if(!romfile)
	{
		printf("error: couldn't open \"%s\"\n", argv[0]);
		return 0;
	}

	fseek(romfile, 0, SEEK_END);
	int romSize = ftell(romfile);
	if(romSize < 0x200)
	{
		fclose(romfile);
		return 0;
	}

	int romEnd = romSize - 1;
	fseek(romfile, 0x1A4, SEEK_SET);
	fputc((romEnd&0xFF000000)>>24, romfile);
	fputc((romEnd&0xFF0000)>>16, romfile);
	fputc((romEnd&0xFF00)>>8, romfile);
	fputc(romEnd&0xFF, romfile);

	unsigned short sum = 0;
	fseek(romfile, 0x200, SEEK_SET);
	romSize -= 0x200;
	
	unsigned char* data = (unsigned char*)malloc(romEnd);
	unsigned char* ptr = data;

	fread(data, romEnd,1, romfile);

	// checksum calculating loop
	int loopCount = (romSize >> 1) + 1;
	while(--loopCount)
	{
		sum += *ptr++<<8;
		sum += *ptr++;
	}
	if(romSize&1)
		sum += *ptr++<<8;

	free(data);

	fseek(romfile, 0x18E, SEEK_SET);
	fputc((sum&0xFF00)>>8, romfile);
	fputc(sum&0xFF, romfile);

	fclose(romfile);
    return 0;
}
