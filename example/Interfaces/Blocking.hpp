//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 2/9/19.
//

#ifndef INTERFACES_BLOCKING_HPP
#define INTERFACES_BLOCKING_HPP



template<typename T> inline
Blocking<T>::Blocking (const char *name) :
    sc_prim_channel(name),
    reader(nullptr),
    writer(nullptr),
    available_data(false),
    reader_ready(false),
    writer_ready(false),
    shared_data((T *)malloc(sizeof(T))) {
}


template<typename T> inline
void Blocking<T>::read(T &out) {
    /**
     * @breaf: Blocking read implies an important state and issues a wait property
     *
     * @param: readerPort_data = writerPort_data   == channel_data
     * @param: readerPort_notify = writerPort_sync == !available_data
     * @param: readerPort_sync = writerPort_notify == available_data
     *
     * @details:
     * - Wait until there is a value available on the channel before attempting to read (i.e. blocking).
     * - The probability of reading every written value is assured by waiting for notification of the other side indicating that a value was written.
     *
     * CFG representation: =>
     * readComm:
     *      {
     *          readerPort_notify = true
     *          wait(0) // important state
     *      }
     *      if(!readerPort_sync)
     *          goto readComm
     *      val = readerPort_sig
     *
     * For simulation: =>
     *      while(!available_data)
     *          wait(SC_ZERO_TIME)
     *      available_data = false;
     *      out = shared_data;// i.e. port_sig
     *
     * Simulation improvement: =>
     *      if(!available_data) {
     *          wait(writer_notify);// writer should set "available_data" before notifying
     *      }
     *      out = *shared_data;
     *      available_data = false;
     *      reader_notify.notify(); // i.e. writerPort_sync
     */
    if (!available_data) {
//        std::cout << "@" << this->name() << ": blocking->read: wait(writer_notify) -- before\n";
        wait(writer_notify);
//        std::cout << "@" << this->name() << ": blocking->read: wait(writer_notify) -- after\n";
        assert(available_data && "blocking_read: data hasn't been written yet!");
    }
//    std::cout << "@" << this->name() << ": blocking->read: reading\n";
#define SLOW
#ifndef SLOW

    out = *shared_data;
#else
    memcpy(out, *shared_data, sizeof(T));
#endif
    available_data = false;
    reader_notify.notify();
}

template<typename T> inline
void Blocking<T>::try_read(T &out) {
    /**
     * @breaf: non Blocking read implies an important state but doesn't issues a wait property
     *
     * @param: readerPort_data = writerPort_data   == channel_data
     * @param: readerPort_notify = writerPort_sync == !available_data
     * @param: readerPort_sync = writerPort_notify == available_data
     *
     * @details:
     * - If there is a a value available on the channel it will be read.
     * - The read_no_wait operation gives the sender a chance to write a value by issuing a wait(0) command.
     * - The probability of reading every written value depends on the designs of the modules and the issuing order of the SystemC scheduler.
     *
     * CFG representation: =>
     * readComm:
     *      {
     *          readerPort_notify = true
     *          wait(0) // important state
     *      }
     *      if(readerPort_sync)
     *          val = readerPort_sig
     *
     * For simulation: =>
     *      if(available_data) {
     *          available_data = false;
     *          out = shared_data;// i.e. port_sig
     *          reader_notify.notify(); // i.e. writerPort_sync
     *      }
     *
     * Simulation improvement: =>
     *      if(!available_data) {
     *          wait(0);// writer might have got the chance to write a value and set "available_data"
     *      }
     *      if(available_data) {
     *          out = *shared_data;
     *          available_data = false;
     *          reader_notify.notify(); // i.e. writerPort_sync
     *      }
     */
    if (!available_data) {
        insert_state();
    }
    if (available_data) {

        memcpy(out, *shared_data, sizeof(T));
        //out = *shared_data;
        available_data = false;
        reader_notify.notify();
    }
}

template<typename T> inline
void Blocking<T>::try_read(T &out, bool &success) {
    /**
     * @breaf: non Blocking read implies an important state but doesn't issues a wait property
     *
     * @param: readerPort_data = writerPort_data   == channel_data
     * @param: readerPort_notify = writerPort_sync == !available_data
     * @param: readerPort_sync = writerPort_notify == available_data
     * @param: success = !available_data
     *
     * @details:
     * - If there is a a value available on the channel it will be read and an indicator for successful read is given.
     * - The read_no_wait operation gives the sender a chance to write a value by issuing a wait(0) command.
     * - The probability of reading every written value depends on the designs of the modules and the issuing order of the SystemC scheduler.
     *
     * CFG representation: =>
     * readComm:
     *      {
     *          readerPort_notify = true
     *          wait(0) // important state
     *      }
     *      if(readerPort_sync) {
     *          val = readerPort_sig
     *      }
     *      success = readerPort_sync
     */
    if (!available_data) {
        insert_state();
    }
    if (available_data) {

        memcpy(out, *shared_data, sizeof(T));
        //out = *shared_data;
        available_data = false;
        reader_notify.notify();
        success = true; // i.e. readerPort_sync
    } else
        success = false;
}

template<typename T> inline
void Blocking<T>::write(const T &val) {
    /**
     * @breaf: Blocking write implies an important state and issues a wait property
     *
     * @param: writerPort_data = readerPort_data == channel_data
     * @param: writerPort_notify = readerPort_sync == available_data
     * @param: writerPort_sync = readerPort_notify == !available_data
     *
     * @details:
     * - Dump the value on the channel and wait for it to be read before moving on (i.e. blocking).
     * - The probability of reading every written value is assured by waiting for notification of the other side indicating that the value was read.
     *
     * CFG representation: =>
     *      writeComm:
     *      {
     *          writerPort_sig = val
     *          writerPort_notify = true
     *          wait(0) // important state
     *      }
     *      if(!writerPort_sync)
     *          goto writeComm
     *
     * For simulation: =>
     *      do {
     *          shared_data = &val;// i.e. port_sig
     *          available_data = true;// i.e. writer_notify
     *          wait(SC_ZERO_TIME)
     *      } while(available_data)// reader should reset "available_data"
     *
     * Simulation improvement: =>
     *      shared_data = &val; // i.e. port_sig
     *      available_data = true;
     *      writer_notify.notify(); // i.e. readerPort_sync
     *      wait(reader_notify); // reader should reset "available_data" before notifying
     */
//    std::cout << "@" << this->name() << ": blocking->write: writing\n";
    shared_data = &val;
    available_data = true;
    writer_notify.notify();
//    std::cout << "@" << this->name() << ": blocking->write: wait(reader_notify) -- before\n";
    wait(reader_notify);
//    std::cout << "@" << this->name() << ": blocking->write: wait(reader_notify) -- after\n";
    assert(!available_data && "blocking_write: data hasn't been read yet!");
}

template<typename T> inline
void Blocking<T>::try_write(const T &val) {
    /**
     * @breaf: non Blocking write implies an important state but doesn't issue a wait property
     *
     * @param: writerPort_data = readerPort_data == channel_data == val
     * @param: writerPort_notify = readerPort_sync == available_data
     * @param: writerPort_sync = readerPort_notify == !available_data
     *
     * @details:
     * - Dump the value on the channel without any consideration for previous state of the channel's data.
     * - This can overwrite channel's data before it being read from the other side.
     * - The probability of reading every written value depends on the designs of the modules and the issuing order of the SystemC scheduler
     *
     * CFG representation: =>
     *      writeComm:
     *      {
     *          writerPort_sig = val
     *          writerPort_notify = true
     *          wait(0) // important state
     *      }
     */
    shared_data = &val;
    available_data = true;
    writer_notify.notify();
    insert_state();
}

template<typename T> inline
void Blocking<T>::try_write(const T &val, bool & success) {
    /**
     * @breaf: non Blocking write implies an important state but doesn't issue a wait property
     *
     * @param: writerPort_data = readerPort_data == channel_data == val
     * @param: writerPort_notify = readerPort_sync == available_data
     * @param: writerPort_sync = readerPort_notify == !available_data
     * @param: success = !available_data
     *
     * @details:
     * - Dump the value on the channel without any consideration for previous state of the channel's data.
     * - This can overwrite channel's data before it being read from the other side.
     * - The probability of reading every written value depends on the designs of the modules and the issuing order of the SystemC scheduler
     * - Success means one of two things:
     *      -- I write a value and after the wait I notice that it's been read. (doesn't seem to be the write meaning)
     *              -- checking happens AFTER dumping the value and the wait
     *      -- I notice that previous value was read so that the new written value doesn't cause a loss in data
     *              -- checking happens BEFORE dumping the value and the wait
     *
     * CFG representation: =>
     *      writeComm:
     *      {
     *          writerPort_sig = val
     *          writerPort_notify = true
     *          wait(0) // important state
     *      }
     *      success = writerPort_sync
     */
    shared_data = &val;
    available_data = true;
    writer_notify.notify();
    insert_state();
    success = !available_data; //FIXME: is this the right indicator for successful write? refer to the details above
    available_data = false;
}


template<typename T> inline
bool Blocking<T>::peek() {
    return available_data;
}

template<typename T> inline
bool Blocking<T>::poke() {
    return !available_data;
}


template<typename T> inline
void Blocking<T>::register_port(sc_port_base &port, const char *if_typename) {
    std::string nm(if_typename);
    if (nm == typeid(blocking_in_if<T>).name()) {
        // only one reader can be connected
        if (reader != 0) {
            std::cout << "Trying to connect: " << port.name() << std::endl;
            std::cout << "Already connected to: " << reader->name() << std::endl;
            SC_REPORT_ERROR(0, "More than 1 reader connected to a blocking port");
        }
        reader = &port;
    } else {
        // only one writer can be connected
        if (writer != 0) {
            std::cout << "Trying to connect: " << port.name() << std::endl;
            std::cout << "Already connected to: " << writer->name() << std::endl;
            SC_REPORT_ERROR(0, "More than 1 writer connected to a blocking port");
        }
        writer = &port;
    }
}

template<typename T> inline
void Blocking<T>::read(T &out, std::string stateName) {
    this->read(out);
}

template<typename T> inline
void Blocking<T>::try_read(T &out, bool &success, std::string stateName) {
    this->try_read(out,success);
}

template<typename T> inline
void Blocking<T>::try_write(const T &val, bool &success, std::string stateName) {
    this->try_write(val,success);
}

template<typename T> inline
void Blocking<T>::write(const T &val, std::string stateName) {
    this->write(val);

}

#endif //INTERFACES_BLOCKING_HPP
