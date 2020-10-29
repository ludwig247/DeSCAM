//
// Created by ludwig on 05.07.17.
//

#ifndef PROJECT_TYPES_H
#define PROJECT_TYPES_H

enum opc_t  {NOP_OPC, READ_OPC, WRITE_OPC, RMW_OPC, BTR2_OPC, BTR4_OPC, BTR8_OPC};
enum ack_t  {OK, RTY, ERR};
struct req_t  {int addr; opc_t opc; int data; bool abort;};
enum update_t  {NXT_GRANT_Q, NXT_PHASE_Q, RTY_Q, NXT_BTR_Q}; //grant sent when a req should be moved to grant, phase when only a phase increment, rty when retry, btr when the address should remain in address but the data phase is moved out
enum req_status_t  {EMPTY_STATUS, REQ_STATUS, ADDR_STATUS, DATA_STAUS};
enum trans_t { SINGLE_READ, SINGLE_WRITE};
struct result_t {int data; bool err; };

#endif //PROJECT_TYPES_H
