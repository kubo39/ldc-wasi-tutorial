import core.stdc.errno;
import core.stdc.stdio;
import core.stdc.stdlib;
import core.stdc.string;
import core.sys.posix.config;
import core.sys.posix.fcntl;
import core.sys.posix.sys.types;
import core.sys.posix.unistd;

extern(C):

enum O_RDONLY = 0x4_000_000;
enum O_WRONLY = 0x10_000_000;
enum O_CREAT = 1 << 12;
enum BUFSIZE = 1024;

alias ssize_t = c_long;

int open(const scope char*, int, ...);
ssize_t read(int, void*, size_t);
ssize_t write(int, const scope void*, size_t);

int main(int argc, char **argv)
{
    ssize_t n, m;
    char[BUFSIZE] buf;
    if (argc != 3)
    {
        fprintf(stderr, "usage: %s <from> <to>\n", argv[0]);
        exit(1);
    }
    int in_ = open(argv[1], O_RDONLY);
    if (in_ < 0)
    {
        fprintf(stderr, "error opening input %s: %s\n", argv[1], strerror(errno));
        exit(1);
    }

    int out_ = open(argv[2], O_WRONLY | O_CREAT, 432 /* 0660 */);
    if (out_ < 0)
    {
        fprintf(stderr, "error opening output %s: %s\n", argv[2], strerror(errno));
        exit(1);
    }

    while ((n = read(in_, cast(void*)buf, BUFSIZE)) > 0)
    {
        char* ptr = buf.ptr;
        while (n > 0)
        {
            m = write(out_, ptr, cast(size_t)n);
            if (m < 0)
            {
                fprintf(stderr, "write error: %s\n", strerror(errno));
                exit(1);
            }
            n -= m;
            ptr += m;
        }
    }

    if (n < 0)
    {
        fprintf(stderr, "read error: %s\n", strerror(errno));
        exit(1);
    }

    return EXIT_SUCCESS;
}
