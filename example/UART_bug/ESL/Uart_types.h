#ifndef UART_TYPES_H_
#define UART_TYPES_H_

const unsigned int ADDR_TASKS_START_RX   =  0x000;
const unsigned int ADDR_TASKS_STOP_RX    =  0x004;
const unsigned int ADDR_TASKS_START_TX   =  0x008;
const unsigned int ADDR_TASKS_STOP_TX    =  0x00C;
const unsigned int ADDR_TASKS_SUSPEND    =  0x01C;

const unsigned int ADDR_EVENTS_CTS        = 0x100;
const unsigned int ADDR_EVENTS_NCTS       = 0x104;
const unsigned int ADDR_EVENTS_RXD_READY  = 0x108;
const unsigned int ADDR_EVENTS_TXD_READY  = 0x11C;
const unsigned int ADDR_EVENTS_ERROR      = 0x124;
const unsigned int ADDR_EVENTS_RX_TIMEOUT = 0x144;

const unsigned int ADDR_ERROR_SRC         = 0x480;
const unsigned int ERROR_OVERRUN_MASK     = 1;
const unsigned int ERROR_PARITY_MASK      = 0b10;
const unsigned int ERROR_FRAMING_MASK     = 0b100;
const unsigned int ERROR_BREAK_MASK       = 0b1000;
const unsigned int ERROR_SRC_MASK         = 0xF;

const unsigned int ADDR_ENABLE            = 0x500;

const unsigned int ADDR_CONFIG            = 0x56C;
const unsigned int CONFIG_STOP_MASK       = 0x10;
const unsigned int CONFIG_PARITY_MASK     = 0xE;
const unsigned int CONFIG_HWFC_MASK       = 0x1;
const unsigned int CONFIG_ODD_PARITY_MASK = 0x100;
const unsigned int CONFIG_BIT_MASK        = 0x1F;


#define START_BIT               false
#define STOP_BIT                true
#define IDLE_BIT                true
#define UART_DATA_LENGTH        8
#define DATA_MASK               0xFF
#define DATA_ONE_STOP_BIT_MASK  0x3FF
#define DATA_TWO_STOP_BITS_MASK 0x7FF
#define CTS_ACTIVATED           false
#define RTS_ACTIVATED           false
#define CTS_DEACTIVATED         true
#define RTS_DEACTIVATED         true

#define UART_ENABLE             1
#define UART_DISABLE            0

#define UART_TIMEOUT            39

#define EVENT                   1
#define NO_EVENT                0

#define bits(x)     ((x & 1) + ((x >> 1) & 1) + ((x >> 2) & 1) + ((x >> 3) & 1) + ((x >> 4) & 1) + ((x >> 5) & 1) + ((x >> 6) & 1) + ((x >> 7) & 1))
#define bits_xor(x) ((x & 1) ^ ((x >> 1) & 1) ^ ((x >> 2) & 1) ^ ((x >> 3) & 1) ^ ((x >> 4) & 1) ^ ((x >> 5) & 1) ^ ((x >> 6) & 1) ^ ((x >> 7) & 1))

#ifdef SIM
enum debug_component_t {RX, TX, CONTROL, STIMULI};
void debug_print(debug_component_t comp, const std::string& msg)
{
    switch (comp)
    {
        case RX: std::cout << "Module RX: "; break;
        case TX: std::cout << "Module TX: "; break;
        case CONTROL: std::cout << "Module CONTROL: "; break;
        case STIMULI: std::cout << "Stimuli: "; break;
    }
    std::cout << "........ " << msg << std::endl;
}
#endif


enum trans_t {READ, WRITE};

struct bus_req_t
{
    trans_t trans_type;
    unsigned int data;
    unsigned int addr;
};

struct bus_resp_t
{
    unsigned int data;
    bool         valid;
};

struct tx_control_t
{
    bool active;
    bool cts;
};

struct config_t
{
    bool parity;
    bool odd_parity;
    bool two_stop_bits;
};

struct tx_events_t
{
    bool done;
};

struct rx_events_t
{
    bool ready;
    bool timeout;
    unsigned int error_src;
};

struct tasks_t
{
    bool start_rx;
    bool stop_rx;
    bool start_tx;
    bool stop_tx;
};

struct events_t
{
    bool cts;
    bool ncts;
    bool rxd_ready;
    bool txd_ready;
    bool error;
    bool rx_timeout;
};

struct data_t
{
    unsigned int data;
    bool valid;
};

#endif
