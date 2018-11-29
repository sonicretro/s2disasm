CXXFLAGS := -O2 -s -fno-ident -static

all: fixheader.exe fixpointer.exe s2p2bin.exe

fixheader.exe: ../build_source/fixheader.cpp
	@$(CXX) $(CXXFLAGS) $^ -o $@

fixpointer.exe: ../build_source/fixpointer.cpp
	@$(CXX) $(CXXFLAGS) $^ -o $@

s2p2bin.exe: ../build_source/s2p2bin.cpp ../build_source/KensSaxComp/S-Compressor.cpp ../build_source/FW_KENSC/saxman.cpp
	@$(CXX) $(CXXFLAGS) $^ -o $@
