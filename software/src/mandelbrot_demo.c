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

#define DELTA 0x00000013 //  20 integer points, 12 binary points 0.004688
#define FOUR 0x00004000
#define X_START 0xFFFFE04F // -1.9807...
#define Y_START 0x000011D0 // 1.125

struct complex_num {
    int re;
    int im;
};
typedef struct complex_num Complex_Num;

void mandelbrot();
void complex_add(Complex_Num *a, Complex_Num *b, Complex_Num *s);
void complex_mult(Complex_Num *a, Complex_Num *b, Complex_Num *s);
void complex_square(Complex_Num *a, Complex_Num*sq);
void mandelbrot_iter(Complex_Num *Z, Complex_Num *C);
int complex_magnitude(Complex_Num *a);
int complex_magnitude(Complex_Num *a);
unsigned int multu(unsigned int a, unsigned int b);
int mult(int a, int b);

int main(void)
{
  //setting pointer frame buffers location in memory.
  unsigned int *fb = (void *)BASE_ADDR;
  unsigned int offset;

  // Set frame to green
  offset = 0;
  for( int i=0; i<480; i++ ) {
      for( int j=0; j<640; j++) {
        offset = offset + 1;
        fb = (void *)(BASE_ADDR + offset*4);
        //*fb = GREEN;
        *fb = RED | BLUE;
      }
  }

  // Wait for CPU0 to set interupt
  while(1){}

  return 0;
}

void mandelbrot() {
  //setting pointer frame buffers location in memory.
  unsigned int *fb = (void *)BASE_ADDR;
  unsigned int offset;


  // Mandelbrot variables
  int max_iter;
  unsigned int color;

  Complex_Num Zn;
  Complex_Num C;

  // Compute Mandelbrot Set
  max_iter = 10;
  offset = 0;

  C.im = Y_START;
  for( int i=0; i<480; i++ ) {

    C.re = X_START;
    for( int j=0; j<640; j++) {
      fb = (void *)(BASE_ADDR + offset*4);
      offset = offset + 1;
      color = BLACK;
      Zn.re = 0;
      Zn.im = 0;

      for(int k=0; k<max_iter; k++) {
        mandelbrot_iter(&Zn, &C);
        if( complex_magnitude(&Zn) > FOUR) {
          color = WHITE;
          break;
        }
      }

      C.re += DELTA;
      *fb = color;
    }
    C.im -= DELTA;
  }

  // Turn on Status LED
  unsigned int *led;
  led = (void *)STATUS_ADDR;
  *led = 0x00000001;

  // Wait for CPU0 to reset processor
  while(1){}

}

void complex_add(Complex_Num *a, Complex_Num *b, Complex_Num *s) {
  s->re = a->re + b->re;
  s->im = a->im + b->im;

}

void complex_mult(Complex_Num *a, Complex_Num *b, Complex_Num *p) {
  int reProduct32, imProduct32;

  reProduct32 = mult(a->re, b->re) - mult(a->im, b->im);
  imProduct32 = mult(a->re, b->im) + mult(a->im, a->re);
  p->re = reProduct32 >> 12;
  p->im = imProduct32 >> 12;
}


void complex_square(Complex_Num *a, Complex_Num *sq) {
  complex_mult(a, a, sq);
}

// Zn1 = Zn^2 + C
void mandelbrot_iter(Complex_Num *Z, Complex_Num *C) {
    complex_square(Z, Z);
    complex_add(Z, C, Z);

}

int complex_magnitude(Complex_Num *a) {
  int mag32 = mult(a->re, a->re) + mult(a->im, a->im);
  return mag32 >> 12;
}

unsigned int multu(unsigned int a, unsigned int b) {
  unsigned int product;
  product = 0;

  for(int i=0; i<32; i++) {
    if(0x00000001 & (a>>i) ) {
      product = product + (b << i);
    }
  }
  return product;
}

int mult(int a, int b) {
  int product;
  int sign_a, sign_b;
  sign_a = a >> 31;
  sign_b = b >> 31;

  if(sign_a) a = (~a) + 1; // Flip sign
  if(sign_b) b = (~b) + 1; // Flip sign

  product = (signed int)multu( (unsigned int)a, (unsigned int)b );

  if( sign_a^sign_b ) product = (~product) + 1; // Flip sign;

  return product;

}




