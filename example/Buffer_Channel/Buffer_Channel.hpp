//
// Created by wezel on 9/17/20.
//

#ifndef DESCAM_BUFFER_CHANNEL_HPP
#define DESCAM_BUFFER_CHANNEL_HPP

template<typename T>
Buffer_Channel<T>::Buffer_Channel (const char *name) :
        sc_prim_channel(name),
        state0(EMPTY),
        tail0(0),
        head0(0),
        state1(EMPTY),
        tail1(0),
        head1(0),
        state2(EMPTY),
        tail2(0),
        head2(0),
        next_read(0)
{
}

template<typename T>
void Buffer_Channel<T>::read(T &out) {
    if(next_read==0) {
        while (state0 == EMPTY) {
            wait(writer_notify0);
        }
        out = buffer0.at(tail0);
        tail0 = (tail0 + 1) % size;
        state0 = FILLED;
        if (head0 == tail0) {
            state0 = EMPTY;
        }
        reader_notify0.notify();
        next_read++;
    } else if (next_read == 1){
        while (state1 == EMPTY) {
            wait(writer_notify1);
        }
        out = buffer1.at(tail1);
        tail1 = (tail1 + 1) % size;
        state1 = FILLED;
        if (head1 == tail1) {
            state1 = EMPTY;
        }
        reader_notify1.notify();
        next_read++;
    }
    else{//if(next_read == 2){
        while (state2 == EMPTY) {
            wait(writer_notify2);
        }
        out = buffer2.at(tail2);
        tail2 = (tail2 + 1) % size;
        state2 = FILLED;
        if (head2 == tail2) {
            state2 = EMPTY;
        }
        reader_notify2.notify();
        next_read = 0;
    }
    return;
}

template<typename T>
void Buffer_Channel<T>::write0(const T &val) {
    while(state0 == FULL){
        wait(reader_notify0);
    }
    buffer0.at(head0) = val;
    head0 = (head0 + 1) % size;
    state0 = FILLED;
    if (head0 == tail0){
        state0 = FULL;
    }
    writer_notify0.notify();
    return;
}
template<typename T>
void Buffer_Channel<T>::write1(const T &val) {
    while(state1 == FULL){
        wait(reader_notify1);
    }
    buffer1.at(head1) = val;
    head1 = (head1 + 1) % size;
    state1 = FILLED;
    if (head1 == tail1){
        state1 = FULL;
    }
    writer_notify1.notify();
    return;
}
template<typename T>
void Buffer_Channel<T>::write2(const T &val) {
    while(state2 == FULL){
        wait(reader_notify2);
    }
    buffer2.at(head2) = val;
    head2 = (head2 + 1) % size;
    state2 = FILLED;
    if (head2 == tail2){
        state2 = FULL;
    }
    writer_notify2.notify();
    return;
}

#endif //DESCAM_BUFFER_CHANNEL_HPP
