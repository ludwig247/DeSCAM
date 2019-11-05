//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 2/9/19.
//

#ifndef INTERFACES_H
#define INTERFACES_H

//#define WAIT_TIME std::rand()%2
#define WAIT_TIME 0

#include "Blocking.h"
#include "MasterSlave.h"
#include "Shared.h"

//Blocking
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

//Shared
template<typename T>
using shared_in = sc_port<shared_in_if<T> >;

template<typename T>
using shared_out = sc_port<shared_out_if<T> >;

#endif //INTERFACES_H
