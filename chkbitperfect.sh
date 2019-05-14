#!/bin/bash

[[ ! -d bin ]] && mkdir bin

if [[ ! -f bin/checkhash ]]; then
	echo "Compiling checkhash..."
	gcc -std=c99 -O2 -s -fno-ident -flto -o bin/checkhash build_source/checkhash/checkhash.c build_source/checkhash/sha256.c &> /dev/null
	echo ""
fi

echo "Assembling REV00..."
./build.sh -a -r0 &> /dev/null
if [[ -f s2built.bin ]]; then
	bin/checkhash s2built.bin 07329F4561044A504923EB0742894485C61FC42EBB0891EEBFF247CA2E086D61 &> /dev/null && echo "REV00 is bit-perfect" || echo "REV00 is NOT bit-perfect"
else
	echo "REV00 build failed"
fi

echo ""

echo "Assembling REV01..."
./build.sh -a -r1 &> /dev/null
if [[ -f s2built.bin ]]; then
	bin/checkhash s2built.bin 193BC4064CE0DAF27EA9E908ED246D87EC576CC294833BADEBB590B6AD8E8F6B &> /dev/null && echo "REV01 is bit-perfect" || echo "REV01 is NOT bit-perfect"
else
	echo "REV01 build failed"
fi

echo ""

echo "Assembling REV02..."
./build.sh -a -r2 &> /dev/null
if [[ -f s2built.bin ]]; then
	bin/checkhash s2built.bin 3EF0C3CDDEC79CB66AF7E5053963C4506E5551E2A47338C53236388F6E081A19 &> /dev/null && echo "REV02 is bit-perfect" || echo "REV02 is NOT bit-perfect"
else
	echo "REV02 build failed"
fi
