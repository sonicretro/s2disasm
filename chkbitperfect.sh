#!/bin/bash

[[ ! -d bin ]] && mkdir bin

if [[ ! -f bin/checkhash ]]; then
	echo "Compiling checkhash..."
	gcc -std=c99 -O2 -s -fno-ident -flto -o bin/checkhash build_source/checkhash/checkhash.c build_source/checkhash/sha256.c &> /dev/null
	echo ""
fi

echo "Assembling..."
./build.sh -a &> /dev/null
if [[ -f s2built.bin ]]; then
	bin/checkhash s2built.bin 429F6A1FACE094147FA703419A7EA2CEA72272C4E4D2CF10A0926DEEC565110E &> /dev/null && echo "ROM is bit-perfect" || echo "ROM is NOT bit-perfect"
else
	echo "Build failed"
fi
