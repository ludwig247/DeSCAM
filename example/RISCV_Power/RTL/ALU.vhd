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
--use work.SCAM_Model_types.all;

entity ALU is
port(    
    clk : in  std_logic;
    rst : in  std_logic;
    ALUtoCtl_port : out Unsigned (31 downto 0);
    CtlToALU_port_alu_fun       : in Unsigned ( 3 downto 0);
    CtlToALU_port_imm           : in Unsigned (31 downto 0);
    CtlToALU_port_op1_sel       : in Unsigned ( 1 downto 0);
    CtlToALU_port_op2_sel       : in Unsigned ( 1 downto 0);
    CtlToALU_port_pc_reg        : in Unsigned (31 downto 0);
    CtlToALU_port_reg1_contents : in Unsigned (31 downto 0);
    CtlToALU_port_reg2_contents : in Unsigned (31 downto 0);
    CtlToALU_port_sync          : in std_logic
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

             ALUtoCtl_port <= (others => '0');
             alu_op1 := (others => '0');
             alu_op2 := (others => '0');
             ALU_result_temp := (others => '0');

         else

                 -- Operation is requested
                 if CtlToALU_port_sync = '1' then

                     -- Set default Value
                     ALU_result_temp := (others => '0');

                     -- Set first Operand
                     if    CtlToALU_port_op1_sel = "10" then
                         alu_op1 := CtlToALU_port_reg1_contents;
                     elsif CtlToALU_port_op1_sel = "00" then
                         alu_op1 := CtlToALU_port_imm;
                     elsif CtlToALU_port_op1_sel = "01"  then
                         alu_op1 := CtlToALU_port_pc_reg;
                     else
                         alu_op1 := (others => '0');
                     end if;

                     -- Set second Operand
                     if    CtlToALU_port_op2_sel = "10" then
                         alu_op2 := CtlToALU_port_reg2_contents;
                     elsif CtlToALU_port_op2_sel = "00" then
                         alu_op2 := CtlToALU_port_imm;
                     elsif CtlToALU_port_op2_sel = "01"  then
                         alu_op2 := CtlToALU_port_pc_reg;
                     else
                         alu_op2 := (others => '0');
                     end if;


                     -- Perform Operation
                     if (not (CtlToALU_port_alu_fun = "1010")) then
                         if    (CtlToALU_port_alu_fun = "0000")   then
                             ALU_result_temp := alu_op1 + alu_op2;
                         elsif (CtlToALU_port_alu_fun = "1001")   then
                             ALU_result_temp := alu_op1 - alu_op2;
                         elsif (CtlToALU_port_alu_fun = "0001")   then
                             ALU_result_temp := alu_op1 and alu_op2;
                         elsif (CtlToALU_port_alu_fun = "0011")    then
                             ALU_result_temp := alu_op1 or alu_op2;
                         elsif (CtlToALU_port_alu_fun = "1011")   then
                             ALU_result_temp := alu_op1 xor alu_op2;
                         elsif (CtlToALU_port_alu_fun = "0101")   then
                             if (signed(alu_op1) < signed(alu_op2)) then
                                 ALU_result_temp := to_unsigned(1, 32);
                             else 
                                 ALU_result_temp := (others => '0');
                             end if;
                         elsif (CtlToALU_port_alu_fun = "0110")  then
                             if (alu_op1 < alu_op2) then
                                 ALU_result_temp := to_unsigned(1, 32);
                             else 
                                 ALU_result_temp := (others => '0');
                             end if;
                         elsif (CtlToALU_port_alu_fun = "0100")   then
                             ALU_result_temp := shift_left(alu_op1, to_integer(alu_op2 and to_unsigned(31, 32)));
                         elsif (CtlToALU_port_alu_fun = "0111")   then
                             ALU_result_temp := unsigned(shift_right(signed(alu_op1), to_integer(alu_op2 and to_unsigned(31, 32))));               
                         elsif (CtlToALU_port_alu_fun = "1000")   then
                             ALU_result_temp := shift_right(alu_op1, to_integer(alu_op2 and to_unsigned(31, 32)));
                         elsif (CtlToALU_port_alu_fun = "0010") then
                             ALU_result_temp := alu_op1;
                         end if;
                     end if;

                     -- Set Output Values
                     ALUtoCtl_port <= ALU_result_temp;


                 end if;


         end if;

     end if;
     end process;
end ALU_arch;






































