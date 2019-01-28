#include <string>


template<typename T>
Blocking<T>::Blocking(const char *name) : sc_prim_channel(name) {

    reader_ready = false;
    writer_ready = false;

    reader = 0;
    writer = 0;
}

template<typename T>
void Blocking<T>::read(T &out) {
    // This catches the case that the counterpart didn't get execution priorities, yet
    if(reader_ready){
        wait(SC_ZERO_TIME);
    }
    //Reader has to read and set writer_ready to false
    SC_ASSERT_(!reader_ready,"Handshaking is wrong");
    reader_ready = true;
    if (!writer_ready) {
#ifdef VERBOSE
        std::cout << reader->name() << "->read()" << ": waiting for " << writer->name() << "->write()" << std::endl;
#endif
        wait(writer_notify);
    }
    writer_ready = false;
#ifdef VERBOSE
    std::cout << writer->name() << "->read(): notify" << std::endl;
#endif
    out = shared_value;
    reader_notify.notify();
}

template<typename T>
void Blocking<T>::write(const T &val) {
    // This catches the case that the counterpart didn't get execution priorities, yet
    if(writer_ready){
        wait(SC_ZERO_TIME);
    }
    //Reader has to read and set writer_ready to false
    SC_ASSERT_(!writer_ready,"Handshaking is wrong");
    writer_ready = true;
    shared_value = val;
    if (!reader_ready) {
#ifdef VERBOSE
        std::cout << writer->name() << "->write(): waiting for " << reader->name() << "->read()" << std::endl;
#endif
        wait(reader_notify);
    }
#ifdef VERBOSE
    std::cout << writer->name() << "->write(): notify" << std::endl;
#endif

    writer_notify.notify();
    reader_ready = false;
}


template<typename T>
void Blocking<T>::register_port(sc_port_base &port, const char *if_typename) {
    std::string nm(if_typename);

    if (nm == typeid(blocking_in_if<T>).name()) {
        // only one reader can be connected
        if (reader != 0) {
            std::cout << "Trying to connect: " << port.name() << std::endl;
            std::cout << "Already connected to: " << reader->name() << std::endl;
            SC_REPORT_ERROR(0, "More than 1 reader connected to a rendez-vous port");
        }
        reader = &port;
    } else {
        // only one writer can be connected
        if (writer != 0) {
            std::cout << "Trying to connect: " << port.name() << std::endl;
            std::cout << "Already connected to: " << writer->name() << std::endl;
            SC_REPORT_ERROR(0, "More than 1 writer connected to a rendez-vous port");

        }
        writer = &port;
    }
}

template<typename T>
bool Blocking<T>::nb_read(T &out) {
    assert(!reader_ready);
    //Offer communication
    reader_ready = true;
    wait(SC_ZERO_TIME);
    if (writer_ready && reader_ready) {
        //Waiting for writer to change value
        writer_ready = false;
        reader_notify.notify();
        wait(writer_notify);
        out = shared_value;
        return true;
    } else if (writer_ready && !reader_ready) {
        //Writer already changed the shared_value
        out = shared_value;
        writer_ready = false;
        reader_notify.notify();
        return true;
    }
    //Communication offer wasn't accepted
    reader_ready = false;
    return false;
}


template<typename T>
bool Blocking<T>::nb_write(const T &val) {
    assert(!writer_ready);
    //Offer communication
    writer_ready = true;
    wait(SC_ZERO_TIME);
    if (reader_ready && writer_ready) {
        shared_value = val;
        reader_ready = false;
        writer_notify.notify();
        wait(reader_notify);
        return true;
    } else if (reader_ready && !writer_ready) {
        shared_value = val;
        reader_ready = false;
        writer_notify.notify();
        return true;
    }
    //Communication offer wasn't accepted
    writer_ready = false;
    return false;
}
