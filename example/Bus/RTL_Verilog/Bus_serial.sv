
import scam_model_types::*;

typedef enum {
  IDLE,
  MASTER_IN,
  SLAVE_OUT_WAIT,
  SLAVE_OUT,
  SLAVE_IN_WAIT,
  SLAVE_IN,
  MASTER_OUT_WAIT,
  MASTER_OUT
} state_t;

typedef enum logic [1:0] {
  SLAVE0 = 2'b00,
  SLAVE1 = 2'b01,
  SLAVE2 = 2'b10,
  SLAVE3 = 2'b11
} slaves;



module Bus (output logic master_in_notify,
            input  logic master_in_sync,
            input  logic master_in,

            output logic master_out_notify,
            input  logic master_out_sync,
            output logic master_out,

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

            input logic slave_out0_sync,
            input logic slave_out1_sync,
            input logic slave_out2_sync,
            input logic slave_out3_sync,

            input logic slave_in0,
            input logic slave_in1,
            input logic slave_in2,
            input logic slave_in3,

            output logic slave_out0,
            output logic slave_out1,
            output logic slave_out2,
            output logic slave_out3,

            input logic ck,
            input logic rst);

  localparam COUNTER_WIDTH = 6;
  localparam REQ_SIGNAL_SIZE = NUM_ADDRESS_BITS + NUM_DATA_BITS + NUM_TYPE_BITS;
  localparam RESP_SIGNAL_SIZE = NUM_DATA_BITS + NUM_ACK_BITS;

  Bus_SECTIONS section;
  bus_req_t_packed  req_signal;
  bus_resp_t_packed resp_signal;
  state_t    state, nextState;
  slaves currentSlave;
  logic [3:0] slavesInNotify, slavesInSync, slavesIn;
  logic [3:0] slavesOutNotify, slavesOutSync, slavesOut;
  logic [COUNTER_WIDTH-1:0] counter;
  logic resp_signal_in;

  assign slave_out0_notify = slavesOutNotify[SLAVE0];
  assign slave_out1_notify = slavesOutNotify[SLAVE1]; 
  assign slave_out2_notify = slavesOutNotify[SLAVE2]; 
  assign slave_out3_notify = slavesOutNotify[SLAVE3]; 
  assign slave_in0_notify = slavesInNotify[SLAVE0];
  assign slave_in1_notify = slavesInNotify[SLAVE1]; 
  assign slave_in2_notify = slavesInNotify[SLAVE2]; 
  assign slave_in3_notify = slavesInNotify[SLAVE3]; 
  assign slave_out0 = slavesOut[SLAVE0];
  assign slave_out1 = slavesOut[SLAVE1]; 
  assign slave_out2 = slavesOut[SLAVE2]; 
  assign slave_out3 = slavesOut[SLAVE3]; 
  assign slavesOutSync[SLAVE0] = slave_out0_sync;
  assign slavesOutSync[SLAVE1] = slave_out1_sync; 
  assign slavesOutSync[SLAVE2] = slave_out2_sync; 
  assign slavesOutSync[SLAVE3] = slave_out3_sync; 
  assign slavesInSync[SLAVE0] = slave_in0_sync;
  assign slavesInSync[SLAVE1] = slave_in1_sync; 
  assign slavesInSync[SLAVE2] = slave_in2_sync; 
  assign slavesInSync[SLAVE3] = slave_in3_sync; 

  always_ff @(posedge ck, posedge rst) begin
    if (rst) begin
      state             <= IDLE;
      currentSlave      <= SLAVE0;
      counter           <= '0;
      master_in_notify  <= 1'b1;
      master_out_notify <= 1'b0;
      slavesOutNotify   <= '0;
      slavesInNotify    <= '0;
    end else begin
    unique case (state)
      IDLE: begin
        if (master_in_sync) begin
          state             <= MASTER_IN;
          counter           <= 1;
          master_in_notify  <= 1'b0;
        end
      end
      MASTER_IN: begin
        if (counter == REQ_SIGNAL_SIZE-1) begin
          state                                 <= SLAVE_OUT_WAIT;
          currentSlave                          <= req_signal.addr[3:2];
          slavesOutNotify[req_signal.addr[3:2]] <= 1'b1;
          slavesOut[req_signal.addr[3:2]]       <= req_signal[REQ_SIGNAL_SIZE-2];
          counter                               <= 0;
        end else begin
          counter <= counter + 1;
        end
      end
      SLAVE_OUT_WAIT: 
        if (slavesOutSync[currentSlave]) begin
          state                         <= SLAVE_OUT;
          slavesOut[currentSlave]       <= req_signal[REQ_SIGNAL_SIZE-2]; // last value not yet shifted in
          slavesOutNotify[currentSlave] <= 1'b0;
          counter <= 1;
        end
      SLAVE_OUT: begin
        if (counter == REQ_SIGNAL_SIZE-1) begin
            state <= SLAVE_IN_WAIT;
            slavesInNotify[currentSlave] <= 1'b1;
            counter <= 0;
        end else begin
          counter <= counter + 1;
        end
        slavesOut[currentSlave] <= req_signal[REQ_SIGNAL_SIZE-2];//req_signal[req_signal_count];

        end
      SLAVE_IN_WAIT: begin
        if (slavesInSync[currentSlave]) begin
          state <= SLAVE_IN;
          counter <= 1;
          slavesInNotify[currentSlave] = '0;
        end
      end
      SLAVE_IN: begin
        if (counter == RESP_SIGNAL_SIZE-1) begin
          state <= MASTER_OUT_WAIT;
          master_out_notify <= 1'b1;
          master_out <= resp_signal[RESP_SIGNAL_SIZE-2];
          counter <= 0;
        end else begin
          counter <= counter + 1;
        end
      end
      MASTER_OUT_WAIT: begin
        if (master_out_sync) begin
          state <= MASTER_OUT;
          counter <= 1;
          master_out_notify <= 1'b0;
          master_out <= resp_signal[RESP_SIGNAL_SIZE-2];
        end
      end
      MASTER_OUT: begin
        if (counter == RESP_SIGNAL_SIZE-1) begin
          state <= IDLE;
          counter <= 0;
          master_in_notify <= 1'b1;
        end else begin
          counter <= counter + 1;
        end
        master_out <= resp_signal[RESP_SIGNAL_SIZE-2];
      end
    endcase
    end
  end

  always_ff @(posedge ck, posedge rst) begin
    if (rst) begin
      req_signal.data <= '0;
      req_signal.addr <= '0;
      req_signal.trans_type <= single_read;
    end else begin
      if ((master_in_notify && master_in_sync) || state == MASTER_IN) begin
        req_signal <= {req_signal[REQ_SIGNAL_SIZE-2:0], master_in};
      end
      if (state == MASTER_IN && counter == REQ_SIGNAL_SIZE-1) begin
        if (req_signal[counter-1] == single_read) begin
          req_signal.data <= 32'b0;
        end
        req_signal.addr[4:3] <= 2'b00;
      end
      if ((state == SLAVE_OUT_WAIT && 
           slavesOutSync[currentSlave] && 
           slavesOutNotify[currentSlave]) ||
           state == SLAVE_OUT) begin
        req_signal <= {req_signal[REQ_SIGNAL_SIZE-2:0], req_signal[REQ_SIGNAL_SIZE-1]};
      end
    end
  end

  always_ff @(posedge ck, posedge rst) begin
    if (rst) begin
      resp_signal.ack <= err;
      resp_signal.data <= 0;
    end else begin
      if (state == SLAVE_IN || 
         (state == SLAVE_IN_WAIT &&
          slavesInSync[currentSlave] &&
          slavesInNotify[currentSlave])) begin
        resp_signal <= {resp_signal[RESP_SIGNAL_SIZE-2:0], resp_signal_in};
        if (state == SLAVE_IN && counter == RESP_SIGNAL_SIZE-1) begin
          if (req_signal.trans_type == single_write) begin
            resp_signal.data <= 32'b0;
          end
        end
      end
      if ((state == MASTER_OUT_WAIT && master_out_notify && master_out_sync)
        || state == MASTER_OUT) begin
          resp_signal <= {resp_signal[RESP_SIGNAL_SIZE-2:0], resp_signal[RESP_SIGNAL_SIZE-1]};
      end
    end
  end

  always_comb begin: la_resp_signal_mux
    resp_signal_in = 1'b0;
    unique case (currentSlave)
      SLAVE0: resp_signal_in = slave_in0;
      SLAVE1: resp_signal_in = slave_in1;
      SLAVE2: resp_signal_in = slave_in2;
      SLAVE3: resp_signal_in = slave_in3;
    endcase
  end

endmodule

