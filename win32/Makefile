CXXFLAGS := -O2 -s -fno-ident -static

all: fixheader fixpointer s2p2bin s2p2bin_plus

fixheader: ../build_source/fixheader.cpp
	@$(CXX) $(CXXFLAGS) $^ -o $@

fixpointer: ../build_source/fixpointer.cpp
	@$(CXX) $(CXXFLAGS) $^ -o $@

s2p2bin: ../build_source/s2p2bin.cpp ../build_source/KensSaxComp/S-Compressor.cpp
	@$(CXX) $(CXXFLAGS) $^ -o $@

s2p2bin_plus: ../build_source/s2p2bin_plus.cpp ../build_source/FW_KENSC/saxman.cpp
	@$(CXX) $(CXXFLAGS) $^ -o $@
