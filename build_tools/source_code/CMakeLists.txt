cmake_minimum_required(VERSION 3.20)

project(build_tools LANGUAGES C)

add_executable(s2p2bin 
	"s2p2bin.c"
	"lz_comp2/LZSS.c"
	"clownlzss/common.c"
	"clownlzss/memory_stream.c"
	"clownlzss/saxman.c"
)

add_executable(fixpointer
	"fixpointer.c"
)

add_executable(saxman
	"saxman.c"
	"lz_comp2/LZSS.c"
	"clownlzss/common.c"
	"clownlzss/memory_stream.c"
	"clownlzss/saxman.c"
)
