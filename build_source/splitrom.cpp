#include <stdio.h>
#include <stdlib.h>

#ifdef _WIN32
#include <direct.h> // windows mkdir
#else
#include <string.h>
#endif

static const int pathMax = 1024;
static const int lineMax = 1024;

int main(int argc, char *argv[])
{
	if(argc < 3)
	{
		printf("usage: splitrom.exe therom.bin splitdesc.txt\n");
		return 0;
	}
	argc--, argv++;

	unsigned char* romData;
	{
		FILE* rom  = fopen(argv[0], "rb");
		if(!rom)
		{
			printf("ERROR: couldn't open romfile \"%s\"\n", argv[0]);
			return 1;
		}
		fseek(rom, 0, SEEK_END);
		int romSize = ftell(rom);
		romData = (unsigned char*)malloc(romSize);
		fseek(rom, 0, SEEK_SET);
		fread(romData, romSize, 1, rom);
		fclose(rom);
	}


	FILE* desc = fopen(argv[1], "rb");
	if(!desc)
	{
		printf("ERROR: couldn't open descfile \"%s\"\n", argv[1]);
		return 2;
	}
	char line [lineMax];
	while(1)
	{
		fgets(line, lineMax, desc);
		if(feof(desc) || ferror(desc))
			break;
		if(line[0] == '#')
		{
			if(line[1] == 's')
			{
				// make a file
				int start, end;
				char outname [pathMax];
				if(sscanf(line, "#split %X, %X, %[^\r\n]", &start, &end, outname) == 3 && end >= start)
				{
					FILE* out = fopen(outname, "wb");
					if(out)
					{
						fwrite(romData + start, end - start, 1, out);
						fclose(out);
					}
				}
			}
			else if(line[1] == 'd')
			{
				// make a directory
#ifdef _WIN32
				char dirname [pathMax];
				if(sscanf(line, "#dir %[^\r\n]", dirname) == 1)
					mkdir(dirname);
#else
				// if you want to implement a better way to make a directory on your platform, be my guest
				char command [pathMax+7];
				strcpy(command, "mkdir \"");
				char* dirname = command+7;
				if(sscanf(line, "#dir %[^\r\n]", dirname) == 1)
				{
					strcat(dirname, "\"");
					system(command);
				}
#endif
			}
		}
	}

	fclose(desc);
	free(romData);

    return 0;
}
