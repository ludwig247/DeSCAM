
package scam_model_types;
  localparam NUM_DATA_BITS = 32;
  localparam NUM_ADDRESS_BITS = 5;
  localparam NUM_TYPE_BITS = 1;
  localparam NUM_ACK_BITS = 1;
  localparam DATA_OFFSET = 0;
  localparam ADDRESS_OFFSET = NUM_DATA_BITS;
  localparam TRANS_TYPE_OFFSET = NUM_ADDRESS_BITS + NUM_DATA_BITS;
  localparam ACK_OFFSET = 32;

  typedef enum bit {
    false = 1'b0,
    true  = 1'b1
  } bool;

  typedef enum logic {
    run
  } Bus_SECTIONS;

  typedef enum logic [1:0] {
    err,
    ok,
    rty
  } ack_t;

  typedef enum logic {
    single_read,
    single_write
  } trans_t;

  typedef struct {
    integer addr;
    integer data;
    trans_t trans_type;
  } bus_req_t;
  typedef struct packed {
    trans_t trans_type;
    logic [4:0] addr;
    integer data;
  } bus_req_t_packed;

  typedef struct {
    ack_t ack;
    integer data;
  } bus_resp_t;
  typedef struct packed {
    ack_t ack;
    integer data;
  } bus_resp_t_packed;

  typedef enum logic {
    request,
    response
  } req_type_t;

endpackage
