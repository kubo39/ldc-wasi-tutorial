import core.stdc.stdio;

extern(C):

void __prepare_for_exit() {}
void __wasi_proc_exit(int i) {}

pragma(mangle, "__original_main")
extern(C) int main()
{
    printf("Hello, WASI!\n");
    return 0;
}
