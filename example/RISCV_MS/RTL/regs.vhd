--
-- Created by deutschmann on 08.02.18
--
-- Module: Register-File
--
-- Slave Module. Consists of 31 general purpose 32-bit registers. r0 always contains the value 0.
-- Access Modes: READ and WRITE.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use work.SCAM_Model_types.all;

entity Regs is
port(    
    clk                   : in  std_logic;
    rst                   : in  std_logic;
    CtlToRegs_port        : in  CtlToRegs_IF;
    CtlToRegs_port_sync   : in  bool;
    RegsToCtl_port        : out RegsToCtl_IF
    );
end Regs;


architecture Regs_arch of Regs is

             signal reg_file              : register_file;
begin
     process(clk)

     begin
     if(clk='1' and clk'event) then

         -- Reset Sequence
         if rst = '1' then

             RegsToCtl_port.contents1 <= (others => '0');
             RegsToCtl_port.contents2 <= (others => '0');
             reg_file <= (others => (others => '0'));

         else

                 -- READ or WRITE requested
                 if CtlToRegs_port_sync = true then

                    -- Perform READ
                    if    CtlToRegs_port.req = REG_RD then

                        -- Read Register 1
                        if    (CtlToRegs_port.src1 =  0) then
                            RegsToCtl_port.contents1 <= (others => '0');
                        else
                            RegsToCtl_port.contents1 <= reg_file(to_integer(CtlToRegs_port.src1));
                        end if;

                        -- Read Register 2
                        if    (CtlToRegs_port.src2 = 0) then
                            RegsToCtl_port.contents2 <= (others => '0');
                        else
                            RegsToCtl_port.contents2 <= reg_file(to_integer(CtlToRegs_port.src2));
                        end if;

                    -- Perform WRITE
                    elsif CtlToRegs_port.req = REG_WR then

                        if not (CtlToRegs_port.dst = 0) then
                            reg_file(to_integer(CtlToRegs_port.dst)) <= CtlToRegs_port.dst_data;
                        end if;

                    end if; 

                 end if;

         end if; -- RST

     end if; -- CLK

     end process;
end Regs_arch;



































