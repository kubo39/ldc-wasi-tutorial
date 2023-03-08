extern(C):
nothrow:
@nogc:

int puts(const(char)*) @trusted;
int printf(const(char)* format, ...) @trusted;
void* malloc(size_t) @trusted;

pragma(crt_constructor)
void constructor()
{
    puts(".init_array");
}

int tls_var = 42;

// https://github.com/WebAssembly/wasi-libc/commit/d9066a87c04748e7381695eaf01cc5c9a9c3003b
int __main_argc_argv(int argc, char** argv)
{
    puts("main");
    printf("tls_var: %d\n", tls_var);
    auto p = malloc(0);
    printf("malloc(3) returns %p\n", p);
    return 0;
}
