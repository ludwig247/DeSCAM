library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.SCAM_Model_types.all;
use IEEE.math_real.all;


entity Synchronizer is
  port(
  clk                   : in std_logic;
  rst				    : in std_logic;
  consumer			    : out signed (63 downto 0);
  consumer_sync         : in bool;
  consumer_notify       : out bool;
  producer_0            : in signed (31 downto 0);
  producer_0_sync       : in bool;
  producer_0_notify     : out bool;
  producer_1            : in signed (31 downto 0);
  producer_1_sync       : in bool;
  producer_1_notify     : out bool
  );
end Synchronizer;

architecture Synchronizer_arch of Synchronizer is
  --Signals
  signal buf     :   int_array;
  signal flags      :   bool_array;

  begin
    behaviour : process(clk)
        variable buf_temp : int_array;
        variable flags_temp : bool_array;
    begin
    if(clk='1' and clk'event) then
        if rst = '1' then
            buf <= (others => to_signed(0,32));
            flags <= (others => false);
            consumer <= (others => '0');
            consumer_notify <= false;
            producer_0_notify <= false;
            producer_1_notify <= false;
            buf_temp := (others => to_signed(0,32));
            flags_temp := (others => false);
        else
            --unset notify signals by default
            producer_0_notify <= false;
            producer_1_notify <= false;
            consumer_notify <= false;

            --copy buf and flags into variables
            buf_temp := buf;
            flags_temp := flags;

            --check if first producer wants to send
            if producer_0_sync = true then
                if flags(0) = false then
                    flags(0) <= true;
                    buf(0) <= producer_0;
                    buf_temp(0) := producer_0;
                    flags_temp(0) := true;
                    producer_0_notify <= true;
                end if;
            end if;

            --check if second producer wants to send
            if producer_1_sync = true then
                if flags(1) = false then
                    flags(1) <= true;
                    buf(1) <= producer_1;
                    buf_temp(1) := producer_1;
                    flags_temp(1) := true;
                    producer_1_notify <= true;
                end if;
            end if;

            --check if consumer wants to read
            if consumer_sync = true then
                if (flags_temp(0) = true) and (flags_temp(1) = true) then
                    flags_temp := (others => false);
                    flags <= (others => false);
                    consumer <= (buf_temp(1) & buf_temp(0));
                    consumer_notify <= true;

                    --if producers were blocked before the read, let them write now
                    if (flags(0) = true) and (producer_0_sync = true) then
                        flags(0) <= true;
                        buf(0) <= producer_0;
                        producer_0_notify <= true;
                    end if;
                    if (flags(1) = true) and (producer_1_sync = true) then
                        flags(1) <= true;
                        buf(1) <= producer_1;
                        producer_1_notify <= true;
                    end if;
                end if;
            end if;
        end if;
    end if;

    end process behaviour;
  end Synchronizer_arch;
