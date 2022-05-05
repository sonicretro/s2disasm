#!/bin/bash

[[ ! -d bin ]] && mkdir bin

if [[ ! -f bin/checkhash ]]; then
	echo "Compiling checkhash..."
	gcc -std=c99 -O2 -s -fno-ident -flto -o bin/checkhash build_source/checkhash/checkhash.c build_source/checkhash/sha256.c &> /dev/null
	echo ""
fi

echo "Assembling KiS2..."
./build.sh -a &> /dev/null
if [[ -f s2built.bin ]]; then
	bin/checkhash s2built.bin 3DA827D319A60B6180E327C37E1FE5D448746C1644CCE01ADA1F2788D1E182F4 &> /dev/null && echo "KiS2 is bit-perfect" || echo "KiS2 is NOT bit-perfect"
else
	echo "KiS2 build failed"
fi
