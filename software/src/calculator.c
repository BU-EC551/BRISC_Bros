#define STATUS_ADDR 0x90000000
#define RX_ADDR 0x90000010
#define TX_ADDR 0x90000020
#define RX_READY_ADDR 0x90000014
#define TX_READY_ADDR 0x90000024
#define INT_PC_ADDR 0x90000030
#define INT_TRIGGER_ADDR 0x90000034

unsigned int rx_byte();
void tx_byte(int data);
void tx_uint(unsigned int n);
unsigned int mod10(unsigned int n);
unsigned int div10(unsigned int n);
unsigned int multu(unsigned int a, unsigned int b);
int mult(int a, int b);

int main(void)
{
  unsigned int a, b, op, c, enter, error;
  tx_byte(0x0000004F); // O
  tx_byte(0x00000070); // p
  tx_byte(0x00000073); // s
  tx_byte(0x0000003A); // :
  tx_byte(0x00000020); // space
  tx_byte(0x0000005B); // [
  tx_byte(0x0000002B); // +
  tx_byte(0x0000002C); // ,
  tx_byte(0x0000002D); // -
  tx_byte(0x0000002C); // ,
  tx_byte(0x0000005E); // ^
  tx_byte(0x0000002C); // ,
  tx_byte(0x00000026); // &
  tx_byte(0x0000005D); // ]
  tx_byte(0x0000000A); // New Line
  tx_byte(0x0000000D); // Carriage Return

  while(1) {
    error = 0;
    enter = 0;
    // Get Input
    a = rx_byte();
    tx_byte(a);
    op = rx_byte();
    tx_byte(op);
    b = rx_byte();
    tx_byte(b);
    // wait for enter
    while(enter != 0x0000000D) {
      enter = rx_byte();
    }
    tx_byte(0x0000000A); // New Line
    tx_byte(0x0000000D); // Carriage Return

    // convert from ascii to int
    a = a - 0x00000030;
    b = b - 0x00000030;

    switch(op) {
      case 0x0000002B: // +
        c = a + b;
        break;
      case 0x0000002D: // -
        c = a - b;
        break;
      case 0x0000005E: // ^
        c = a ^ b;
        break;
      case 0x00000026: // &
        c = a & b;
        break;
      case 0x0000002A: // *
        c = multu(a, b);
        break;
      default:
        tx_byte(0x00000045); // E
        tx_byte(0x00000072); // r
        tx_byte(0x00000072); // r
        tx_byte(0x0000006F); // o
        tx_byte(0x00000072); // r
        error = 1;
    }
    if(!error) tx_uint(c);
    tx_byte(0x0000000A); // New Line
    tx_byte(0x0000000D); // Carriage Return
  }

}


unsigned int rx_byte() {
  unsigned int *rx = (void*) RX_ADDR;
  unsigned int *rx_ready = (void*) RX_READY_ADDR;
  // wait for transmitter to be ready
  while(!*rx_ready) {}
  // read byte from serial port
  return *rx;
}

void tx_byte(int data) {
  unsigned int *tx = (void*) TX_ADDR;
  unsigned int *tx_ready = (void*) TX_READY_ADDR;

  // wait for transmitter to be ready
  while(!*tx_ready) {}
  // Write Byte to serial port
  *tx = data;
}

void tx_uint(unsigned int input) {
  unsigned int r, n, max;
  max = 9;
  while(input > max) {
    n = input;
    while(n>max) {
      n = div10(n);
    }
    r = mod10(n);
    tx_byte(r + 0x00000030); // convert to ascii and print
    max = max * 11;
  }
  r = mod10(input);
  tx_byte(r + 0x00000030); // convert to ascii and print
  tx_byte(0x00000020); // print space

}

unsigned int mod10(unsigned int n) {
  while(n>9) {
      n = n-10;
  }
  return n;
}

unsigned int div10(unsigned int n) {
  unsigned int quotient;
  unsigned int i;
  n = n - mod10(n);
  i = 0;
  quotient = 0;
  while(quotient < n) {
    i = i + 1;
    quotient = quotient + 10;
  }
  return i;

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

  if( sign_a^sign_b ) product = (~product) + 1; // Flip sign

  return product;
}


