extern(C):
nothrow:
@nogc:

int puts(const(char)*) @trusted;

int main()
{
  puts("hello");
  return 0;
}
