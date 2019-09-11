package SCAM_Model_types is
subtype bool is Boolean;
subtype int is Integer;
end package SCAM_Model_types;

library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;

entity Example3 is
port(	
    clk:                    in std_logic;
    rst:                    in std_logic;
    master_out1:            out bool;
    master_out1_sync:       in bool;
    master_out1_notify:     out bool;
    value_in:               in int;
    value_in_sync:          in bool;
    value_in_notify:        out bool);
end Example3;


architecture Example3_arch of Example3 is
signal var_signal:int;
begin
    process(clk)
    begin
        if(clk='1' and clk'event) then
            if rst = '1' then
                var_signal<=10;
                master_out1_notify <= false;
                value_in_notify <= true;
                master_out1 <= false;
            else
                if value_in_sync then
                    if(value_in = 0) then
                        master_out1 <= true;
                        var_signal <= value_in;
                        master_out1_notify <= true;
                        value_in_notify <= true;
                    else
                        master_out1 <= false;
                        var_signal <= value_in;
                        master_out1_notify <= true;
                        value_in_notify <= true;
                    end if;
                else
                    if(var_signal = 0) then
                        master_out1 <= true;
                        var_signal <= var_signal;
                        master_out1_notify <= true;
                        value_in_notify <= true;
                    else
                        master_out1 <= false;
                        var_signal <= var_signal;
                        master_out1_notify <= true;
                        value_in_notify <= true;
                    end if;
                end if;
            end if;
        end if;
    end process;
end Example3_arch;
