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
--use work.SCAM_Model_types.all;

entity Regs is
port(    
    clk                      : in  std_logic;
    rst                      : in  std_logic;
    CtlToRegs_port_dst       : in  Unsigned ( 4 downto 0);
    CtlToRegs_port_dst_data  : in  Unsigned (31 downto 0);
    CtlToRegs_port_req       : in  std_logic;
    CtlToRegs_port_src1      : in  Unsigned ( 4 downto 0);
    CtlToRegs_port_src2      : in  Unsigned ( 4 downto 0);
    CtlToRegs_port_sync      : in  std_logic;
    RegsToCtl_port_contents1 : out Unsigned (31 downto 0);
    RegsToCtl_port_contents2 : out Unsigned (31 downto 0)
    );
end Regs;


architecture Regs_arch of Regs is

             type register_file is array (1 to 31) of Unsigned (31 downto 0);
             signal reg_file              : register_file;
begin
     process(clk)


     begin
     if(clk='1' and clk'event) then

         -- Reset Sequence
         if rst = '1' then

             RegsToCtl_port_contents1 <= (others => '0');
             RegsToCtl_port_contents2 <= (others => '0');
             reg_file <= (others => (others => '0'));

         else

                 -- READ or WRITE requested
                 if CtlToRegs_port_sync = '1' then

                    -- Perform READ
                    if    CtlToRegs_port_req = '0' then

                        -- Read Register 1
                        if    (CtlToRegs_port_src1 =  0) then
                            RegsToCtl_port_contents1 <= (others => '0');
                        else
                            RegsToCtl_port_contents1 <= reg_file(to_integer(CtlToRegs_port_src1));
                        end if;

                        -- Read Register 2
                        if    (CtlToRegs_port_src2 = 0) then
                            RegsToCtl_port_contents2 <= (others => '0');
                        else
                            RegsToCtl_port_contents2 <= reg_file(to_integer(CtlToRegs_port_src2));
                        end if;

                    -- Perform WRITE
                    elsif CtlToRegs_port_req = '1' then

                        if not (CtlToRegs_port_dst = 0) then
                            reg_file(to_integer(CtlToRegs_port_dst)) <= CtlToRegs_port_dst_data;
                        end if;

                    end if; 


                 end if;

         end if; -- RST

     end if; -- CLK

     end process;
end Regs_arch;



































