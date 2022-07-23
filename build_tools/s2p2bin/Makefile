CFLAGS := -O2 -s -std=c99 -Wall -Wextra -pedantic -fno-ident

s2p2bin: s2p2bin.c lz_comp2/LZSS.c clownlzss/common.c clownlzss/memory_stream.c clownlzss/saxman.c
	$(CC) $(CFLAGS) -I. $(CPPFLAGS) $(LDFLAGS) -o $@ $^ $(LIBS)
