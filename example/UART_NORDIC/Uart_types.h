#ifndef UART_TYPES_H_
#define UART_TYPES_H_

#define ADDR_TASKS_START_RX     0x000
#define ADDR_TASKS_STOP_RX      0x004
#define ADDR_TASKS_START_TX     0x008
#define ADDR_TASKS_STOP_TX      0x00C
#define ADDR_TASKS_SUSPEND      0x01C

#define ADDR_EVENTS_CTS         0x100
#define ADDR_EVENTS_NCTS        0x104
#define ADDR_EVENTS_RXD_READY   0x108
#define ADDR_EVENTS_TXD_READY   0x11C
#define ADDR_EVENTS_ERROR       0x124
#define ADDR_EVENTS_RX_TIMEOUT  0x144

#define ADDR_ERROR_SRC          0x480
#define ERROR_OVERRUN_MASK      0b1
#define ERROR_OVERRUN_MASK_INV  ~ERROR_OVERRUN_MASK
#define ERROR_PARITY_MASK       0b10
#define ERROR_PARITY_MASK_INV   ~ERROR_PARITY_MASK
#define ERROR_FRAMING_MASK      0b100
#define ERROR_FRAMING_MASK_INV  ~ERROR_FRAMING_MASK
#define ERROR_BREAK_MASK        0b1000
#define ERROR_BREAK_MASK_INV    ~ERROR_BREAK_MASK
#define ERROR_SRC_MASK          0xF

#define ADDR_ENABLE             0x500

#define ADDR_CONFIG             0x56C
#define CONFIG_STOP_MASK        0x00000001
#define CONFIG_STOP_BIT_OFFSET  0
#define CONFIG_PARITY_MASK      0x0000000E
#define CONFIG_PARITY_BIT_OFFSET 1
#define CONFIG_HFW_MASK         0x00000010
#define CONFIG_HFW_BIT_OFFSET   4
#define CONFIG_BIT_MASK         0x1F


#define START_BIT               false
#define STOP_BIT                true
#define IDLE_BIT                true
#define UART_DATA_LENGTH        8
#define DATA_MASK               0xFF
#define CTS_ACTIVATED           false
#define RTS_ACTIVATED           false
#define CTS_DEACTIVATED         true
#define RTS_DEACTIVATED         true

#define UART_ENABLE             1
#define UART_DISABLE            0

#define UART_TIMEOUT            44

#define EVENT                   1
#define NO_EVENT                0

#define bits(x) ((x & 1) + ((x >> 1) & 1) + ((x >> 2) & 1) + ((x >> 3) & 1) + ((x >> 4) & 1) + ((x >> 5) & 1)+ ((x >> 6) & 1) + ((x >> 7) & 1))
#define bits_xor(x) ((x & 1) ^ ((x >> 1) & 1) ^ ((x >> 2) & 1) ^ ((x >> 3) & 1) ^ ((x >> 4) & 1) ^ ((x >> 5) & 1) ^ ((x >> 6) & 1) ^ ((x >> 7) & 1))

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
};

struct tx_control_out_t
{
    //bool start;
    //bool stop;
    //bool suspend;
    bool active;
    //bool parity;
    //bool two_stop_bits;
};

struct config_t
{
    bool parity;
    bool oddParity;
    bool two_stop_bits;
};

struct tx_control_in_t
{
    bool ready;
};

struct rx_control_out_t
{
    //bool start;
    //bool stop;
    //bool suspend;
    bool active;
    //bool parity;
    //bool two_stop_bits;
};

struct rx_control_in_t
{
    bool ready;
    bool timeout;
    bool error_overrun;
    bool error_parity;
    bool error_framing;
    bool error_break;
};

struct tasks_t
{
    bool start_rx;
    bool stop_rx;
    bool start_tx;
    bool stop_tx;
    bool suspend;
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

#endif