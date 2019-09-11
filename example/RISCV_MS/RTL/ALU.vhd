--
-- Created by deutschmann on 05.02.18
--
-- Module: Arithmetic Logic Unit (ALU)
--
-- Slave module. Performs arithmetic and logic operations as well as shifting and comparison.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use work.SCAM_Model_types.all;

entity ALU is
port(    
    clk                  : in  std_logic;
    rst                  : in  std_logic;
    ALUtoCtl_port        : out ALUtoCtl_IF;
    CtlToALU_port        : in  CtlToALU_IF;
    CtlToALU_port_sync   : in  bool
    );
end ALU;


architecture ALU_arch of ALU is

begin
     process(clk)

     variable alu_op1         : Unsigned (31 downto 0);
     variable alu_op2         : Unsigned (31 downto 0);
     variable ALU_result_temp : Unsigned (31 downto 0);

     begin
     if(clk='1' and clk'event) then

         -- Reset Sequence
         if rst = '1' then

             ALUtoCtl_port.ALU_result <= (others => '0');
             alu_op1 := (others => '0');
             alu_op2 := (others => '0');
             ALU_result_temp := (others => '0');

         else

                 -- Operation is requested
                 if CtlToALU_port_sync = true then

                     -- Set default Value
                     ALU_result_temp := (others => '0');

                     -- Set first Operand
                     if    CtlToALU_port.op1_sel = OP_REG then
                         alu_op1 := CtlToALU_port.reg1_contents;
                     elsif CtlToALU_port.op1_sel = OP_IMM then
                         alu_op1 := CtlToALU_port.imm;
                     elsif CtlToALU_port.op1_sel = OP_PC  then
                         alu_op1 := CtlToALU_port.pc_reg;
                     else
                         alu_op1 := (others => '0');
                     end if;

                     -- Set second Operand
                     if    CtlToALU_port.op2_sel = OP_REG then
                         alu_op2 := CtlToALU_port.reg2_contents;
                     elsif CtlToALU_port.op2_sel = OP_IMM then
                         alu_op2 := CtlToALU_port.imm;
                     elsif CtlToALU_port.op2_sel = OP_PC  then
                         alu_op2 := CtlToALU_port.pc_reg;
                     else
                         alu_op2 := (others => '0');
                     end if;


                     -- Perform Operation
                     if    (CtlToALU_port.alu_fun = ALU_ADD)   then
                         ALU_result_temp := alu_op1 + alu_op2;
                     elsif (CtlToALU_port.alu_fun = ALU_SUB)   then
                         ALU_result_temp := alu_op1 - alu_op2;
                     elsif (CtlToALU_port.alu_fun = ALU_AND)   then
                         ALU_result_temp := alu_op1 and alu_op2;
                     elsif (CtlToALU_port.alu_fun = ALU_OR)    then
                         ALU_result_temp := alu_op1 or alu_op2;
                     elsif (CtlToALU_port.alu_fun = ALU_XOR)   then
                         ALU_result_temp := alu_op1 xor alu_op2;
                     elsif (CtlToALU_port.alu_fun = ALU_SLT)   then
                         if (signed(alu_op1) < signed(alu_op2)) then
                             ALU_result_temp := to_unsigned(1, 32);
                         else 
                             ALU_result_temp := (others => '0');
                         end if;
                     elsif (CtlToALU_port.alu_fun = ALU_SLTU)  then
                         if (alu_op1 < alu_op2) then
                             ALU_result_temp := to_unsigned(1, 32);
                         else 
                             ALU_result_temp := (others => '0');
                         end if;
                     elsif (CtlToALU_port.alu_fun = ALU_SLL)   then
                         ALU_result_temp := shift_left(alu_op1, to_integer(alu_op2 and to_unsigned(31, 32)));
                     elsif (CtlToALU_port.alu_fun = ALU_SRA)   then
                         ALU_result_temp := unsigned(shift_right(signed(alu_op1), to_integer(alu_op2 and to_unsigned(31, 32))));               
                     elsif (CtlToALU_port.alu_fun = ALU_SRL)   then
                         ALU_result_temp := shift_right(alu_op1, to_integer(alu_op2 and to_unsigned(31, 32)));
                     elsif (CtlToALU_port.alu_fun = ALU_COPY1) then
                         ALU_result_temp := alu_op1;
                     elsif (CtlToALU_port.alu_fun = ALU_X) then			
                         ALU_result_temp := (others => '0');
                     end if;
                  
                     -- Set Output Values
                     ALUtoCtl_port.ALU_result <= ALU_result_temp;

                 end if;

         end if;

     end if;
     end process;
end ALU_arch;






































