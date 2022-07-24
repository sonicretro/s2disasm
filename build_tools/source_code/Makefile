CFLAGS := -O2 -s -std=c99 -Wall -Wextra -pedantic -fno-ident

all: s2p2bin fixpointer saxman

s2p2bin: s2p2bin.c lz_comp2/LZSS.c clownlzss/common.c clownlzss/memory_stream.c clownlzss/saxman.c
	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) -o $@ $^ $(LIBS)

fixpointer: fixpointer.c
	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) -o $@ $^ $(LIBS)

saxman: saxman.c lz_comp2/LZSS.c clownlzss/common.c clownlzss/memory_stream.c clownlzss/saxman.c
	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) -o $@ $^ $(LIBS)
