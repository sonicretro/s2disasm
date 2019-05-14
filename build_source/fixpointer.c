#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


void printUsage(void)
{
	printf("usage: fixpointer.exe symbolfile.h romname.bin [patchDestLabel ptrTableLabel   tableIndex destOffset count]*\n");
}

int stringToInt(const char* string)
{
	if(string[0] == '$')
		return strtol(string+1,0,16);
	else if(string[1] == 'x' || string[1] == 'X')
		return strtol(string,0,16);
	else
		return strtol(string,0,10);
}

int main(int argc, char *argv[])
{
	if(argc < 3)
	{
		printUsage();
		return 0;
	}

	argc--, argv++;

	char* listingfilename = argv[0];
	FILE* listingfile = fopen(listingfilename,"r");
	if(!listingfile)
	{
		printf("error: couldn't open \"%s\"\n", argv[0]);
		return 0;
	}

	char* romfilename = argv[1];
	FILE* romfile = fopen(romfilename,"rb+");
	if(!romfile)
	{
		printf("error: couldn't open \"%s\"\n", argv[1]);
		fclose(listingfile);
		return 0;
	}

	argc-=2, argv+=2;

	bool z80SizeFound = false, z80SizePatchLocFound = false, z80SizePatched = false;
	int z80Size = 0, z80SizePatchLoc = 0;

	while(argc > 0)
	{
		if(argc < 5)
		{
			printUsage();
			break;
		}
		
		// get the addresses
		int addrOfDest = 0;
		int addrOfSource = 0; 
		char* labelOfDest = argv[0];
		char* labelOfSource = argv[1];
		char line[128];
		fseek(listingfile,0,SEEK_SET);
		for(;;)
		{
			fgets(line,128,listingfile);
			if(feof(listingfile) || ferror(listingfile))
				break;
			char* entry0 = strstr(line,labelOfDest);
			char* entry1 = strstr(line,labelOfSource);
			int destLabelLen = strlen(labelOfDest);
			int srcLabelLen = strlen(labelOfSource);

			if(entry0 && strlen(entry0)>destLabelLen && entry0[destLabelLen]==' ')
				sscanf(entry0+strlen(labelOfDest)," %X",&addrOfDest);
			if(entry1 && strlen(entry1)>srcLabelLen && entry1[srcLabelLen]==' ')
				sscanf(entry1+strlen(labelOfSource)," %X",&addrOfSource);

			if(argc == 5) // if it's the last time through the loop
			{
				// special case... find and fix the compressed sound driver size here
				if(!z80SizeFound)
				{
					static const char* label = "comp_z80_size";
					char* entry2 = strstr(line,label);
					int labelLen = strlen(label);
					if(entry2 && strlen(entry2)>labelLen && entry2[labelLen]==' ')
						sscanf(entry2+strlen(label)," %X",&z80Size), z80SizeFound = true;
				}
				if(!z80SizePatchLocFound)
				{
					static const char* label = "movewZ80CompSize";
					char* entry2 = strstr(line,label);
					int labelLen = strlen(label);
					if(entry2 && strlen(entry2)>labelLen && entry2[labelLen]==' ')
						sscanf(entry2+strlen(label)," %X",&z80SizePatchLoc), z80SizePatchLocFound = true;
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
			int animFrame = stringToInt(argv[2]);
			int destOffset = stringToInt(argv[3]);
			int count = stringToInt(argv[4]);
			if(count>32)
			{
				printf("warning: count was %d, max is 32\n", count);
				count = 32;
			}
			
			int addrSrc = addrOfSource+2*animFrame;
			int addrDst = addrOfDest+destOffset;
			fseek(romfile,0,SEEK_END);
			int romsize = ftell(romfile);
			if(addrSrc>=romsize || addrDst>=romsize)
			{
				printf("warning: addr src $%X or dst $%X > size $%X\n", addrSrc,addrDst,romsize);
			}
			else
			{
				// patch the rom
				fseek(romfile,addrSrc,SEEK_SET);
				unsigned char byte[2];
				unsigned short off[32];
				for(int i=0;i<count;i++)
				{
					byte[0] = fgetc(romfile), byte[1] = fgetc(romfile);
					off[i] = (byte[0] << 8) | byte[1];
				}
				fseek(romfile,addrDst,SEEK_SET);
				for(int i=0;i<count;i++)
				{
					unsigned int ptr = addrOfSource+off[i];
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
