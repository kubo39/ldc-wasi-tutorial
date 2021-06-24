extern(C):
nothrow:
@nogc:

int puts(const(char)*) @trusted;
int printf(const(char)* format, ...) @trusted;

pragma(crt_constructor)
void constructor()
{
  puts(".init_array");
}

int tls_var = 42;

int main()
{
  puts("main");
  printf("tls_var: %d\n", tls_var);
  return 0;
}
