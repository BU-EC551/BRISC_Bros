#define STATUS_ADDR 0x90000000
#define RX_ADDR 0x90000010
#define TX_ADDR 0x90000020
#define RX_READY_ADDR 0x90000014
#define TX_READY_ADDR 0x90000024

int main(void)
{

  unsigned int *tx = (void*) TX_ADDR;
  unsigned int *rx = (void*) RX_ADDR;
  unsigned int *tx_ready = (void*) TX_READY_ADDR;
  unsigned int *rx_ready = (void*) RX_READY_ADDR;

  // A byte recieved from the serial port
  unsigned int data;

  while(1) {
    // wait to recieve data
    while( !*rx_ready) {}
    // Read Byte from serial port
    data = *rx;
    // wait for transmitter to be ready
    while(!*tx_ready) {}
    // Write Byte to serial port
    *tx = data;
  }

}
