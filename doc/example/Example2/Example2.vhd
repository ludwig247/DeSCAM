package SCAM_Model_types is
subtype bool is Boolean;
subtype int is Integer;
type Example2_SECTIONS is (idle,reading);
type msg_type is record
	addr: int;
	data: int;
end record;
end package SCAM_Model_types;

library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;

entity Example2 is
port(	
    clk:                        in std_logic;
    rst:                        in std_logic;
    msg_port:                   in msg_type;
    msg_port_sync:              in bool;
    msg_port_notify:            out bool;
    new_frame_found:            in bool;
    new_frame_found_sync:       in bool;
    new_frame_found_notify:     out bool);
end Example2;


architecture Example2_arch of Example2 is
signal section: Example2_SECTIONS;
signal cnt_signal:int;
begin
    process(clk)
    begin
        if(clk='1' and clk'event) then
            if rst = '1' then
                section <=idle;
                cnt_signal<=0;
                msg_port_notify <= false;
                new_frame_found_notify <= true;
            else
                if section = idle then
                    if(new_frame_found_sync) then
                        if(new_frame_found) then
                            section <= reading;
                            cnt_signal <= cnt_signal;
                            msg_port_notify <= true;
                            new_frame_found_notify <= false;
                        else
                            section <= idle;
                            cnt_signal <= cnt_signal;
                            msg_port_notify <= false;
                            new_frame_found_notify <= true;
                        end if;
                    end if;
                end if;
                if section = reading then
                    if(msg_port_sync) then
                        if(cnt_signal <= 3) then
                            section <= reading;
                            cnt_signal <= cnt_signal +1;
                            msg_port_notify <= true;
                            new_frame_found_notify <= false;
                        else
                            section <= idle;
                            cnt_signal <= 0;
                            msg_port_notify <= false;
                            new_frame_found_notify <= true;
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;
end Example2_arch;
