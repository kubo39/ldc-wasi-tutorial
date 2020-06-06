// ./build-ldc/bin/ldc2 -mtriple=wasm32-unknown-wasi -betterC --relocation-model=static --fvisibility=hidden -L./wasi-sdk-10.0/share/wasi-sysroot/lib/wasm32-wasi/crt1.o -L./wasi-sdk-10.0/share/wasi-sysroot/lib/wasm32-wasi/libc.a -L--stack-first -L--gc-sections --linker=./wasi-sdk-10.0/bin/wasm-ld memory.d

import core.stdc.stdio;
import core.stdc.stdlib : abort;

pragma(LDC_intrinsic, "llvm.wasm.memory.grow.i32")
int llvm_wasm_memory_grow(int mem, int pages);

pragma(LDC_intrinsic, "llvm.wasm.memory.size.i32")
int llvm_wasm_memory_size(int mem);

size_t wasmMemorySize(uint mem)
{
    // Currently wasm only supports one memory, so it is required that
    // zero is passed in.
    if (mem != 0)
        abort();
    return llvm_wasm_memory_size(0);
}

size_t wasmMemoryGrow(uint mem, size_t delta)
{
    // Currently wasm only supports one memory, so it is required that
    // zero is passed in.
    if (mem != 0)
        abort();
    return llvm_wasm_memory_grow(0, cast(int) delta);
}

extern (C) int main()
{
    auto mem = wasmMemorySize(0);
    printf("memory size: %d\n", mem);
    const ret = wasmMemoryGrow(0, 1);
    mem = wasmMemorySize(0);
    printf("memory size: %d\n", mem);
    return 0;
}
