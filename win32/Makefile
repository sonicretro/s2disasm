CFLAGS := -std=c99 -O2 -s -fno-ident -flto

all: fixheader.exe fixpointer.exe s2p2bin.exe checkhash.exe

fixheader.exe: ../build_source/fixheader.c
	@$(CC) $(CFLAGS) $^ -o $@

fixpointer.exe: ../build_source/fixpointer.c
	@$(CC) $(CFLAGS) $^ -o $@

s2p2bin.exe: ../build_source/s2p2bin/s2p2bin.c ../build_source/s2p2bin/lz_comp2/LZSS.c ../build_source/s2p2bin/clownlzss/common.c ../build_source/s2p2bin/clownlzss/memory_stream.c ../build_source/s2p2bin/clownlzss/saxman.c
	@$(CC) $(CFLAGS) $^ -o $@

checkhash.exe: ../build_source/checkhash/checkhash.c ../build_source/checkhash/sha256.c
	@$(CC) $(CFLAGS) $^ -o $@
