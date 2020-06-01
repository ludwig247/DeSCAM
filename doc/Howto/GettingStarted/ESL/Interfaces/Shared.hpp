//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 2/9/19.
//

#ifndef INTERFACES_SHARED_HPP
#define INTERFACES_SHARED_HPP

template<typename T>
Shared<T>::Shared (const char *name) : sc_prim_channel(name) {
        reader = nullptr;
        writer = nullptr;
        //shared_data = malloc(sizeof(T));
        available_data = false;
}

template<typename T>
void Shared<T>::get(T & out) {
    if(available_data){
        out = shared_data;
        available_data = false;
    }
}

template<typename T>
void Shared<T>::set(const T &val) {
    shared_data = val;
    available_data = true;
}

template<typename T>
void Shared<T>::register_port(sc_port_base &port, const char *if_typename) {
    std::string nm(if_typename);
    if (nm == typeid(shared_in_if<T>).name()) {
        // only one reader can be connected
        if (reader != 0) {
            SC_REPORT_ERROR(0, "More than 1 reader connected to a shared port");
        }
        reader = &port;
    } else {
        // only one writer can be connected
        if (writer != 0) {
            SC_REPORT_ERROR(0, "More than 1 reader connected to a shared port");
        }
        writer = &port;
    }
}

#endif //INTERFACES_SHARED_HPP