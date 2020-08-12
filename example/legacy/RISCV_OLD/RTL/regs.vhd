--
-- Created by deutschmann on 08.02.18
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
    CtlToRegs_port_notify : out bool;
    RegsToCtl_port        : out RegsToCtl_IF;
    RegsToCtl_port_sync   : in  bool;
    RegsToCtl_port_notify : out bool);
end Regs;


architecture Regs_arch of Regs is

             signal section               : Regs_SECTIONS;
             signal CtlToRegs_data_signal : CtlToRegs_IF;
             signal RegsToCtl_data_signal : RegsToCtl_IF;
             signal reg_file              : register_file;
begin
     process(clk)

     variable cont1_temp : Unsigned (31 downto 0);
     variable cont2_temp : Unsigned (31 downto 0);

     begin
     if(clk='1' and clk'event) then

         if rst = '1' then

             section <= read;
             CtlToRegs_data_signal.dst       <= (others => '0');
             CtlToRegs_data_signal.dst_data  <= (others => '0');
             CtlToRegs_data_signal.req       <= REG_RD;
             CtlToRegs_data_signal.src1      <= (others => '0');
             CtlToRegs_data_signal.src2      <= (others => '0');
             RegsToCtl_data_signal.contents1 <= (others => '0');
             RegsToCtl_data_signal.contents2 <= (others => '0');
             reg_file <= (others => (others => '0'));
             CtlToRegs_port_notify <= true;
             RegsToCtl_port_notify <= false;
             cont1_temp := (others => '0');
             cont2_temp := (others => '0');

         else

            if section = read then

                 if CtlToRegs_port_sync = true then

                    -- Read
                    CtlToRegs_data_signal <= CtlToRegs_port;

                    if    CtlToRegs_port.req = REG_RD then

                        -- Default Values
                        cont1_temp := RegsToCtl_data_signal.contents1;
                        cont2_temp := RegsToCtl_data_signal.contents2;

                        -- Read Register 1
                        if    (CtlToRegs_port.src1 =  0) then
                            cont1_temp := (others => '0');
                        elsif (CtlToRegs_port.src1 < 32) then
                            cont1_temp := reg_file(to_integer(CtlToRegs_port.src1));
                        end if;

                        -- Read Register 2
                        if    (CtlToRegs_port.src2 = 0) then
                            cont2_temp := (others => '0');
                        elsif (CtlToRegs_port.src2 < 32) then
                            cont2_temp := reg_file(to_integer(CtlToRegs_port.src2));
                        end if;


                        CtlToRegs_port_notify <= false;

                        RegsToCtl_data_signal.contents1 <= cont1_temp;
                        RegsToCtl_data_signal.contents2 <= cont2_temp;

                        RegsToCtl_port.contents1 <= cont1_temp;
                        RegsToCtl_port.contents2 <= cont2_temp;

                        RegsToCtl_port_notify <= true;

                        section <= write;

                    elsif CtlToRegs_port.req = REG_WR then

                        if (CtlToRegs_port.dst > 0) and (CtlToRegs_port.dst < 32) then
                            reg_file(to_integer(CtlToRegs_port.dst)) <= CtlToRegs_port.dst_data;
                        end if;

                        RegsToCtl_port_notify <= false;

                        CtlToRegs_port_notify <= true;

                        section <= read;

                    end if; 

                 end if;

            elsif section = write then

                if RegsToCtl_port_sync = true then

                    RegsToCtl_port_notify <= false;

                    CtlToRegs_port_notify <= true;

                    section <= read;

                end if;

            end if; -- SECTION

         end if; -- RST

     end if; -- CLK

     end process;
end Regs_arch;



































