package SCAM_Model_types is
subtype bool is Boolean;
subtype int is Integer;
type Example1_SECTIONS is (run0, run1);
end package SCAM_Model_types;

library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;

entity Example1 is
port(	
    clk:                in std_logic;
    rst:                in std_logic;
    block_in:           in int;
    block_in_sync:      in bool;
    block_in_notify:    out bool;
    block_out:          out int;
    block_out_sync:     in bool;
    block_out_notify:   out bool;
    share_out:          out bool);
end Example1;


architecture Example1_arch of Example1 is
signal section: Example1_SECTIONS;
signal succ_cnt_signal:int;
begin
    process (clk)
    begin
        if (clk = '1' and clk'event) then
            if (rst = '1') then
                section <= run0;
                succ_cnt_signal <= 0;
                block_in_notify <= true; -- initialize read operation from the very beginning
                block_out_notify <= false; -- no output data is available in the very beginning
                share_out <= false;
            else
                if ((section = run0) and block_in_sync) then  -- wait for block_in_sync which tells that data is available
                    if (block_in <= 10) then
                        succ_cnt_signal <= 0;
                    else
                        section <= run1;
                        block_out <= (1+succ_cnt_signal);
                        succ_cnt_signal <= (1+succ_cnt_signal);
                        block_in_notify <= false; -- notify that data was read successfully
                        block_out_notify <= true; -- notify that output data is available
                    end if;
                end if;
                if (section = run1) then
                    section <= run0;
                    block_in_notify <= true; -- notify that read operation is pending
                    block_out_notify <= false; -- notify that output data is not available anymore (no need to wait for sync signal because it is non-blockig write)
                    share_out <= block_out_sync; -- block_out_sync is used as success_signal, it tells if previous non-blocking write was successful
                end if;       
            end if;
        end if;
    end process;
end Example1_arch;
