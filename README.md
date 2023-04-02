# Run D in wasmtime

## Prerequirements

- LDC
- GNU Make
- wasmtime

## Howto

1. Get wasi-sdk.

```console
$ wget https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-16/wasi-sdk-19.0-linux.tar.gz
$ tar xvf wasi-sdk-19.0-linux.tar.gz
```

2. Compile with wasi-sdk and RUN.

```console
$ make run
```
