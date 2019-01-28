#include <string>


template<typename T>
MasterSlave<T>::MasterSlave(const char *name) : sc_prim_channel(name) {

    reader_ready = false;
    writer_ready = false;

    reader = 0;
    writer = 0;
}

///////////////////////////////////
///////////////////////////////////
///////////////////////////////////
///////////////////////////////////


template<typename T>
void MasterSlave<T>::write(const T &val) {

    writer_ready = true;
    shared_value = val;
    wait(reader_notify);

}

template<typename T>
bool MasterSlave<T>::nb_read(T &out) {
    wait(SC_ZERO_TIME);
    if (writer_ready) {
        writer_ready = false;
        reader_notify.notify();
        out = shared_value;
        return true;
    }
    return false;
}

///////////////////////////////////
///////////////////////////////////
///////////////////////////////////
///////////////////////////////////

template<typename T>
void MasterSlave<T>::read(T & out) {
    reader_ready = true;
    wait(SC_ZERO_TIME);
    if(!writer_ready){
        wait(writer_notify);
    }

    out = shared_value;
    reader_notify.notify();
    writer_ready = false;
}

template<typename T>
void MasterSlave<T>::nb_write(const T &val) {
    shared_value = val;
    writer_ready = true;
    wait(SC_ZERO_TIME);
    if(reader_ready){
        writer_notify.notify();
        reader_ready = false;
    }
    return;
}


template<typename T>
void MasterSlave<T>::register_port(sc_port_base &port, const char *if_typename) {

    std::string nm(if_typename);
    /** Allowed pairings:
     * master_in <-> slave_out
     * master_out <-> slave_in
     * slave_out <-> slave_in
     */

    if (nm == typeid(master_in_if<T>).name()) {
        // only one reader can be connected
        if (reader != 0) {
            std::cout << "Trying to connect: " << port.name() << std::endl;
            std::cout << "Already connected to: " << reader->name() << std::endl;
            SC_REPORT_ERROR(0, "More than 1 reader is connected");
        }

        if (writer != 0) {
            //Writer has to be a slave
            if(writer_if != typeid(slave_out_if<T>).name()) {
                std::cout << "Trying to connect: " << port.name() << std::endl;
                std::cout << "Connected to: " << writer->name() << std::endl;

                std::string msg = std::string(port.name()) + " = master_in, " + std::string(writer->name()) + " != slave_out";
                SC_REPORT_ERROR(0 , msg.c_str() );
            }

        }
        reader = &port;
        reader_if = nm;
    }else if (nm == typeid(master_out_if<T>).name()) {
        // only one reader can be connected
        if (writer != 0) {
            std::cout << "Trying to connect: "<< port.name()  << std::endl;
            std::cout << "Already connected to: "<< reader->name()  << std::endl;
            SC_REPORT_ERROR(0, "More than 1 writer is connected");
        }
        if( reader != 0){
            //Writer has to be a slave
            if(reader_if != typeid(slave_in_if<T>).name()) {
                std::cout << "Trying to connect: "<< port.name()  << std::endl;
                std::cout << "Connected to: "<< reader->name()  << std::endl;
                std::string msg = std::string(port.name()) + " is master_out, " + std::string(reader->name()) + " is not slave_in";
                SC_REPORT_ERROR(0, msg.c_str());
            }
        }
        writer = &port;
        writer_if = nm;
    }else if (nm == typeid(slave_in_if<T>).name()) {
        // only one reader can be connected
        if (reader != 0) {
            std::cout << "Trying to connect: " << port.name() << std::endl;
            std::cout << "Already connected to: " << reader->name() << std::endl;
            SC_REPORT_ERROR(0, "More than 1 reader is connected");
        }
        reader = &port;
        reader_if = nm;
    }else if (nm == typeid(slave_out_if<T>).name()) {
        // only one writer can be connected
        if (writer != 0) {
            std::cout << "Trying to connect: "<< port.name()  << std::endl;
            std::cout << "Already connected to: "<< writer->name()  << std::endl;
            SC_REPORT_ERROR(0, "More than 1 writer is connected ");
        }
        writer = &port;
        writer_if = nm;
    }
}



