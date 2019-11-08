//
// Copyright(c) OneSpin Solutions GmbH all rights reserved
//

module vcore
  (
   clk,
   reset_n,
   
   imem_read_o,
   imem_addr_o,
   imem_data_i,

   dmem_enable_o,
   dmem_write_o,
   dmem_addr_o,
   dmem_data_o,
   dmem_data_i,
   dmem_valid_i
   );

`include "opcodes.v"
   
   input clk;
   input reset_n;

   output        imem_read_o;
   output [15:0] imem_addr_o;
   input [15:0]  imem_data_i;
   output        dmem_enable_o;
   output        dmem_write_o;
   output [15:0] dmem_addr_o;
   output [15:0] dmem_data_o;
   input [15:0]  dmem_data_i;
   input         dmem_valid_i;
   
   reg [15:0]    register[7:0];

   reg           dec_valid, ex_valid, wb_valid;
               
   reg           ex_write_reg;
   reg           ex_read_from_mem;
   reg [2:0]     ex_dest_reg;
   reg [15:0]    ex_result;
   reg [15:1]    ex_PC;

   reg           wb_write_reg;
   reg [2:0]     wb_dest_reg;
   reg [15:0]    wb_result;

   reg [15:0]    dec_PC;
   wire [15:0]   next_PC;
     

   reg [15:0]    instruction_word_reg;

   wire [4:0]    opcode;
   wire [2:0]    regA, regB, regD;
   wire [15:0]   imm;
   reg           ex_sub, ex_not, ex_branch;
   reg [15:0]    ex_op_a, ex_op_b;
   reg [15:0]    fwd_op_a, fwd_op_b;

   reg [1:0]     current_mem_state, next_mem_state;
   reg [15:0]    dmem_data_o;
   reg           dmem_enable_o,dmem_write_o;

   wire [15:0]   real_ex_result;
   wire          mem_stall;
   wire          ex_mispredict;          
   wire [15:0]   dmem_addr_o;

   parameter MEM_IDLE   =  2'b00;
   parameter MEM_READ   =  2'b01;
   parameter MEM_WRITE  =  2'b10;
   
   assign opcode = instruction_word_reg[15:11];
   assign regA = instruction_word_reg[10:8];
   assign regB = instruction_word_reg[7:5];
   assign regD = instruction_word_reg[4:2];
   assign imm = opcode==BEQZ? 
          {{8{instruction_word_reg[7]}},instruction_word_reg[7:0]}: 
          {{11{instruction_word_reg[4]}},instruction_word_reg[4:0]};

   assign imem_read_o = !mem_stall;
   assign imem_addr_o = dec_valid? next_PC: dec_PC;

   assign real_ex_result = ex_read_from_mem ? dmem_data_i : ex_result;
   assign mem_stall = current_mem_state!=MEM_IDLE && !dmem_valid_i;

   assign dmem_addr_o = ex_result;

   // instruction fetch
   always @ (posedge clk)
     if (!mem_stall)
       instruction_word_reg <= imem_data_i;

   assign next_PC = ex_mispredict ?
          {ex_PC,1'b0} + ex_op_b : dec_PC + 16'h0002;
   
   // PC behavior   
   assign ex_mispredict = ex_branch && ex_valid && ex_result[0];
   
   always @ (posedge clk or negedge reset_n)
     if (!reset_n)
       begin
          dec_PC <= 0;
          dec_valid <= 0;
       end
     else 
       begin
          dec_valid <= 1;
          if (!mem_stall && dec_valid)
            dec_PC <= next_PC;
       end

// register update
   always @ (posedge clk or negedge reset_n)
     if (!reset_n)
       begin
          register[0] <= 0;
          register[1] <= 0;
          register[2] <= 0;
          register[3] <= 0;
          register[4] <= 0;
          register[5] <= 0;
          register[6] <= 0;
          register[7] <= 0;
       end
     else if (wb_write_reg && wb_valid)
       register[wb_dest_reg] <= wb_result;

   // ALU
   always @ ( /*AUTOSENSE*/ex_branch or ex_not or ex_op_a or ex_op_b
             or ex_sub) begin
      if (ex_branch)
        ex_result = ex_op_a == 0;
      else if (ex_not)
        ex_result = ~ex_op_a;
      else if (ex_sub)
        ex_result = ex_op_a - ex_op_b;
      else
        ex_result = ex_op_a + ex_op_b;
      
   end

   // memory controller

   always @ ( /*AUTOSENSE*/current_mem_state or dec_valid
             or dmem_valid_i or ex_mispredict or opcode) 
     begin
        next_mem_state = MEM_IDLE;
        dmem_enable_o = 1'b0;
        dmem_write_o = 1'b0;
        case (current_mem_state)
          MEM_IDLE: 
            begin
               if (dec_valid && ! ex_mispredict && opcode==LD)
                 next_mem_state = MEM_READ;
               else if (dec_valid && ! ex_mispredict && opcode==ST)
                 next_mem_state = MEM_WRITE;
            end
          MEM_READ:
            begin
               dmem_enable_o = 1'b1;
               dmem_write_o = 1'b0;
               if (dmem_valid_i && dec_valid && opcode==ST)
                 next_mem_state = MEM_WRITE;
               else if (!dmem_valid_i || dec_valid && opcode==LD)
                 next_mem_state = MEM_READ;
            end
          MEM_WRITE:
            begin
               dmem_enable_o = 1'b1;
               dmem_write_o = 1'b1;
               if (dmem_valid_i && dec_valid && opcode==LD)
                 next_mem_state = MEM_READ;
               else if (!dmem_valid_i || dec_valid && opcode==ST)
                 next_mem_state = MEM_WRITE;
            end
        endcase
     end // always @ (...
   
   always @ (posedge clk or negedge reset_n)
     if (!reset_n)
       current_mem_state <= MEM_IDLE;
     else
       current_mem_state <= next_mem_state;
       
   // forwarding
   always @ ( /*AUTOSENSE*/ex_write_reg or ex_dest_reg or real_ex_result or
              wb_write_reg or wb_dest_reg or regA or regB or wb_result or 
              register[0] or register[1] or register[2] or register[3] or
              register[4] or register[5] or register[6] or register[7] or
              ex_valid or wb_valid)

     begin
       fwd_op_a <= (ex_write_reg && ex_valid && ex_dest_reg == regA) ? real_ex_result : 
                   (wb_write_reg && wb_valid && wb_dest_reg == regA) ? wb_result: register[regA];
       fwd_op_b <= (ex_write_reg && ex_valid && ex_dest_reg == regB) ? real_ex_result : 
                   (wb_write_reg && wb_valid && wb_dest_reg == regB) ? wb_result: register[regB];
     end // always @ (...
     
   // pipeline      
   always @ (posedge clk or negedge reset_n)
     if (!reset_n)
       begin
          ex_valid <= 0;
          wb_valid <= 0;
          ex_write_reg <= 0;
       end
     else if (!mem_stall)
       begin
          ex_write_reg <= 0;
          ex_read_from_mem <= 0;
          ex_op_a <= fwd_op_a;
          ex_op_b <= fwd_op_b;

          ex_sub <= 0;
          ex_not <= 0;
          ex_branch <= 0;
          ex_PC <= dec_PC[15:1];
          
          // decode
          if (dec_valid && ! ex_mispredict)
            begin
            ex_valid <= dec_valid;
            case (opcode)
              NOT:
                begin
                   ex_write_reg <= 1;
                   ex_dest_reg <= regD;
                   ex_not <= 1;
                end
              ADD:
                begin
                   ex_write_reg <= 1;
                   ex_dest_reg <= regD;
                end
              SUB:
                begin
                   ex_write_reg <= 1;
                   ex_dest_reg <= regD;
                   ex_sub <= 1;
                end
              LD:
                begin
                   ex_write_reg <= 1;
                   ex_read_from_mem <= 1;
                   ex_dest_reg <= regA;
                   ex_op_a <= imm;
                end
              ST:
                begin
                   ex_op_a <= imm;
                   ex_dest_reg <= regA;
                   dmem_data_o <= fwd_op_a;
                end
              BEQZ:
                begin
                   ex_branch <= 1;
                   ex_op_b <= imm << 1;
                end
            endcase // case(opcode)
            end
          else
            ex_valid <= 0;
          // execute
          wb_write_reg <= ex_write_reg;
          wb_result <= real_ex_result;
          wb_dest_reg <= ex_dest_reg;
          wb_valid <= ex_valid;
       end
     else // of "if (!mem_stall)"
        begin
          ex_valid <= 1;
          wb_valid <= 0;
          wb_write_reg <= 0;
        end

endmodule // vcore
