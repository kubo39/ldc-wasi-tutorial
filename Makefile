LDC = $(PWD)/build-ldc/bin/ldc2
LD = $(PWD)/wasi-sdk-10.0/bin/wasm-ld
WASI_SDK_PATH = $(PWD)/wasi-sdk-10.0

.PHONY: all clean

all: build

build:
	$(LDC) --mtriple=wasm32-unknown-wasi -betterC -L$(WASI_SDK_PATH)/share/wasi-sysroot/lib/wasm32-wasi/crt1.o -L$(WASI_SDK_PATH)/share/wasi-sysroot/lib/wasm32-wasi/libc.a --linker=$(LD) main.d

clean:
	$(RM) *.o *.wasm
