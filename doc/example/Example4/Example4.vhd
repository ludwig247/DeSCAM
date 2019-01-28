package SCAM_Model_types is
subtype bool is Boolean;
subtype int is Integer;
type Example4_SECTIONS is (idle,read,write_true);
end package SCAM_Model_types;

library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;

entity Example4 is
port(	
    clk:                in std_logic;
    rst:                in std_logic;
    master_in1:         in bool;
    master_in1_sync:    in bool;
    master_in1_notify:  out bool;	
    master_in2:         in bool;
    master_in2_sync:    in bool;
    master_in2_notify:  out bool;
    report_out:         out bool;
    report_out_sync:    in bool;
    report_out_notify:  out bool;
    value_in:           in int;
    value_in_sync:      in bool;
    value_in_notify:    out bool);
end Example4;


architecture Example4_arch of Example4 is
signal section: Example4_SECTIONS;
signal value_signal:bool;
signal var_signal:int;
begin
    process(clk)
    begin
        if(clk='1' and clk'event) then
            if rst = '1' then
                section <=idle;
                value_signal<=false;
                var_signal<=10;
                master_in1_notify <= false;
                master_in2_notify <= false;
                report_out_notify <= true;
                report_out <= false;
                value_in_notify <= false;
            else
                if section = idle then
                    section <= read;
                    report_out_notify <= false;
                    value_in_notify <= true;
                end if;
                if section = read then
                    if(value_in_sync and not(value_signal) and not(value_in = 0)) then
                        section <= idle;
                        report_out_notify <= true;
                        report_out <= false;
                        value_in_notify <= false;
                        var_signal <= value_in;
                    end if;
                    if(not(value_in_sync) and not(value_signal) and not(var_signal = 0)) then
                        section <= idle;
                        report_out_notify <= true;
                        report_out <= false;
                        value_in_notify <= false;
                    end if;
                    if(value_in_sync and value_in = 0 and not(master_in1)) then
                        section <= idle;
                        report_out_notify <= true;
                        report_out <= false;
                        value_in_notify <= false;
                        var_signal <= value_in;
                        value_signal <= master_in1;
                    end if;
                    if(not(value_in_sync) and (var_signal = 0) and not(master_in1)) then
                        section <= idle;
                        report_out_notify <= true;
                        report_out <= false;
                        value_in_notify <= false;
                        value_signal <= master_in1;
                    end if;
                    if(value_in_sync and value_signal and not(value_in = 0)) then
                        section <= write_true;
                        report_out_notify <= true;
                        report_out <= true;
                        value_in_notify <= false;
                        var_signal <= value_in;
                    end if;
                    if(not(value_in_sync) and value_signal and not(var_signal = 0)) then
                        section <= write_true;
                        report_out_notify <= true;
                        report_out <= true;
                        value_in_notify <= false;
                    end if;
                    if(value_in_sync and value_in = 0 and master_in1) then
                        section <= write_true;
                        report_out_notify <= true;
                        report_out <= true;
                        value_in_notify <= false;
                        var_signal <= value_in;
                        value_signal <= master_in1;
                    end if;
                    if(not(value_in_sync) and (var_signal = 0) and master_in1) then
                        section <= write_true;
                        report_out_notify <= true;
                        report_out <= true;
                        value_in_notify <= false;
                        value_signal <= master_in1;
                    end if;
                end if;
                if section = write_true then
                    section <= idle;
                    report_out_notify <= true;
                    report_out <= false;
                    value_in_notify <= false;
                end if;
            end if;
        end if;
    end process;
end Example4_arch;
