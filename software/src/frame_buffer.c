#define BASE_ADDR 0x80000000
#define STATUS_ADDR 0x90000000

#define RED 0x00000001
#define GREEN 0x00000002
#define BLUE  0x00000004
#define WHITE 0x00000007
#define BLACK 0x00000000

#define H_RES 640
#define V_RES 480
#define FB_SIZE 307200 // 640*480

int main(void)
{
  //setting pointer frame buffers location in memory.
  unsigned int *fb = (void *)BASE_ADDR;
  unsigned int offset;

  offset = 0;
  for( int i=0; i<480; i++ ) {
      for( int j=0; j<640; j++) {
        offset = offset + 1;
        fb = (void *)(BASE_ADDR + offset*4);
        *fb = RED | BLUE;
        //*fb = (i & 0x00000004) >> 2; // Stripes
      }
  }


  // Turn on Status LED
  unsigned int *led;
  led = (void *)STATUS_ADDR;
  *led = 0x00000001;


  while(1) {}

}

