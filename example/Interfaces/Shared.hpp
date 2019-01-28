#include <string>

using namespace std;

template<typename T>
Shared<T>::Shared(const char *name) : sc_prim_channel(name) {
    reader = 0;
    writer = 0;
}

template<typename T>
void Shared<T>::get(T & out) {
    out = shared_value;
}

template<typename T>
void Shared<T>::set(const T &val) {
    shared_value = val;
}



template<typename T>
void Shared<T>::register_port(sc_port_base &port, const char *if_typename) {
    string nm(if_typename);
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

