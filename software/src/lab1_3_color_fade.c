#define MAX 0x000000FF
#define MIN 0x00000000

int main(void)
{

  unsigned int *red = (void *)0x80000000; //setting pointer to exact location in memory.
  unsigned int *green = (void *)0x80000001; //setting pointer to exact location in memory.
  unsigned int *blue= (void *)0x80000002; //setting pointer to exact location in memory.
  int delay;


  *red=MIN;
  *green=MIN;
  *blue=MIN;


  while(1)
  {

    while(*red < MAX)
    {
      *red = *red + 1;
      delay=0;
      for(unsigned int i=0; i<2000; i++)  { delay++; }
    }

    while(*red > MIN)
    {
      *red = *red - 1;
      delay=0;
      for(unsigned int i=0; i<2000; i++)  { delay++; }
    }


    while(*green < MAX)
    {
      *green = *green + 1;
      delay=0;
      for(unsigned int i=0; i<2000; i++)  { delay++; }
    }

    while(*green > MIN)
    {
      *green = *green - 1;
      delay=0;
      for(unsigned int i=0; i<2000; i++)  { delay++; }
    }

    while(*blue < MAX)
    {
      *blue = *blue + 1;
      delay=0;
      for(unsigned int i=0; i<2000; i++)  { delay++; }
    }

    while(*blue > MIN)
    {
      *blue = *blue - 1;
      delay=0;
      for(unsigned int i=0; i<2000; i++)  { delay++; }
    }

  }
}
