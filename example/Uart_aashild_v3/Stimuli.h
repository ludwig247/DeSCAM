#include "systemc.h"
#include "Interfaces.h"
#include "Uart_types.h"

#define TWO_STOP_BITS    1
#define ONE_STOP_BIT     0
#define PARITY_BIT       1
#define NO_PARITY_BIT    0
#define HFW              1
#define NO_HFW           0

SC_MODULE(Stimuli)
{
    master_out<bus_req_t>      bus_out;
    master_in<bus_resp_t>      bus_in;
    blocking_out<unsigned int> data_out;
    blocking_in<bool>          txd;
    blocking_in<unsigned int>  data_in;
    blocking_out<bool>         rxd;
    master_out<tasks_t>        tasks_out;
    slave_in<events_t>        events_in;
    master_out<bool>           cts_out;
    slave_in<bool>             rts_in;

    bus_req_t  bus_stimuli;
    tasks_t    task_stimuli;
    events_t   events_monitor;
    bus_resp_t response;
    bool txd_bit;

    bool parity;
    bool two_stop_bits;

    bool tx_transmitting;
    bool rx_data_ready;
    bool rx_timeout;
    bool rx_transmitting;
    unsigned int rx_transmit_data;
    unsigned int tx_transmit_data;
    unsigned int tx_transmitted_data;
    unsigned int tx_num_bits_received;
    unsigned int rx_num_bits_transmitted;

    void stimuli_generation()
    {
        task_stimuli.start_rx = NO_EVENT;
        task_stimuli.stop_rx  = NO_EVENT;
        task_stimuli.start_tx = NO_EVENT;
        task_stimuli.stop_tx  = NO_EVENT;
        task_stimuli.suspend  = NO_EVENT;
        tasks_out->master_write(task_stimuli);
        std::cout << "--- STIMULI: enabling UART" << std::endl;
        enable_uart();
        //std::cout << "Stimuli: checking UART enable" << std::endl;
        assert(check_register(ADDR_ENABLE_T, UART_ENABLE));

        configure_uart(TWO_STOP_BITS, PARITY_BIT, NO_HFW);

        std::cout << "--- STIMULI: starting TX" << std::endl;
        start_tx();
        

        std::cout << "--- STIMULI: writing stimuli" << std::endl;
        tx_stimuli();
        while (tx_transmitting) wait(SC_ZERO_TIME);

        std::cout << "--- STIMULI: suspending UART" << std::endl;
        suspend_uart();

        std::cout << "--- STIMULI: starting TX" << std::endl;
        start_tx();
        tx_stimuli();
        configure_uart(ONE_STOP_BIT, PARITY_BIT, NO_HFW);
        //std::cout << "Stimuli: waiting for TX to transmit data" << std::endl;
        while (tx_transmitting) wait(SC_ZERO_TIME);
        //std::cout << "Stimuli: tx is done transmitting" << std::endl;
        //read_tx(ONE_STOP_BIT, PARITY_BIT);
        std::cout << "Stimuli: suspending UART" << std::endl;
        suspend_uart();

        std::cout << "--- STIMULI: starting RX" << std::endl;
        start_rx();
        
        rx_write_data(0x24, ONE_STOP_BIT, PARITY_BIT);
        while (!rx_data_ready) wait(SC_ZERO_TIME);
        assert(read_rx(0x24, ONE_STOP_BIT, PARITY_BIT));
        std::cout << "--- STIMULI: stopping RX" << std::endl;
        stop_rx();
        while (!rx_timeout) wait(SC_ZERO_TIME);
        rx_timeout = false;

        std::cout << "--- STIMULI: Starting TX with task" << std::endl;
        task_stimuli.start_tx = EVENT;
        tasks_out->master_write(task_stimuli);

        tx_stimuli();
        task_stimuli.start_tx = NO_EVENT;
        while (tx_transmitting) wait(SC_ZERO_TIME);
        std::cout << "--- STIMULI: Done reading from TX" << std::endl;
        check_register(ADDR_EVENTS_TXD_READY_T, 1);

        task_stimuli.suspend = EVENT;
        tasks_out->master_write(task_stimuli);
        std::cout << "--- STIMULI: suspending with task" << std::endl;
        configure_uart(TWO_STOP_BITS, NO_PARITY_BIT, NO_HFW);
        task_stimuli.suspend = NO_EVENT;
        task_stimuli.start_tx = EVENT;
        std::cout << "--- STIMULI: starting TX with task" << std::endl;
        tasks_out->master_write(task_stimuli);
        tx_stimuli();
        task_stimuli.stop_tx = EVENT;
        task_stimuli.start_tx = NO_EVENT;
        std::cout << "--- STIMULI: STOPPING TX WITH STOP_TX TASK" << std::endl;
        tasks_out->master_write(task_stimuli);
        
        

        sc_stop();
    }

    SC_CTOR(Stimuli):
        tx_transmitting(false),
        rx_data_ready(false),
        tx_num_bits_received(0),
        tx_transmit_data(0),
        tx_transmitted_data(0),
        bus_out("stimuli_bus_out"),
        bus_in("stimuli_bus_in"),
        tasks_out("stimuli_tasks_out"),
        events_in("stimuli_events_in"),
        data_out("stimuli_data_out"),
        txd("stimuli_txd"),
        data_in("stimuli_data_in"),
        rxd("stimuli_rxd")
    {
        SC_THREAD(stimuli_generation);
        SC_THREAD(tx_read);
        SC_THREAD(rx_write);
        SC_THREAD(uart_events);
    }

    void uart_events()
    {
        while(1)
        {
            bool success;
            events_in->slave_read(events_monitor,success);
            if (success)
            {
                if (events_monitor.txd_ready)
                {
                    tx_transmitting = false;
                    std::cout << "EVENT_MONITOR: TX data is transmitted!" << std::endl;
                }
                if (events_monitor.rxd_ready)
                {
                    rx_data_ready = true;
                    std::cout << "EVENT_MONITOR: RX data is ready" << std::endl;
                }
                if (events_monitor.rx_timeout)
                {
                    rx_timeout = true;
                    std::cout << "EVENT_MONITOR: RX timeout" << std::endl;
                }
            }
            wait(SC_ZERO_TIME);
        }
    }

    void tx_read()
    {
        while(1)
        {
            bool tx_bit;
            txd->read(tx_bit);
            if (!tx_transmitting)
            {
                assert(tx_bit == STOP_BIT);
                tx_num_bits_received = 0;
            }
            else
            {
                if (!tx_num_bits_received)
                {
                    // first bit is start bit
                    assert(tx_bit == START_BIT);
                    tx_num_bits_received++;
                }
                else if (tx_num_bits_received <= UART_DATA_LENGTH)
                {
                    if (tx_bit)
                    {
                        tx_transmitted_data |= (1 << (tx_num_bits_received-1));
                    }
                    tx_num_bits_received++;
                }
                else
                {
                    // done receiving data bits
                    if (tx_num_bits_received == UART_DATA_LENGTH + 1)
                    {
                        std::cout << "TX_READ: got a data byte!" << std::endl;
                        tx_num_bits_received++;
                        if (parity)
                        {
                            assert(tx_bit == bits_xor(tx_transmit_data));
                        }
                        else
                        {
                            assert(tx_bit == STOP_BIT);
                            if (!two_stop_bits)
                            {
                                //tx_transmitting = 0;
                                tx_num_bits_received = 0;
                                std::cout << "TX_READ: Got STOP_BIT!" << std::endl;
                            }
                        } 
                    }
                    else if (tx_num_bits_received == UART_DATA_LENGTH + 2)
                    {
                        assert(tx_bit == STOP_BIT);
                        if (parity ^ two_stop_bits)
                        {
                            //tx_transmitting = false;
                            tx_num_bits_received = 0;
                            std::cout << "TX_READ: Got STOP_BIT!" << std::endl;
                        }
                        else if (parity && two_stop_bits)
                        {
                            tx_num_bits_received++;
                        }
                    }
                    else
                    {
                        assert(tx_bit == STOP_BIT);
                        tx_num_bits_received = 0;
                        std::cout << "TX_READ: Got STOP_BIT!" << std::endl;
                    }
                }
            }
        }
    }

    void rx_write()
    {
        while(1)
        {
            if (rx_transmitting)
            {
                if (!rx_num_bits_transmitted)
                {
                    // We have not yet started the transmission
                    rxd->write(START_BIT);
                    rx_num_bits_transmitted++;
                    std::cout << "RX_WRITE: wrote start bit" << std::endl;
                }
                else if (rx_num_bits_transmitted <= UART_DATA_LENGTH)
                {
                    bool next_bit;
                    next_bit = rx_transmit_data & (1 << (rx_num_bits_transmitted-1));
                    rxd->write(next_bit);
                    rx_num_bits_transmitted++;
                }
                else if (rx_num_bits_transmitted == UART_DATA_LENGTH + 1)
                {
                    if (parity)
                    {
                        bool next_bit;
                        next_bit = bits_xor(rx_transmit_data);
                        rxd->write(next_bit);
                        rx_num_bits_transmitted++;
                    }
                    else
                    {
                        rxd->write(STOP_BIT);
                        if (two_stop_bits) 
                        {
                            rx_num_bits_transmitted++;
                        }
                        else
                        {
                            rx_num_bits_transmitted = 0;
                            rx_transmitting = false;
                            std::cout << "RX_WRITE: Done transmitting" << std::endl;
                        }
                    }
                }
                else if (rx_num_bits_transmitted == UART_DATA_LENGTH + 2)
                {
                    rxd->write(STOP_BIT);
                    if (parity ^ two_stop_bits)
                    {
                        rx_num_bits_transmitted = 0;
                        rx_transmitting = false;
                        std::cout << "RX_WRITE: Done transmitting" << std::endl;
                    }
                    else if (parity && two_stop_bits)
                    {
                        rx_num_bits_transmitted++;
                    }
                }
                else
                {
                    rxd->write(STOP_BIT);
                    rx_num_bits_transmitted = 0;
                    rx_transmitting = false;
                    std::cout << "RX_WRITE: Done transmitting" << std::endl;
                }
            }
            else
            {
                rxd->write(STOP_BIT);
                rx_num_bits_transmitted = 0;
            }
            
        }
    }

private:

    void enable_uart()
    {
        bus_stimuli.addr = ADDR_ENABLE_T;
        bus_stimuli.data = UART_ENABLE;
        bus_stimuli.trans_type = WRITE;
        bus_out->master_write(bus_stimuli);
    }

    void start_tx()
    {
        bus_stimuli.addr = ADDR_TASKS_START_TX_T;
        bus_stimuli.data = UART_ENABLE;
        bus_stimuli.trans_type = WRITE;
        bus_out->master_write(bus_stimuli);
    }
    void start_rx()
    {
        bus_stimuli.addr = ADDR_TASKS_START_RX_T;
        bus_stimuli.data = UART_ENABLE;
        bus_stimuli.trans_type = WRITE;
        bus_out->master_write(bus_stimuli);

    }
    void stop_tx()
    {
        bus_stimuli.addr = ADDR_TASKS_STOP_TX_T;
        bus_stimuli.data = UART_ENABLE;
        bus_stimuli.trans_type = WRITE;
        bus_out->master_write(bus_stimuli);

    }
    void stop_rx()
    {
        bus_stimuli.addr = ADDR_TASKS_STOP_RX_T;
        bus_stimuli.data = UART_ENABLE;
        bus_stimuli.trans_type = WRITE;
        bus_out->master_write(bus_stimuli);

    }

    void tx_stimuli()
    {
        data_out->write(0x12);
        tx_transmitting = true;
    }
    void rx_stimuli_idle(int num)
    {
        for (int i = 0; i < num; i++)
        {
            rxd->write(1);
        }
        //rxd->write(1);
    }
    void rx_write_data(int data, bool two_stop_bits, bool parity)
    {
        this->two_stop_bits = two_stop_bits;
        this->parity = parity;
        rx_transmit_data = data;
        rx_transmitting = true;
        //rxd->write(START_BIT);
        //for (int i = 0; i < UART_DATA_LENGTH; i++)
        //{
        //    rxd->write(data & (1 << i));
        //}
        //if (parity)
        //{
        //    rxd->write(0);
        //}
        //rxd->write(STOP_BIT);
        //if (two_stop_bits)
        //{
        //    rxd->write(STOP_BIT);
        //}
    }

    void read_tx(bool two_stop_bits, bool parity)
    {
        std::cout << "---STIMULI: reading TX" << std::endl;
        bool tx_bit;
        txd->read(tx_bit);
        assert(tx_bit == START_BIT);
        std::cout << "Stimuli: Message: ";
        for (int i = 0; i < UART_DATA_LENGTH; i++)
        {
            txd->read(tx_bit);
            std::cout << tx_bit;
        }
        std::cout << std::endl;
        if (parity)
        {
            txd->read(tx_bit);
            std::cout << "Parity:" << tx_bit << std::endl;
        }
        txd->read(tx_bit);
        std::cout << "Stop bit: " << tx_bit << std::endl;
        if (two_stop_bits)
        {
            txd->read(tx_bit);
            std::cout << "Second stop bit: " << tx_bit << std::endl;
        }

    }

    bool read_rx(unsigned int data, bool two_stop_bits, bool parity)
    {
        rx_data_ready = false;
        unsigned int result;
        std::cout << "Stimuli: RX read" << std::endl;
        data_in->read(result);
        std::cout << "Stimuli: RX result: " << result << std::endl;
        return (result & DATA_MASK) == data;
    }

    void configure_uart(int two_stop_bits, int parity, int hwfc)
    {
        this->two_stop_bits = two_stop_bits;
        this->parity        = parity;
        bus_req_t trans;
        trans.addr = ADDR_CONFIG_T;
        trans.data = 0;
        if (two_stop_bits)
        {
            trans.data |= CONFIG_STOP_MASK_T;
        }
        if (parity)
        {
            trans.data |= CONFIG_PARITY_MASK_T;
        }
        if (hwfc)
        {
            trans.data |= CONFIG_HWFC_MASK_T;
        }
        trans.trans_type = WRITE;
        bus_out->master_write(trans);
    }

    bool check_register(int addr, int value)
    {
        bus_req_t trans;
        bus_resp_t response;
        trans.addr = addr;
        trans.trans_type = READ;
        bool success;
        bus_out->master_write(trans);

        std::cout << "Stimuli: READ transaction succeeded" << std::endl;
        std::cout << "Stimuli: Waiting for response" << std::endl;
        bus_in->master_read(response);
        while (!response.valid)
        {
            bus_in->master_read(response);
        }

        std::cout << "Stimuli: Response: " << response.data << std::endl;
        return response.data == value;
    }

    void suspend_uart()
    {
        bus_req_t trans;
        trans.addr = ADDR_TASKS_SUSPEND_T;
        trans.data = 1;
        trans.trans_type = WRITE;
        std::cout << "Stimuli: Suspending UART" << std::endl;
        bus_out->master_write(trans);

    }


};