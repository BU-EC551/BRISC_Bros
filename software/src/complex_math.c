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
struct complex_num {
    int re;
    int im;
};
typedef struct complex_num Complex_Num;

void complex_add(Complex_Num *a, Complex_Num *b, Complex_Num *s);
void complex_mult(Complex_Num *a, Complex_Num *b, Complex_Num *s);
void complex_square(Complex_Num *a, Complex_Num*sq);
int complex_magnitude(Complex_Num *a);
int complex_magnitude(Complex_Num *a);
unsigned int multu(unsigned int a, unsigned int b);
int mult(int a, int b);

int main(void)
{

  Complex_Num A;
  Complex_Num B;
  Complex_Num C;


  A.re = 0x 

  return 0;

fail:
  // Turn on Status LED
  unsigned int *led;
  led = (void *)STATUS_ADDR;
  *led = 0x00000001;
  return -1;

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




