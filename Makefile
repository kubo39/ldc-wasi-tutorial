WASI_SDK_PATH ?= $(HOME)/wasi-sdk-20.0
WASI_SYSROOT = $(WASI_SDK_PATH)/share/wasi-sysroot
WASMTIME = $(HOME)/.wasmtime/bin/wasmtime

LDC = ldc2
LD = $(WASI_SDK_PATH)/bin/wasm-ld

DFLAGS = --mtriple=wasm32-unknown-wasi \
		-Oz \
		-betterC \
		--fvisibility=hidden

LFLAGS = -L$(WASI_SYSROOT)/lib/wasm32-wasi/crt1.o \
		-L$(WASI_SYSROOT)/lib/wasm32-wasi/libc.a \
		-L--gc-sections

SOURCES = demo.d
TARGET = demo.wasm

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(SOURCES)
	$(LDC) $(DFLAGS) --linker=$(LD) $(LFLAGS) -of=$@ $^

run: $(TARGET)
	$(WASMTIME) --dir=. --dir=/tmp $^

clean:
	$(RM) *.o *.wasm

.DELETE_ON_ERROR: # GNU Make directive (delete output files on error)
