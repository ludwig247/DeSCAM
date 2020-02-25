//
// Created by wezel on 2/18/20.
//

#ifndef SCAM_FIFO_HPP
#define SCAM_FIFO_HPP

template<typename T>
FIFO<T>::FIFO (const char *name, unsigned int size) :
        sc_prim_channel(name),
        fifo_size(size),
        state(EMPTY),
        tail(0),
        head(0)
{
    buffer = new T[size];
}

template<typename T>
void FIFO<T>::read(T &out) {
    if (state == EMPTY) {
        wait(writer_notify);
    }
    out = buffer[tail];
    tail = (tail + 1) % fifo_size;
    state = FILLED;
    if (head == tail){
        state = EMPTY;
    }
    reader_notify.notify();
    return;
}

template<typename T>
void FIFO<T>::write(const T &val) {
    if(state == FULL){
        wait(reader_notify);
    }
    buffer[head] = val;
    head = (head + 1) % fifo_size;
    state = FILLED;
    if (head == tail){
        state = FULL;
    }
    writer_notify.notify();
    return;

}

#endif //#SCAM_FIFO_HPP
