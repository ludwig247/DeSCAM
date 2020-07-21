template<typename T>
Synchronizer<T>::Synchronizer (const char *name, unsigned int size) :
        sc_prim_channel(name),
        number_of_senders(size)
{
    flags = new bool[size];
    buffer = new T[size];
}

template<typename T>
void Synchronizer<T>::read(T *out) {
    //loop to check if all flags are set
    for(int i=0; i<number_of_senders;i++){
        //if one flag is not set wait for writer_notify
        if(!flags[i]){
            wait(writer_notify);
        }
    }
    //Unset flags and write output
    for(int i = 0; i<number_of_senders;i++){
        flags[i]=false;
    }
    for(int i=0; i<number_of_senders;i++) {
        out[i] = buffer[i];
    }
    reader_notify.notify();
    return;
}

template<typename T>
void Synchronizer<T>::write(const T &val, int id) {
    //Check if flag of sender with id is already set
    if(flags[id]){
       wait(reader_notify);
    }
    //Set flag and write Value into buffer
    flags[id] = true;
    buffer[id] = val;
    writer_notify.notify();
    return;
}