cmake_minimum_required(VERSION 3.0)

project(build_tools LANGUAGES C)

add_executable(saxman
	"saxman.c"
	"lz_comp2/LZSS.c"
	"clownlzss/common.c"
	"clownlzss/memory_stream.c"
	"clownlzss/saxman.c"
)
