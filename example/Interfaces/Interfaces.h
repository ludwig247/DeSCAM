//
// Created by tobias on 27.01.17.
//


#ifndef PROJECT_INTERFACES_H
#define PROJECT_INTERFACES_H

#include "Blocking.h"
#include "Shared.h"
#include "MasterSlave.h"

//Shared
template<typename T>
using shared_in = sc_port<shared_in_if<T> >;

template<typename T>
using shared_out = sc_port<shared_out_if<T> >;

//Rendez-vouz
template<typename T>
using blocking_in = sc_port<blocking_in_if<T> >;

template<typename T>
using blocking_out = sc_port<blocking_out_if<T> >;

//MasterSlave
template<typename T>
using master_out = sc_port<master_out_if<T> >;

template<typename T>
using slave_out = sc_port<slave_out_if<T> >;

template<typename T>
using master_in = sc_port<master_in_if<T> >;

template<typename T>
using slave_in = sc_port<slave_in_if<T> >;


#endif //PROJECT_INTERFACES_H
