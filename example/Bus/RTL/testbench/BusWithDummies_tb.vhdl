library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.SCAM_Model_types.all;

-- leere entity
entity BusWithDummies_tb is
end entity BusWithDummies_tb;

architecture bhv of BusWithDummies_tb is

  -- Moduldeklaration
  component BusWithDummies is
    port (
      clk   : in std_logic;
      rst : in std_logic
    );
  end component;

  -- input
  signal clk   : std_logic := '0';
  signal reset : std_logic := '1';

begin


  -- Modulinstatziierung
  DUT: BusWithDummies
  port map (
      clk     => clk,
      rst     => reset
  );
      
 clk_proc: process 
   begin
  clk   <= not clk;


  wait for 20 ns;  -- 25 MHz Taktfrequenz
 end process  ;   

 reset_proc: process
    begin
    wait for 100 ns;
    reset <= '0'; -- erzeugt Resetsignal: --__
    wait;
  end process;
end architecture;
