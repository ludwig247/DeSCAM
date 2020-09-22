//
// Created by wezel on 9/17/20.
//

#ifndef DESCAM_BUFFER_CHANNEL_HPP
#define DESCAM_BUFFER_CHANNEL_HPP

template<typename T>
Buffer_Channel<T>::Buffer_Channel (const char *name) :
        sc_prim_channel(name),
        state(EMPTY),
        tail(0),
        head(0)
{
}

template<typename T>
void Buffer_Channel<T>::read(T &out) {
    while (state == EMPTY) {
        wait(writer_notify);
    }
    out = buffer.at(tail);
    tail = (tail + 1) % size;
    state = FILLED;
    if (head == tail){
        state = EMPTY;
    }
    reader_notify.notify();
    return;
}

template<typename T>
void Buffer_Channel<T>::write(const T &val) {
    while(state == FULL){
        wait(reader_notify);
    }
    buffer.at(head) = val;
    head = (head + 1) % size;
    state = FILLED;
    if (head == tail){
        state = FULL;
    }
    writer_notify.notify();
    return;
}

#endif //DESCAM_BUFFER_CHANNEL_HPP
