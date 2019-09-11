
import scam_model_types::*;

typedef enum {
  IDLE,
  SLAVE0_REQ,
  SLAVE1_REQ,
  SLAVE2_REQ,
  SLAVE3_REQ,
  SLAVE0_RESP,
  SLAVE1_RESP,
  SLAVE2_RESP,
  SLAVE3_RESP,
  MASTER_RESP
} state_t;



module Bus (output logic     master_in_notify,
            input  logic     master_in_sync,
            input  bus_req_t master_in,

            output logic     master_out_notify,
            input  logic     master_out_sync,
            output bus_resp_t master_out,

            output logic slave_in0_notify,
            output logic slave_in1_notify,
            output logic slave_in2_notify,
            output logic slave_in3_notify,

            input logic slave_in0_sync,
            input logic slave_in1_sync,
            input logic slave_in2_sync,
            input logic slave_in3_sync,

            output logic slave_out0_notify,
            output logic slave_out1_notify,
            output logic slave_out2_notify,
            output logic slave_out3_notify,

            input  logic slave_out0_sync,
            input  logic slave_out1_sync,
            input  logic slave_out2_sync,
            input  logic slave_out3_sync,

            input bus_resp_t slave_in0,
            input bus_resp_t slave_in1,
            input bus_resp_t slave_in2,
            input bus_resp_t slave_in3,

            output bus_req_t slave_out0,
            output bus_req_t slave_out1,
            output bus_req_t slave_out2,
            output bus_req_t slave_out3,

            input logic ck,
            input logic rst);

  Bus_SECTIONS section;
  bus_req_t  req_signal, next_req_signal;
  bus_resp_t resp_signal, next_resp_signal;
  state_t    state, nextState;

  always_ff @(posedge ck, posedge rst) begin
    if (rst) begin
      state <= IDLE;
      req_signal.trans_type <= single_read;
      req_signal.addr <= 0;
      req_signal.data <= 0;
      resp_signal.ack <= err;
      resp_signal.data <= 0;

    end else begin
      state       <= nextState;
      req_signal  <= next_req_signal;
      resp_signal <= next_resp_signal;
    end
  end

  always_comb begin: la_nextState
    nextState = state;
    next_req_signal = req_signal;
    next_resp_signal = resp_signal;

    unique case (state)
      IDLE: 
          if (master_in_sync) begin 
            next_req_signal.data = (master_in.trans_type == single_write) ? master_in.data : 0;
            next_req_signal.trans_type = master_in.trans_type;
            if      (master_in.addr >= 0  && master_in.addr < 8)  begin
              nextState = SLAVE0_REQ;
              next_req_signal.addr = master_in.addr;
            end
            else if (master_in.addr >= 8  && master_in.addr < 16) begin
              nextState = SLAVE1_REQ;
              next_req_signal.addr = master_in.addr - 8;
            end
            else if (master_in.addr >= 16 && master_in.addr < 24) begin
              nextState = SLAVE2_REQ;
              next_req_signal.addr = master_in.addr - 16;
            end
            else if (master_in.addr >= 24 && master_in.addr < 32) begin
              nextState = SLAVE3_REQ;
              next_req_signal.addr = master_in.addr - 24;
            end
            else begin
              nextState = MASTER_RESP;
              next_req_signal.addr = master_in.addr;
              next_resp_signal.ack = ok;
              next_resp_signal.data = 0;
            end
          end
        SLAVE0_REQ: if (slave_out0_sync) nextState = SLAVE0_RESP;
        SLAVE1_REQ: if (slave_out1_sync) nextState = SLAVE1_RESP;
        SLAVE2_REQ: if (slave_out2_sync) nextState = SLAVE2_RESP;
        SLAVE3_REQ: if (slave_out3_sync) nextState = SLAVE3_RESP;
        SLAVE0_RESP: if (slave_in0_sync) begin
          nextState = MASTER_RESP;
          next_resp_signal.ack = slave_in0.ack;
          next_resp_signal.data = req_signal.trans_type == single_read ? slave_in0.data : 0;
        end
        SLAVE1_RESP: if (slave_in1_sync) begin
          nextState = MASTER_RESP;
          next_resp_signal.ack = slave_in1.ack;
          next_resp_signal.data = req_signal.trans_type == single_read ? slave_in1.data : 0;
        end
        SLAVE2_RESP: if (slave_in2_sync) begin
          nextState = MASTER_RESP;
          next_resp_signal.ack = slave_in2.ack;
          next_resp_signal.data = req_signal.trans_type == single_read ? slave_in2.data : 0;
        end
        SLAVE3_RESP: if (slave_in3_sync) begin
          nextState = MASTER_RESP;
          next_resp_signal.ack = slave_in3.ack;
          next_resp_signal.data = req_signal.trans_type == single_read ? slave_in3.data : 0;
        end
        MASTER_RESP: if (master_out_sync) nextState = IDLE;
          
    endcase
  end: la_nextState

  always_comb begin: la_setOutputs
    master_in_notify = 1'b0;
    slave_in0_notify = 1'b0;
    slave_in1_notify = 1'b0;
    slave_in2_notify = 1'b0;
    slave_in3_notify = 1'b0;
    master_out_notify = 1'b0;
    slave_out0_notify = 1'b0;
    slave_out1_notify = 1'b0;
    slave_out2_notify = 1'b0;
    slave_out3_notify = 1'b0;
    slave_out0.trans_type = single_read;
    slave_out0.data = 0;
    slave_out0.addr = 0;
    slave_out1.trans_type = single_read;
    slave_out1.addr = 0;
    slave_out1.data = 0;
    slave_out2.trans_type = single_read;
    slave_out2.addr = 0;
    slave_out2.data = 0;
    slave_out3.trans_type = single_read;
    slave_out3.addr = 0;
    slave_out3.data = 0;
    master_out.ack = err;
    master_out.data = 0;

    case (state)
      IDLE: begin 
        master_in_notify = 1'b1;
      end
      SLAVE0_REQ: begin
        slave_out0_notify = 1'b1;
        slave_out0 = req_signal;
      end
      SLAVE1_REQ: begin 
        slave_out1_notify = 1'b1;
        slave_out1 = req_signal;
      end
      SLAVE2_REQ: begin
        slave_out2_notify = 1'b1;
        slave_out2 = req_signal;
      end
      SLAVE3_REQ: begin
        slave_out3_notify = 1'b1;
        slave_out3 = req_signal;
      end
      SLAVE0_RESP: slave_in0_notify = 1'b1;
      SLAVE1_RESP: slave_in1_notify = 1'b1;
      SLAVE2_RESP: slave_in2_notify = 1'b1;
      SLAVE3_RESP: slave_in3_notify = 1'b1;
      MASTER_RESP: begin
        master_out_notify = 1'b1;
        master_out = resp_signal;
      end
      
    endcase
  end: la_setOutputs

endmodule
