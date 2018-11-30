CFLAGS := -O2 -s -fno-ident -static
CXXFLAGS := -O2 -s -fno-ident -static

all: fixheader.exe fixpointer.exe s2p2bin.exe checkhash.exe

fixheader.exe: ../build_source/fixheader.cpp
	@$(CXX) $(CXXFLAGS) $^ -o $@

fixpointer.exe: ../build_source/fixpointer.cpp
	@$(CXX) $(CXXFLAGS) $^ -o $@

s2p2bin.exe: ../build_source/s2p2bin.cpp ../build_source/KensSaxComp/S-Compressor.cpp ../build_source/FW_KENSC/saxman.cpp
	@$(CXX) $(CXXFLAGS) $^ -o $@

checkhash.exe: ../build_source/checkhash/checkhash.c ../build_source/checkhash/sha256.c
	@$(CC) $(CFLAGS) $^ -o $@
