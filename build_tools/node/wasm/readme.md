This is a WebAssembly build of the Macro Assembler AS, so that the build script
does not need a native assembler for every platform.

It was built from https://github.com/flamewing/asl-releases (the same fork that
the native assemblers in the other 'build_tools' folders come from) with
Emscripten:

    cmake -S . -B build-native -DCMAKE_BUILD_TYPE=Release
    cmake --build build-native --target rescomp

    emcmake cmake -S . -B build-wasm -DCMAKE_BUILD_TYPE=Release \
        -DIMPORT_EXECUTABLES=build-native/ImportExecutables.cmake \
        -DCMAKE_EXE_LINKER_FLAGS="-O3 -sMODULARIZE=1 -sEXPORT_NAME=createASL -sEXPORTED_RUNTIME_METHODS=FS,callMain,ENV -sALLOW_MEMORY_GROWTH=0 -sINITIAL_MEMORY=1073741824 -sINVOKE_RUN=0 -sEXIT_RUNTIME=1 -sFORCE_FILESYSTEM=1 -sSTACK_SIZE=8388608"
    cmake --build build-wasm --target asl

'asl.js' and 'asl.wasm' are the results of that build, and the files in 'msg'
are the assembler's message catalogues, which the native build generates.

Note that the assembler must come from that fork: stock AS truncates long macro
argument lists, which breaks the 'jmpTos' macros in 's2.asm'.

A fixed heap is used instead of a growable one because it makes assembling
's2.asm' around 8% faster.
