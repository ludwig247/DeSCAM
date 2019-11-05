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
    shared_out<tasks_t>        tasks_out;
    shared_in<events_t>        events_in;
    shared_out<bool>           cts_out;
    shared_in<bool>            rts_in;

    bus_req_t  bus_stimuli;
    tasks_t    task_stimuli;
    events_t   events_monitor;
    bus_resp_t response;


    void stimuli_generation()
    {
        task_stimuli.start_rx = NO_EVENT;
        task_stimuli.stop_rx  = NO_EVENT;
        task_stimuli.start_tx = NO_EVENT;
        task_stimuli.stop_tx  = NO_EVENT;
        task_stimuli.suspend  = NO_EVENT;
        tasks_out->set(task_stimuli);
        std::cout << "Stimuli: enabling UART" << std::endl;
        enable_uart();
        std::cout << "Stimuli: checking UART enable" << std::endl;
        assert(check_register(ADDR_ENABLE, UART_ENABLE));

        configure_uart(TWO_STOP_BITS, PARITY_BIT, NO_HFW);

        start_tx();
        std::cout << "Stimuli: starting TX" << std::endl;

        std::cout << "Stimuli: writing stimuli" << std::endl;
        tx_stimuli();
        read_tx(TWO_STOP_BITS, PARITY_BIT);

        suspend_uart();

        start_tx();
        tx_stimuli();
        configure_uart(ONE_STOP_BIT, PARITY_BIT, NO_HFW);
        read_tx(ONE_STOP_BIT, PARITY_BIT);

        suspend_uart();
        std::cout << "Stimuli: suspended UART" << std::endl;

        start_rx();
        std::cout << "Stimuli: starting RX" << std::endl;
        rx_stimuli_idle(10);
        rx_stimuli_data(0x24, ONE_STOP_BIT, PARITY_BIT);
        assert(read_rx(0x24, ONE_STOP_BIT, PARITY_BIT));
        std::cout << "Stimuli: stopping RX" << std::endl;
        stop_rx();
        rx_stimuli_idle(UART_TIMEOUT+1);

        task_stimuli.start_tx = EVENT;
        tasks_out->set(task_stimuli);

        tx_stimuli();
        task_stimuli.start_tx = NO_EVENT;
        tasks_out->set(task_stimuli);
        read_tx(ONE_STOP_BIT, PARITY_BIT);
        check_register(ADDR_EVENTS_TXD_READY, 1);

        task_stimuli.suspend = EVENT;
        tasks_out->set(task_stimuli);
        std::cout << "Stimuli: suspending with task" << std::endl;
        configure_uart(TWO_STOP_BITS, NO_PARITY_BIT, NO_HFW);
        std::cout << "Stimuli: done suspending" << std::endl;
        task_stimuli.suspend = NO_EVENT;
        task_stimuli.start_tx = EVENT;
        std::cout << "Stimuli: starting TX with task" << std::endl;
        tasks_out->set(task_stimuli);
        tx_stimuli();
        bool tx_bit;
        txd->read(tx_bit);
        assert(tx_bit == START_BIT);
        txd->read(tx_bit);
        task_stimuli.stop_tx = EVENT;
        task_stimuli.start_tx = NO_EVENT;
        tasks_out->set(task_stimuli);

        

        sc_stop();
    }

    SC_CTOR(Stimuli):
        bus_out("stimuli_out"),
        bus_in("stimuli_in"),
        data_out("stimuli_data_out"),
        txd("stimuli_txd"),
        data_in("stimuli_data_in"),
        rxd("stimuli_rxd")
    {
        SC_THREAD(stimuli_generation);
    }

private:
    void enable_uart()
    {
        bus_stimuli.addr = ADDR_ENABLE;
        bus_stimuli.data = UART_ENABLE;
        bus_stimuli.trans_type = WRITE;
        bus_out->write(bus_stimuli);

        std::cout << "Stimuli: non-blocking write succeeded" << std::endl;
    }

    void start_tx()
    {
        bus_stimuli.addr = ADDR_TASKS_START_TX;
        bus_stimuli.data = UART_ENABLE;
        bus_stimuli.trans_type = WRITE;
        bus_out->write(bus_stimuli);
  
        std::cout << "Stimuli: non-blocking write succeeded" << std::endl;
    }
    void start_rx()
    {
        bus_stimuli.addr = ADDR_TASKS_START_RX;
        bus_stimuli.data = UART_ENABLE;
        bus_stimuli.trans_type = WRITE;
        bus_out->write(bus_stimuli);

    }
    void stop_tx()
    {
        bus_stimuli.addr = ADDR_TASKS_STOP_TX;
        bus_stimuli.data = UART_ENABLE;
        bus_stimuli.trans_type = WRITE;
        bus_out->write(bus_stimuli);

    }
    void stop_rx()
    {
        bus_stimuli.addr = ADDR_TASKS_STOP_RX;
        bus_stimuli.data = UART_ENABLE;
        bus_stimuli.trans_type = WRITE;
        bus_out->write(bus_stimuli);

    }

    void tx_stimuli()
    {
        data_out->write(0x12);
    }
    void rx_stimuli_idle(int num)
    {
        for (int i = 0; i < num; i++)
        {
            rxd->write(1);
        }
        //rxd->write(1);
    }
    void rx_stimuli_data(int data, bool two_stop_bits, bool parity)
    {
        rxd->write(START_BIT);
        for (int i = 0; i < UART_DATA_LENGTH; i++)
        {
            rxd->write(data & (1 << i));
        }
        if (parity)
        {
            rxd->write(0);
        }
        rxd->write(STOP_BIT);
        if (two_stop_bits)
        {
            rxd->write(STOP_BIT);
        }
        //rxd->write(1);
    }

    void read_tx(bool two_stop_bits, bool parity)
    {
        bool tx_bit;
        txd->read(tx_bit);
        assert(tx_bit == START_BIT);
        std::cout << "Message: " << std::endl;
        for (int i = 0; i < UART_DATA_LENGTH; i++)
        {
            txd->read(tx_bit);
            std::cout << tx_bit << std::endl;
        }
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
        unsigned int result;
        std::cout << "Stimuli: RX read" << std::endl;
        data_in->read(result);
        std::cout << "Stimuli: RX result: " << result << std::endl;
        return result == data;
    }

    void configure_uart(int two_stop_bits, int parity, int hfw)
    {
        bus_req_t trans;
        trans.addr = ADDR_CONFIG;
        trans.data = 0;
        if (two_stop_bits)
        {
            trans.data |= CONFIG_STOP_MASK;
        }
        if (parity)
        {
            trans.data |= CONFIG_PARITY_MASK;
        }
        if (hfw)
        {
            trans.data |= CONFIG_HFW_MASK;
        }
        trans.trans_type = WRITE;
        bus_out->write(trans);
    }

    bool check_register(int addr, int value)
    {
        bus_req_t trans;
        bus_resp_t response;
        trans.addr = addr;
        trans.trans_type = READ;
        bool success;
        bus_out->write(trans);

        std::cout << "Stimuli: READ transaction succeeded" << std::endl;
        std::cout << "Stimuli: Waiting for response" << std::endl;
        bus_in->read(response);

        std::cout << "Stimuli: Response: " << response.data << std::endl;
        return response.data == value;
    }

    void suspend_uart()
    {
        bus_req_t trans;
        trans.addr = ADDR_TASKS_SUSPEND;
        trans.data = 1;
        trans.trans_type = WRITE;
        std::cout << "Stimuli: Suspending UART" << std::endl;
        bus_out->write(trans);

    }


};