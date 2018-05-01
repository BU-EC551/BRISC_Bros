#define STATUS_ADDR 0x90000000
#define RX_ADDR 0x90000010
#define TX_ADDR 0x90000020
#define RX_READY_ADDR 0x90000014
#define TX_READY_ADDR 0x90000024

int main(void)
{

  unsigned int *led = (void*) STATUS_ADDR;
  unsigned int *tx = (void*) TX_ADDR;
  unsigned int *tx_ready = (void*) TX_READY_ADDR;

  for(int i=0; i<10; i++) {
    if(*tx_ready) {
      *tx = i + 0x30; // convert to ascii number
    }
  }

  *led= 0x00000001;
  while(1) {}
}
