template<typename T>
Synchronizer<T>::Synchronizer (const char *name) :
        sc_prim_channel(name)
{
    for(int i=0; i<flags.size();i++){
        flags.at(i) = false;
    }
    cnt = 0;
}

template<typename T>
void Synchronizer<T>::read(std::array<T,NUMBER_OF_SENDERS> * out) {
    //loop to check if all flags are set
    while(cnt<NUMBER_OF_SENDERS){
        wait(writer_notify);
    }
    assert(flags.at(0)==flags.at(1)==flags.at(2)==true);
    //Unset flags and write output
    for(int i = 0; i<NUMBER_OF_SENDERS;i++){
        flags.at(i)=false;
    }
    cnt = 0;
    for(int i=0; i<NUMBER_OF_SENDERS;i++) {
        out->at(i) = buffer.at(i);
    }
    reader_notify.notify();
    return;
}

template<typename T>
void Synchronizer<T>::write(const T &val, int id) {
    //Check if flag of sender with id is already set
    if(flags.at(id)){
       wait(reader_notify);
    }
    //Set flag and write Value into buffer
    flags.at(id) = true;
    buffer.at(id) = val;
    cnt++;
    writer_notify.notify();
    return;
}