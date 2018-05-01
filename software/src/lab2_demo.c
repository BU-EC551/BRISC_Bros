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
void calculator();
void print_hello();
void print_mode();
void fibonacci();
void interrupt();
void loopback();

int main(void) {

  unsigned int mode;
  unsigned int enter;

  print_hello();

  while(1) {

    print_mode();
    mode = rx_byte();
    tx_byte(mode);
    // wait for enter
    enter = 0;
    while(enter != 0x0000000D) {
      enter = rx_byte();
    }
    tx_byte(0x0000000A); // New Line
    tx_byte(0x0000000D); // Carriage Return

    switch(mode) {
      case 0x00000041: // A
        calculator();
        break;
      case 0x00000049: // I
        interrupt();
        break;
      case 0x00000042: // B
        fibonacci();
        break;
      default:
        tx_byte(0x00000045); // E
        tx_byte(0x00000072); // r
        tx_byte(0x00000072); // r
        tx_byte(0x0000006F); // o
        tx_byte(0x00000072); // r
        tx_byte(0x0000000A); // New Line
        tx_byte(0x0000000D); // Carriage Return
    } // end switch
  } // while 1

}

void print_hello() {
  tx_byte(0x0000000A); // New Line
  tx_byte(0x0000000D); // Carriage Return
  tx_byte(0x00000048); // H
  tx_byte(0x00000065); // e
  tx_byte(0x0000006C); // l
  tx_byte(0x0000006C); // l
  tx_byte(0x0000006F); // o
  tx_byte(0x0000002C); // ,
  tx_byte(0x00000020); // space
  tx_byte(0x0000006D); // m
  tx_byte(0x00000079); // y
  tx_byte(0x00000020); // space
  tx_byte(0x0000006E); // n 
  tx_byte(0x00000061); // a
  tx_byte(0x0000006D); // m
  tx_byte(0x00000065); // e
  tx_byte(0x00000020); // space
  tx_byte(0x00000069); // i
  tx_byte(0x00000073); // s
  tx_byte(0x00000020); // space
  tx_byte(0x00000042); // B 
  tx_byte(0x00000052); // R
  tx_byte(0x00000049); // I
  tx_byte(0x00000053); // S
  tx_byte(0x00000043); // C
  tx_byte(0x0000002D); // -
  tx_byte(0x00000056); // V
}

void print_mode() {
  tx_byte(0x0000000A); // New Line
  tx_byte(0x0000000D); // Carriage Return
  tx_byte(0x00000045); // E
  tx_byte(0x0000006E); // n
  tx_byte(0x00000074); // t
  tx_byte(0x00000065); // e
  tx_byte(0x00000072); // r
  tx_byte(0x00000020); // space
  tx_byte(0x0000006D); // m
  tx_byte(0x0000006F); // o
  tx_byte(0x00000064); // d
  tx_byte(0x00000065); // e
  tx_byte(0x00000020); // space
  tx_byte(0x0000005B); // [
  tx_byte(0x00000041); // A
  tx_byte(0x0000002C); // ,
  tx_byte(0x00000049); // I
  tx_byte(0x0000002C); // ,
  tx_byte(0x00000042); // B
  tx_byte(0x0000005D); // ]
  tx_byte(0x0000003A); // :
  tx_byte(0x00000020); // space

}

void fibonacci() {

  unsigned int enter;
  unsigned int sequence_len;
  unsigned int n2;
  unsigned int n1;
  unsigned int n;

  tx_byte(0x00000053); // S
  tx_byte(0x00000065); // e
  tx_byte(0x00000071); // q
  tx_byte(0x00000075); // u
  tx_byte(0x00000065); // e
  tx_byte(0x0000006E); // n
  tx_byte(0x00000063); // c
  tx_byte(0x00000065); // e
  tx_byte(0x00000020); // space
  tx_byte(0x0000004C); // L
  tx_byte(0x00000065); // e
  tx_byte(0x0000006E); // n
  tx_byte(0x0000003A); // :
  tx_byte(0x00000020); // space

  sequence_len = rx_byte();
  tx_byte(sequence_len);
  sequence_len = sequence_len - 0x00000030;

  // wait for enter
  enter = 0;
  while(enter != 0x0000000D) {
    enter = rx_byte();
  }
  tx_byte(0x0000000A); // New Line
  tx_byte(0x0000000D); // Carriage Return

  n1 = 1;
  n2 = 0;

  for( int i = 0; i<sequence_len; i++) {
    n = n1 + n2;
    n2 = n1;
    n1 = n;
    tx_uint(n);
  }

}


void calculator()
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
    case 0x00000023: // #
      c = a & b;
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

void interrupt() {
  unsigned int *int_pc = (void*) INT_PC_ADDR;
  unsigned int *int_trigger = (void*) INT_TRIGGER_ADDR;

  unsigned int new_pc;
  unsigned int input;
  unsigned int enter;
  int shift;
  tx_byte(0x0000004E); // N
  tx_byte(0x00000065); // e
  tx_byte(0x00000077); // w
  tx_byte(0x00000020); // space
  tx_byte(0x00000050); // P
  tx_byte(0x00000043); // C
  tx_byte(0x0000003A); // :
  tx_byte(0x00000020); // space

  new_pc = 0;
  shift = 32;

  while(shift > 0)  {
    input = rx_byte();

    switch(input) {
      case 0x00000030: // 0
      case 0x00000031: // 1
      case 0x00000032: // 2
      case 0x00000033: // 3
      case 0x00000034: // 4
      case 0x00000035: // 5
      case 0x00000036: // 6
      case 0x00000037: // 7
      case 0x00000038: // 8
      case 0x00000039: // 9
        shift = shift - 4;
        tx_byte(input);
        input = input - 0x00000030;
        new_pc = new_pc | (input << shift);
        break;
      case 0x00000041: // A
      case 0x00000042: // B
      case 0x00000043: // C
      case 0x00000044: // D
      case 0x00000045: // E
      case 0x00000046: // F
        shift = shift - 4;
        tx_byte(input);
        input = input - 55;
        new_pc = new_pc | (input << shift);
        break;
      default:
        break;
    } // switch
  } // while shift

  // wait for enter
  enter = 0;
  while(enter != 0x0000000D) {
    enter = rx_byte();
  }

  *int_pc = new_pc;
  *int_trigger = 0x00000001;

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

void loopback() {
  unsigned int *tx = (void*) TX_ADDR;
  unsigned int *rx = (void*) RX_ADDR;
  unsigned int *tx_ready = (void*) TX_READY_ADDR;
  unsigned int *rx_ready = (void*) RX_READY_ADDR;
  unsigned int *int_pc = (void*) INT_PC_ADDR;
  unsigned int *int_trigger = (void*) INT_TRIGGER_ADDR;

  // A byte recieved from the serial port
  unsigned int data;

  tx_byte(0x0000000A); // New Line
  tx_byte(0x0000000D); // Carriage Return

  while(1) {
    // wait to recieve data
    while( !*rx_ready) {}
    // Read Byte from serial port
    data = *rx;
    if(data == 0x0000001B){ // if escape pressed
      tx_byte(0x0000000A); // New Line
      tx_byte(0x0000000D); // Carriage Return
      tx_uint(0x00000D18); // PC of this function call
      // reset processor
      *int_pc = 0x00000000;
      *int_trigger = 0x00000001;
    }
    // wait for transmitter to be ready
    while(!*tx_ready) {}
    // Write Byte to serial port
    *tx = data;
  }
}

