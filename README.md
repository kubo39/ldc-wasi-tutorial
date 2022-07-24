# Run D in wasmtime

## Prerequirements

- LDC
- GNU Make

## Howto

1. Get wasi-sdk.

```console
$ wget https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-16/wasi-sdk-16.0-linux.tar.gz
$ tar xvf wasi-sdk-16.0-linux.tar.gz
```

2. Compile with wasi-sdk and RUN.

```console
$ make run
```
