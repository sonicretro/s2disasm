CFLAGS := -O2 -s -std=c99 -Wall -Wextra -pedantic -fno-ident

all: p2bin fixpointer saxman

p2bin: p2bin.c lz_comp2/LZSS.c clownlzss/common.c clownlzss/memory_stream.c clownlzss/saxman.c
	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) -o $@ $^ $(LIBS)

fixpointer: fixpointer.c
	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) -o $@ $^ $(LIBS)

saxman: saxman.c lz_comp2/LZSS.c clownlzss/common.c clownlzss/memory_stream.c clownlzss/saxman.c
	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) -o $@ $^ $(LIBS)
