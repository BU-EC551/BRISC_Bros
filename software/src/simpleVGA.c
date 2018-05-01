#define MAX 0x000000FF
#define MIN 0x00000000
#define STATUS_ADDR 0x90000000

int main(void)
{

  unsigned int *red= (void *)0x80000000; //setting pointer to exact location in memory.
  unsigned int *green= (void *)0x80000001; //setting pointer to exact location in memory.
  unsigned int *blue= (void *)0x80000002; //setting pointer to exact location in memory.

  *red=MAX;
  *green=MAX;
  *blue=MAX;
  unsigned int *fb = (void*) STATUS_ADDR;
  *fb = 0x00000001;

  while(1) {}

}
