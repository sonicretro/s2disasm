#include <stdbool.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


void printUsage(void)
{
	printf("usage: fixpointer symbolfile.h romname.bin [patchDestLabel ptrTableLabel   tableIndex destOffset count]*\n");
}

long stringToLong(const char* string)
{
	if(string[0] == '$')
		return strtol(string+1,NULL,16);
	else
		return strtol(string,NULL,0);
}

int main(int argc, char *argv[])
{
	if(argc < 3)
	{
		printUsage();
		return 0;
	}

	argc--, argv++;

	const char* listingfilename = argv[0];
	FILE* listingfile = fopen(listingfilename,"r");
	if(!listingfile)
	{
		printf("error: couldn't open \"%s\"\n", argv[0]);
		return 0;
	}

	const char* romfilename = argv[1];
	FILE* romfile = fopen(romfilename,"rb+");
	if(!romfile)
	{
		printf("error: couldn't open \"%s\"\n", argv[1]);
		fclose(listingfile);
		return 0;
	}

	argc-=2, argv+=2;

	bool z80SizeFound = false, z80SizePatchLocFound = false, z80SizePatched = false;
	long z80Size = 0, z80SizePatchLoc = 0;

	while(argc > 0)
	{
		if(argc < 5)
		{
			printUsage();
			break;
		}
		
		// get the addresses
		long addrOfDest = 0;
		long addrOfSource = 0;
		char* labelOfDest = argv[0];
		const char* labelOfSource = argv[1];
		char line[128];
		fseek(listingfile,0,SEEK_SET);
		for(;;)
		{
			fgets(line,sizeof(line),listingfile);
			if(feof(listingfile) || ferror(listingfile))
				break;
			const char* entry0 = strstr(line,labelOfDest);
			const char* entry1 = strstr(line,labelOfSource);
			size_t destLabelLen = strlen(labelOfDest);
			size_t srcLabelLen = strlen(labelOfSource);

			if(entry0 && strlen(entry0)>destLabelLen && entry0[destLabelLen]==' ')
				sscanf(entry0+strlen(labelOfDest)," %li",&addrOfDest);
			if(entry1 && strlen(entry1)>srcLabelLen && entry1[srcLabelLen]==' ')
				sscanf(entry1+strlen(labelOfSource)," %li",&addrOfSource);

			if(argc == 5) // if it's the last time through the loop
			{
				// special case... find and fix the compressed sound driver size here
				if(!z80SizeFound)
				{
					static const char* label = "comp_z80_size";
					const char* entry2 = strstr(line,label);
					size_t labelLen = strlen(label);
					if(entry2 && strlen(entry2)>labelLen && entry2[labelLen]==' ')
					{
						sscanf(entry2+strlen(label)," %li",&z80Size);
						z80SizeFound = true;
					}
				}
				if(!z80SizePatchLocFound)
				{
					static const char* label = "movewZ80CompSize";
					const char* entry2 = strstr(line,label);
					size_t labelLen = strlen(label);
					if(entry2 && strlen(entry2)>labelLen && entry2[labelLen]==' ')
					{
						sscanf(entry2+strlen(label)," %li",&z80SizePatchLoc);
						z80SizePatchLocFound = true;
					}
				}
				if(z80SizeFound && z80SizePatchLocFound && !z80SizePatched)
				{
					// patch it
					fseek(romfile,z80SizePatchLoc+2,SEEK_SET);
					fputc((z80Size&0xFF00)>>8,romfile);
					fputc(z80Size&0xFF,romfile);
					z80SizeFound = false;
					z80SizePatchLocFound = false;
					z80SizePatched = true;
				}
			}

			if(addrOfDest && addrOfSource && (argc > 5 || z80SizePatched))
				break;
		}

		if(!addrOfDest)
			printf("warning: %s not found in %s\n",labelOfDest,listingfilename);
		if(!addrOfSource)
			printf("warning: %s not found in %s\n",labelOfSource,listingfilename);

		if(addrOfSource && addrOfDest)
		{
			long animFrame = stringToLong(argv[2]);
			long destOffset = stringToLong(argv[3]);
			long count = stringToLong(argv[4]);
			if(count>32)
			{
				printf("warning: count was %ld, max is 32\n", count);
				count = 32;
			}
			
			long addrSrc = addrOfSource+2*animFrame;
			long addrDst = addrOfDest+destOffset;
			fseek(romfile,0,SEEK_END);
			long romsize = ftell(romfile);
			if(addrSrc>=romsize || addrDst>=romsize)
			{
				printf("warning: addr src $%lX or dst $%lX > size $%lX\n", addrSrc,addrDst,romsize);
			}
			else
			{
				// patch the rom
				fseek(romfile,addrSrc,SEEK_SET);
				unsigned int off[32];
				for(long i=0;i<count;i++)
				{
					const unsigned int byte1 = fgetc(romfile);
					const unsigned int byte2 = fgetc(romfile);
					off[i] = (byte1 << 8) | byte2;
				}
				fseek(romfile,addrDst,SEEK_SET);
				for(long i=0;i<count;i++)
				{
					unsigned long ptr = addrOfSource+off[i];
					fputc((ptr&0xFF000000)>>24,romfile);
					fputc((ptr&0xFF0000)>>16,romfile);
					fputc((ptr&0xFF00)>>8,romfile);
					fputc(ptr&0xFF,romfile);
				}
			}
		}
		
		argc -= 5, argv += 5;
	}

	fclose(romfile);
	fclose(listingfile);

    return 0;
}
