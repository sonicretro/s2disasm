#!/bin/bash

[[ ! -d bin ]] && mkdir bin

if [[ ! -f bin/checkhash ]]; then
	echo "Compiling checkhash..."
	gcc -O3 -s -o bin/checkhash build_source/checkhash/checkhash.c build_source/checkhash/sha256.c &> /dev/null
	echo ""
fi

echo "Assembling..."
./build.sh -a &> /dev/null
if [[ -f s2built.bin ]]; then
	bin/checkhash s2built.bin 050F9442320386DD3CD5824430135401A56117CBFB468D031416F03517724672 &> /dev/null && echo "ROM is bit-perfect" || echo "ROM is NOT bit-perfect"
else
	echo "Build failed"
fi
