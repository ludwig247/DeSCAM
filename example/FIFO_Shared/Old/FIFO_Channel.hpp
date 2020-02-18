//
// Created by wezel on 10/24/19.
//

#ifndef SCAM_FIFO_CHANNEL_HPP
#define SCAM_FIFO_CHANNEL_HPP

template<typename T>
FIFO_Channel<T>::FIFO_Channel (const char *name, unsigned int size) :
        sc_prim_channel(name),
        fifo_size(size),
        is_empty(true),
        is_full(false),
        tail(0),
        head(0)
        {
        buffer = new T[size];
}


template<typename T>
void FIFO_Channel<T>::read(T &out) {
    if (is_empty) {
        wait(writer_notify);
    }
    out = buffer[tail];
    tail = (tail + 1) % fifo_size;
    is_full = false;
    if (head == tail){
        is_empty = true;
    }
    reader_notify.notify();
}

template<typename T>
void FIFO_Channel<T>::write(const T &val) {
    if(is_full){
        wait(reader_notify);
    }
    buffer[head] = val;
    head = (head + 1) % fifo_size;
    is_empty = false;
    if (head == tail){
        is_full = true;
    }
    writer_notify.notify();

}

#endif //#SCAM_FIFO_CHANNEL_HPP