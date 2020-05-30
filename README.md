# Run D in wasmtime

1. clone repo `skoppe/ldc:wasm`.

```console
$ git submodule add -b wasm https://github.com/skoppe/ldc
$ cd ldc
$ git submodule init
$ git submodule update --recursive
$ cd ..
$ mkdir build-ldc && cd build-ldc
$ cmake -G Ninja ../ldc \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$PWD/../install-ldc
$ ninja -j$(nproc)
```

2. download wasi-sdk.

```console
$ wget https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-10/wasi-sdk-10.0-linux.tar.gz
```

3. create a patch for druntime.

```diff
diff --git a/src/core/internal/entrypoint.d b/src/core/internal/entrypoint.d
index eb00b156..be3b204c 100644
--- a/src/core/internal/entrypoint.d
+++ b/src/core/internal/entrypoint.d
@@ -45,7 +45,8 @@ template _d_cmain()
                 return main(argc, argv);
             }
         }
-        version (WebAssembly)
+        version (WASI) {}
+        else version (WebAssembly)
           {
             pragma(msg, "emit _start");
             import ldc.attributes;
```

4. Compile with wasi-sdk and Run!

```console
$ ./build-ldc/bin/ldc2 -mtriple=wasm32-unknown-wasi -betterC -L./wasi-sdk-10.0/share/wasi-sysroot/lib/wasm32-wasi/crt1.o -L./wasi-sdk-10.0/share/wasi-sysroot/lib/wasm32-wasi/libc.a --linker=./wasi-sdk-10.0/bin/wasm-ld main.d
$ wasmtime main.wasm
Hello, WASI!
```
