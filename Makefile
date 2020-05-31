LDC = $(PWD)/build-ldc/bin/ldc2
LD = $(PWD)/wasi-sdk-10.0/bin/wasm-ld
WASI_SDK_PATH = $(PWD)/wasi-sdk-10.0
WASI_SYSROOT = $(WASI_SDK_PATH)/share/wasi-sysroot
WASMTIME = wasmtime

.PHONY: all clean

all: build

build:
	$(LDC) --mtriple=wasm32-unknown-wasi -betterC -L$(WASI_SYSROOT)/lib/wasm32-wasi/crt1.o -L$(WASI_SYSROOT)/lib/wasm32-wasi/libc.a --linker=$(LD) main.d

run: build
	$(WASMTIME) --dir=. --dir=/tmp main.wasm test.txt /tmp/somewhere.txt

clean:
	$(RM) *.o *.wasm
