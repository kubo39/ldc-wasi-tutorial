extern(C):
nothrow:
@nogc:

enum RUSAGE_SELF = 1;

int puts(const(char)*) @trusted;

int printf(const(char)* format, ...) @trusted;

void* malloc(size_t) @trusted;

alias time_t = long;
alias suseconds_t = long;

struct timeval
{
    time_t tv_sec;
    suseconds_t tv_usec;
}

struct rusage
{
    timeval ru_utime;
    timeval ru_stime;
}

// needs libwasi-emulated-process-clocks.a
int getrusage(int, rusage*) @trusted;

alias __wasi_clockid_t = uint;
enum CLOCK_REALTIME = 0;
enum CLOCK_MONOTONIC = 1;
alias __wasi_timestamp_t = ulong;
alias __wasi_errno_t = ushort;

__wasi_errno_t __wasi_clock_time_get(__wasi_clockid_t, __wasi_timestamp_t, __wasi_timestamp_t*) @trusted;

__wasi_timestamp_t __clock()
{
    __wasi_timestamp_t ret;
    __wasi_errno_t err = __wasi_clock_time_get(CLOCK_MONOTONIC, 0, &ret);
    if (err != 0)
        printf("errno: clock = %d\n", err);
    return ret;
}

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

    printf("__clock: %ld\n", __clock());

    rusage r_usage;
    int err = getrusage(RUSAGE_SELF, &r_usage);
    if (err != 0)
        printf("errno: getrusage: %d\n", err);
    printf("rusage(user): %4ld.%03ld\n", r_usage.ru_utime.tv_sec, r_usage.ru_utime.tv_usec / 1000);

    printf("tls_var: %d\n", tls_var);
    auto p = malloc(0);
    printf("malloc(3) returns %p\n", p);

    rusage r_usage2;
    err = getrusage(RUSAGE_SELF, &r_usage2);
    if (err != 0)
        printf("errno: getrusage: %d\n", err);
    printf("rusage(user): %4ld.%03ld\n", r_usage2.ru_utime.tv_sec, r_usage2.ru_utime.tv_usec / 1000);

    printf("__clock: %ld\n", __clock());

    return 0;
}
