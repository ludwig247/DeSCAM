package SCAM_Model_types is
subtype bool is Boolean;
subtype int is Integer;
end package SCAM_Model_types;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SCAM_Model_types.all;


ENTITY top IS
PORT (
	clk			 : IN  std_logic;
	reset_n		 : IN  std_logic;
	
  data_in   : IN  std_logic_vector(7 DOWNTO 0);
  data_word    : OUT std_logic_vector(7 DOWNTO 0);
  frame_pulse  : OUT std_logic;
  word_ID      : OUT std_logic_vector(5 DOWNTO 0);
	synchronized : OUT std_logic;
	
	period_pulse : IN  std_logic;
	uP_serial    : IN  std_logic;
	lof          : OUT std_logic; -- los of frame
	oof_period   : OUT std_logic; -- out of frame period
	lof_period   : OUT std_logic  -- los of frame period

	);
END;


ARCHITECTURE top_rtl OF top IS

  COMPONENT framer IS
  port (
    clk          : IN   std_logic;
    reset_n      : IN   std_logic;
    
    data_in   : IN   std_logic_vector(7 DOWNTO 0);
    data_word    : OUT  std_logic_vector(7 DOWNTO 0);
    word_ID      : OUT  std_logic_vector(5 DOWNTO 0);
    frame_pulse  : OUT  std_logic;
    synchronized : OUT  std_logic
  );
   END COMPONENT framer;

  COMPONENT monitor IS
  port (
    clk          : IN  std_logic;
    reset_n      : IN  std_logic;
    
    frame_pulse  : IN  std_logic;
    synchronized : IN  std_logic;
    uP_serial    : IN  std_logic;
    lof          : OUT std_logic; -- los of frame
    period_pulse : IN  std_logic;
    oof_period   : OUT std_logic; -- out of frame period
    lof_period   : OUT std_logic  -- los of frame period
  );
  END COMPONENT monitor;
	
	--- SIGNALS ---
	
	SIGNAL frame_pulse_int : std_logic;
	SIGNAL synchronized_int : std_logic;
	
BEGIN

    frame_pulse <= frame_pulse_int;
	synchronized <= synchronized_int;

    framer_comp: framer
    PORT MAP (
	    clk => clk,
	    reset_n => reset_n,
	
	    data_in => data_in,
      data_word => data_word,
	    word_ID => word_ID,
      frame_pulse => frame_pulse_int,
	    synchronized => synchronized_int
	);

	monitor_comp: monitor
    PORT MAP (
	    clk => clk,
	    reset_n => reset_n,
	
      frame_pulse => frame_pulse_int,
	    synchronized => synchronized_int,
      uP_serial => uP_serial,
	    lof => lof,
	    period_pulse => period_pulse,
	    oof_period => oof_period,
	    lof_period => lof_period
	);

END ARCHITECTURE top_rtl;
