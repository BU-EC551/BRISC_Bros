#define STATUS_ADDR 0x90000000

int main(void)
{

  unsigned int *fb = (void*) STATUS_ADDR;

mm_write:
  *fb = 0x00000001;

  while(1) {}
}
