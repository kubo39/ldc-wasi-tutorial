WASI_SDK_PATH = $(PWD)/wasi-sdk-10.0
WASI_SYSROOT = $(WASI_SDK_PATH)/share/wasi-sysroot

LDC = $(PWD)/build-ldc/bin/ldc2
LD = $(WASI_SDK_PATH)/bin/wasm-ld

DFLAGS = --mtriple=wasm32-unknown-wasi -betterC --fvisibility=hidden
LFLAGS = -L$(WASI_SYSROOT)/lib/wasm32-wasi/crt1.o -L$(WASI_SYSROOT)/lib/wasm32-wasi/libc.a \
    -L--stack-first -L--gc-sections

SOURCES = demo.d
TARGET = demo.wasm

WASMTIME = wasmtime

.PHONY: all clean

all: build

build:
	$(LDC) $(DFLAGS) $(LFLAGS) --linker=$(LD) -of=$(TARGET) $(SOURCES)

run: build
	$(WASMTIME) --dir=. --dir=/tmp $(TARGET) test.txt /tmp/somewhere.txt

clean:
	$(RM) *.o *.wasm

.DELETE_ON_ERROR: # GNU Make directive (delete output files on error)
