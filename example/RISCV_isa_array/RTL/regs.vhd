--
-- Created by deutschmann on 08.10.18
--


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use work.SCAM_Model_types.all;

entity Regs is
port(    
    clk                   : in  std_logic;
    rst                   : in  std_logic;
    CtlToRegs_port        : in  RegfileWriteType;
    CtlToRegs_port_sync   : in  bool;
    RegsToCtl_port        : out RegfileType
    );
end Regs;


architecture Regs_arch of Regs is

begin
     process(clk)

     begin
     if(clk='1' and clk'event) then

         -- Reset Sequence
         if rst = '1' then

             RegsToCtl_port.reg_file_01 <= (others => '0');
             RegsToCtl_port.reg_file_02 <= (others => '0');
             RegsToCtl_port.reg_file_03 <= (others => '0');
             RegsToCtl_port.reg_file_04 <= (others => '0');
             RegsToCtl_port.reg_file_05 <= (others => '0');
             RegsToCtl_port.reg_file_06 <= (others => '0');
             RegsToCtl_port.reg_file_07 <= (others => '0');
             RegsToCtl_port.reg_file_08 <= (others => '0');
             RegsToCtl_port.reg_file_09 <= (others => '0');
             RegsToCtl_port.reg_file_10 <= (others => '0');
             RegsToCtl_port.reg_file_11 <= (others => '0');
             RegsToCtl_port.reg_file_12 <= (others => '0');
             RegsToCtl_port.reg_file_13 <= (others => '0');
             RegsToCtl_port.reg_file_14 <= (others => '0');
             RegsToCtl_port.reg_file_15 <= (others => '0');
             RegsToCtl_port.reg_file_16 <= (others => '0');
             RegsToCtl_port.reg_file_17 <= (others => '0');
             RegsToCtl_port.reg_file_18 <= (others => '0');
             RegsToCtl_port.reg_file_19 <= (others => '0');
             RegsToCtl_port.reg_file_20 <= (others => '0');
             RegsToCtl_port.reg_file_21 <= (others => '0');
             RegsToCtl_port.reg_file_22 <= (others => '0');
             RegsToCtl_port.reg_file_23 <= (others => '0');
             RegsToCtl_port.reg_file_24 <= (others => '0');
             RegsToCtl_port.reg_file_25 <= (others => '0');
             RegsToCtl_port.reg_file_26 <= (others => '0');
             RegsToCtl_port.reg_file_27 <= (others => '0');
             RegsToCtl_port.reg_file_28 <= (others => '0');
             RegsToCtl_port.reg_file_29 <= (others => '0');
             RegsToCtl_port.reg_file_30 <= (others => '0');
             RegsToCtl_port.reg_file_31 <= (others => '0');

         else

                 -- WRITE
                 if CtlToRegs_port_sync = true then

                     if    (CtlToRegs_port.dst =  1) then
                         RegsToCtl_port.reg_file_01 <= CtlToRegs_port.dstData;
                     elsif (CtlToRegs_port.dst =  2) then
                         RegsToCtl_port.reg_file_02 <= CtlToRegs_port.dstData;
                     elsif (CtlToRegs_port.dst =  3) then
                         RegsToCtl_port.reg_file_03 <= CtlToRegs_port.dstData;
                     elsif (CtlToRegs_port.dst =  4) then
                         RegsToCtl_port.reg_file_04 <= CtlToRegs_port.dstData;
                     elsif (CtlToRegs_port.dst =  5) then
                         RegsToCtl_port.reg_file_05 <= CtlToRegs_port.dstData;
                     elsif (CtlToRegs_port.dst =  6) then
                         RegsToCtl_port.reg_file_06 <= CtlToRegs_port.dstData;
                     elsif (CtlToRegs_port.dst =  7) then
                         RegsToCtl_port.reg_file_07 <= CtlToRegs_port.dstData;
                     elsif (CtlToRegs_port.dst =  8) then
                         RegsToCtl_port.reg_file_08 <= CtlToRegs_port.dstData;
                     elsif (CtlToRegs_port.dst =  9) then
                         RegsToCtl_port.reg_file_09 <= CtlToRegs_port.dstData;
                     elsif (CtlToRegs_port.dst = 10) then
                         RegsToCtl_port.reg_file_10 <= CtlToRegs_port.dstData;
                     elsif (CtlToRegs_port.dst = 11) then
                         RegsToCtl_port.reg_file_11 <= CtlToRegs_port.dstData;
                     elsif (CtlToRegs_port.dst = 12) then
                         RegsToCtl_port.reg_file_12 <= CtlToRegs_port.dstData;
                     elsif (CtlToRegs_port.dst = 13) then
                         RegsToCtl_port.reg_file_13 <= CtlToRegs_port.dstData;
                     elsif (CtlToRegs_port.dst = 14) then
                         RegsToCtl_port.reg_file_14 <= CtlToRegs_port.dstData;
                     elsif (CtlToRegs_port.dst = 15) then
                         RegsToCtl_port.reg_file_15 <= CtlToRegs_port.dstData;
                     elsif (CtlToRegs_port.dst = 16) then
                         RegsToCtl_port.reg_file_16 <= CtlToRegs_port.dstData;
                     elsif (CtlToRegs_port.dst = 17) then
                         RegsToCtl_port.reg_file_17 <= CtlToRegs_port.dstData;
                     elsif (CtlToRegs_port.dst = 18) then
                         RegsToCtl_port.reg_file_18 <= CtlToRegs_port.dstData;
                     elsif (CtlToRegs_port.dst = 19) then
                         RegsToCtl_port.reg_file_19 <= CtlToRegs_port.dstData;
                     elsif (CtlToRegs_port.dst = 20) then
                         RegsToCtl_port.reg_file_20 <= CtlToRegs_port.dstData;
                     elsif (CtlToRegs_port.dst = 21) then
                         RegsToCtl_port.reg_file_21 <= CtlToRegs_port.dstData;
                     elsif (CtlToRegs_port.dst = 22) then
                         RegsToCtl_port.reg_file_22 <= CtlToRegs_port.dstData;
                     elsif (CtlToRegs_port.dst = 23) then
                         RegsToCtl_port.reg_file_23 <= CtlToRegs_port.dstData;
                     elsif (CtlToRegs_port.dst = 24) then
                         RegsToCtl_port.reg_file_24 <= CtlToRegs_port.dstData;
                     elsif (CtlToRegs_port.dst = 25) then
                         RegsToCtl_port.reg_file_25 <= CtlToRegs_port.dstData;
                     elsif (CtlToRegs_port.dst = 26) then
                         RegsToCtl_port.reg_file_26 <= CtlToRegs_port.dstData;
                     elsif (CtlToRegs_port.dst = 27) then
                         RegsToCtl_port.reg_file_27 <= CtlToRegs_port.dstData;
                     elsif (CtlToRegs_port.dst = 28) then
                         RegsToCtl_port.reg_file_28 <= CtlToRegs_port.dstData;
                     elsif (CtlToRegs_port.dst = 29) then
                         RegsToCtl_port.reg_file_29 <= CtlToRegs_port.dstData;
                     elsif (CtlToRegs_port.dst = 30) then
                         RegsToCtl_port.reg_file_30 <= CtlToRegs_port.dstData;
                     elsif (CtlToRegs_port.dst = 31) then
                         RegsToCtl_port.reg_file_31 <= CtlToRegs_port.dstData;
                     end if;

                 end if; 

         end if; -- RST

     end if; -- CLK

     end process;
end Regs_arch;



































