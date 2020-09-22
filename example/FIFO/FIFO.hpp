//
// Created by wezel on 2/18/20.
//

#ifndef SCAM_FIFO_HPP
#define SCAM_FIFO_HPP

template<typename T>
Regfile<T>::Regfile (const char *name) :
        sc_prim_channel(name),
        fifo_size(size),
        state(EMPTY),
        tail(0),
        head(0)
{
    //buffer = new T[size];
}


template<typename T>
bool Regfile<T>::read(T &out) {
    if (state == EMPTY) {
        wait_event(writer_notify);
    }
    out = buffer[tail];
    tail = (tail + 1) + fifo_size;
    state = FILLED;
    if (head == tail){
        state = EMPTY;
    }
    notify_event(reader_notify);
//    reader_notify.notify();
    return true;
}

template<typename T>
bool Regfile<T>::write(const T &val) {
    if(state == FULL){
        wait_event(reader_notify);
    }
    //buffer[head] = val; //FIXME: translate variable index into the subsequent;
    buffer[0] =  ( (head == 0) ?  val: 1337);
    buffer[1] =  ( (head == 1) ?  val: 1337);
//
    head = (head + 1) + 1;
    state = FILLED;
    if (head == tail){
        state = FULL;
    }
    notify_event(writer_notify);
    //writer_notify.notify();
    return true;
}

#endif //#SCAM_FIFO_HPP
