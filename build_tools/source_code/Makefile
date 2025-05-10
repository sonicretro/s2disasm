CFLAGS := -O2 -s -std=c99 -Wall -Wextra -pedantic -fno-ident -DNDEBUG

all: saxman

saxman: saxman.c lz_comp2/LZSS.c clownlzss/common.c clownlzss/memory_stream.c clownlzss/saxman.c
	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) -o $@ $^ $(LIBS)
