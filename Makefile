LDC = $(PWD)/build-ldc/bin/ldc2
LD = $(PWD)/wasi-sdk-10.0/bin/wasm-ld

DFLAGS = --mtriple=wasm32-unknown-wasi -betterC

SOURCES = main.d
TARGET = main.wasm

WASI_SDK_PATH = $(PWD)/wasi-sdk-10.0
WASI_SYSROOT = $(WASI_SDK_PATH)/share/wasi-sysroot

WASMTIME = wasmtime

.PHONY: all clean

all: build

build:
	$(LDC) $(DFLAGS) -L$(WASI_SYSROOT)/lib/wasm32-wasi/crt1.o -L$(WASI_SYSROOT)/lib/wasm32-wasi/libc.a -L--stack-first --linker=$(LD) -of=$(TARGET) $(SOURCES)

run: build
	$(WASMTIME) --dir=. --dir=/tmp $(TARGET) test.txt /tmp/somewhere.txt

clean:
	$(RM) *.o *.wasm

.DELETE_ON_ERROR: # GNU Make directive (delete output files on error)
