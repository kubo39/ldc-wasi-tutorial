# Run D in wasmtime

## Prerequirements

- D Compiler
- ninja

## Howto

1. Clone repo `skoppe/ldc:wasm`.

```console
$ git submodule add -b wasm https://github.com/skoppe/ldc
$ cd ldc
% git rev-parse HEAD
828926064c52eba905d9bbbf9d4d57f64a2cd267
$ git submodule init
$ git submodule update --recursive
$ cd ..
```

2. Build LDC.

```console
$ mkdir build-ldc && cd build-ldc
$ cmake -G Ninja ../ldc \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$PWD/../install-ldc
$ ninja -j$(nproc)
$ cd ..
```

3. Get wasi-sdk.

```console
$ wget https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-10/wasi-sdk-10.0-linux.tar.gz
$ tar xvf wasi-sdk-10.0-linux.tar.gz
```

4. Compile with wasi-sdk and RUN!

```console
$ ./build-ldc/bin/ldc2 --mtriple=wasm32-unknown-wasi -betterC --fvisibility=hidden -L./wasi-sdk-10.0/share/wasi-sysroot/lib/wasm32-wasi/crt1.o -L./wasi-sdk-10.0/share/wasi-sysroot/lib/wasm32-wasi/libc.a --linker=./wasi-sdk-10.0/bin/wasm-ld -of=demo.wasm demo.d
% wasmtime --dir=. --dir=/tmp demo.wasm test.txt /tmp/somewhere.txt
$ cat /tmp/somewhere.txt
hello world
```
