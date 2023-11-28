extern(C):
nothrow:
@nogc:

int puts(const(char)*) @trusted;

int printf(const(char)* format, ...) @trusted;

void* malloc(size_t) @trusted;

enum RUSAGE_SELF = 1;

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

alias __wasi_timestamp_t = ulong;
alias __wasi_errno_t = ushort;

__wasi_timestamp_t __clock();

alias clockid_t = int;
enum CLOCK_MONOTONIC = 1;
struct timespec {
    time_t tv_sec;
    long tv_nsec;
}

int clock_gettime(clockid_t, timespec*);

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

    timespec ts;
    int err = clock_gettime(CLOCK_MONOTONIC, &ts);
    printf("clock_gettime: %ld.%09ld\n", ts.tv_sec, ts.tv_nsec);

    rusage r_usage;
    err = getrusage(RUSAGE_SELF, &r_usage);
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
    timespec ts2;
    err = clock_gettime(CLOCK_MONOTONIC, &ts2);
    printf("clock_gettime: %ld.%09ld\n", ts2.tv_sec, ts2.tv_nsec);

    return 0;
}
