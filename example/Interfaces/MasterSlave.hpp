//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 2/9/19.
//

#ifndef INTERFACES_MASTERSLAVE_HPP
#define INTERFACES_MASTERSLAVE_HPP


template<typename T>
MasterSlave<T>::MasterSlave (const char *name) : sc_prim_channel(name) {
    reader = nullptr;
    writer = nullptr;
    shared_data = malloc(sizeof(T));
    available_data = false;
    data_read = true;
    writer_ready = true;
    reader_ready = false;
}

template<typename T>
void MasterSlave<T>::master_write(const T &val,std::string stateName) {
    /**
     * @breaf: Master write should definitely be read
     *
     * @details:
     * Pseudocode:
     *      do {
     *          port_sig <= val
     *      } while (!value_read)
     *
     * For property generation: =>
     *      port_sig <= val
     *      writer_ready <= false
     *      while(writer_ready) {
     *          port_sig <= val
     *          wait(0)
     *      }
     *
     * For simulation: =>
     *      shared_data = &val;// i.e. port_sig
     *      available_data = true;
     *      while(available_data)// reader should reset "available_data"
     *          wait(SC_ZERO_TIME)
     *
     * Simulation improvement: =>
     *      shared_data = &val;// i.e. port_sig
     *      available_data = true;
     *      wait(reader_notify);// reader should reset "available_data" before notifying
     *      assert(!available_data);
     */
//    std::cout << "@" << this->name() << ": MasterSlave->master_write: writing something\n";
    shared_data = &val;
    available_data = true;
//    *      writer_notify.notify(); // to trigger the read
//    writer_notify.notify(); // master_writer doesn't need to notify
    wait(reader_notify);
//    std::cout << "@" << this->name() << ": MasterSlave->master_write: done writing\n";
    assert(!available_data && "master_write: data hasn't been read yet!");
}

template<typename T>
void MasterSlave<T>::slave_read(T &out,std::string stateName) {
    /**
     * @breaf: Slave read reads data IF AVAILABLE and return a boolean stating successful reading
     *
     * @details:
     * Pseudocode:
     *      if(available_data) {
     *          port_sig <= val
     *          read_successful <= true
     *      } else {
     *          read_successful <= false
     *      }
     *
     * For property generation: =>
     *      if(reader_ready) {
     *          port_sig <= val
     *          read_successful <= true
     *      } else {
     *          read_successful <= false
     *      }
     *
     * For simulation: =>
     *      if (available_data) {
     *          out = *shared_data;
     *          available_data = false;
     *          reader_notify.notify();
     *          return true;
     *      }
     *      return false;
     */
    if (available_data) {
//        std::cout << "@" << this->name() << ": MasterSlave->slave_read: found something to read\n";
        out = *shared_data;
        available_data = false;
        reader_notify.notify();
//        return true;
    }
//    std::cout << "@" << this->name() << ": MasterSlave->slave_read: nothing to read\n";
//    return false;
}

template<typename T>
void MasterSlave<T>::slave_read(T &out, bool &success,std::string stateName) {
    /**
     * @breaf: Slave read reads data IF AVAILABLE and return a boolean stating successful reading
     *
     * @details:
     * Pseudocode:
     *      if(available_data) {
     *          port_sig <= val
     *          read_successful <= true
     *      } else {
     *          read_successful <= false
     *      }
     *
     * For property generation: =>
     *      if(reader_ready) {
     *          port_sig <= val
     *          read_successful <= true
     *      } else {
     *          read_successful <= false
     *      }
     *
     * For simulation: =>
     *      if (available_data) {
     *          out = *shared_data;
     *          available_data = false;
     *          reader_notify.notify();
     *          return true;
     *      }
     *      return false;
     */
    if (available_data) {
//        std::cout << "@" << this->name() << ": MasterSlave->slave_read_2: found something to read\n";
        out = *shared_data;
        available_data = false;
        reader_notify.notify();
        success = true;
    } else {
//        std::cout << "@" << this->name() << ": MasterSlave->slave_read_2: nothing to read\n";
        success = false;
    }
}

template<typename T>
void MasterSlave<T>::master_read(T & out,std::string stateName) {
    /**
     * @breaf: Master read should always have a value to read
     *
     * @details:
     * Pseudocode:
     *      wait(available_data)
     *      out <= port_sig
     *
     * For property generation: =>
     *      while(!available_data) {
     *          wait(0)
     *      }
     *      available_data <= false
     *      out <= port_sig
     *
     * For simulation: =>
     *      while(!available_data)
     *          wait(SC_ZERO_TIME)
     *      available_data = false;
     *      out = shared_data;// i.e. port_sig
     *
     * Simulation improvement: =>
     *      if(!available_data)
     *          wait(writer_notify);
     *      out = *shared_data;
     *      available_data = false;
     *      reader_notify.notify();
     */
    if(!available_data) {
//        std::cout << "@" << this->name() << ": MasterSlave->master_read: waiting to read\n";
        wait(writer_notify);
    }
    out = *shared_data;
    available_data = false;
    reader_notify.notify();
//    std::cout << "@" << this->name() << ": MasterSlave->master_read: done reading\n";
}

template<typename T>
void MasterSlave<T>::slave_write(const T &val,std::string stateName) {
//    std::cout << "@" << this->name() << ": MasterSlave->slave_write: writing something\n";
    shared_data = &val;
    available_data = true;
    writer_notify.notify();
//    std::cout << "@" << this->name() << ": MasterSlave->master_write: done writing\n";
}

//template<typename T>
//bool MasterSlave<T>::peek() {
//    return available_data;
//}
//
//template<typename T>
//bool MasterSlave<T>::poke() {
//    return !available_data;
//}

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

#endif //INTERFACES_MASTERSLAVE_HPP
