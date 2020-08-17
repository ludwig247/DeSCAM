library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.SCAM_Model_types.all;
use IEEE.math_real.all;

entity Regfile is
  port(
  clk                       : in std_logic;
  rst				        : in std_logic;
  Regs_to_Control	        : out int_array;
  Control_to_Regs_data      : in signed(31 downto 0);
  Control_to_Regs_address   : in unsigned(4 downto 0);
  Control_sync              : in bool;
  Control_notify            : out bool
  );
end Regfile;

architecture Regfile_arch of Regfile is
  --Signals

  begin
    behaviour : process(clk)
    begin
      if(clk='1' and clk'event) then
        if rst = '1' then
            Regs_to_Control <= (others => to_signed(0,32));
            Control_notify <= false;
        else
            Control_notify <= false;
            --Write
            if Control_sync = true then
                Regs_to_Control(to_integer(Control_to_Regs_address)) <= Control_to_regs_data;
                Control_notify <= true;
            end if;
        end if;
      end if;
    end process behaviour;
  end Regfile_arch;
