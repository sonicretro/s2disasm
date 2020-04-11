#!/bin/bash

[[ ! -d bin ]] && mkdir bin

if [[ ! -f bin/s2p2bin ]]; then
	echo "Compiling s2p2bin..."
	gcc -std=c99 -O2 -s -fno-ident -flto -o bin/s2p2bin build_source/s2p2bin/s2p2bin.c build_source/s2p2bin/lz_comp2/LZSS.c build_source/s2p2bin/clownlzss/common.c build_source/s2p2bin/clownlzss/memory_stream.c build_source/s2p2bin/clownlzss/saxman.c &> /dev/null
fi

if [[ ! -f bin/fixpointer ]]; then
	echo "Compiling fixpointer..."
	gcc -std=c99 -O2 -s -fno-ident -flto -o bin/fixpointer build_source/fixpointer.c &> /dev/null
fi

if [[ ! -f bin/fixheader ]]; then
	echo "Compiling fixheader..."
	gcc -std=c99 -O2 -s -fno-ident -flto -o bin/fixheader build_source/fixheader.c &> /dev/null
fi

[[ -f s2built.bin ]] && mv -f s2built.bin s2built.prev.bin
rm -f s2.p s2.h s2.log

debug_syms=""
print_err="-E -q"
revision_override=""
s2p2bin_args=""

for n in `seq 1 6`; do
	if [[ "$1" == "-ds" ]]; then
		debug_syms="-g MAP"
		echo "Will generate debug symbols"
	elif [[ "$1" == "-pe" ]]; then
		print_err=""
		echo "Selected detailed assembler output"
	elif [[ "$1" == "-a" ]]; then
		s2p2bin_args="-a"
		echo "Will use accurate sound driver compression"
	elif [[ "$1" == "-r0" ]]; then
		revision_override="-D gameRevision=0"
		echo "Building REV00"
	elif [[ "$1" == "-r1" ]]; then
		revision_override="-D gameRevision=1"
		echo "Building REV01"
	elif [[ "$1" == "-r2" ]]; then
		revision_override="-D gameRevision=2"
		echo "Building REV02"
	fi
	shift
done

echo Assembling...

asl -xx -c $debug_syms $print_err -A -U -L $revision_override s2.asm

if [[ ! -f s2.p ]]; then
	echo
	echo "*****************************************"
	echo "*                                       *"
	echo "*       There were build errors.        *"
	echo "*                                       *"
	echo "*****************************************"
	echo
	cat s2.log
	exit 1
fi

[[ -f s2.p ]] && bin/s2p2bin $s2p2bin_args s2.p s2built.bin s2.h
[[ -f s2built.bin ]] && bin/fixpointer s2.h s2built.bin   off_3A294 MapRUnc_Sonic \$2D 0 4   word_728C_user Obj5F_MapUnc_7240 2 2 1
[[ -f s2built.bin ]] && bin/fixheader s2built.bin

if [[ -f s2.log ]]; then
	echo
	echo "*****************************************"
	echo "*                                       *"
	echo "*      There were build warnings.       *"
	echo "*                                       *"
	echo "*****************************************"
	echo
	cat s2.log
fi
