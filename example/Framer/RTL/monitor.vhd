library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--entity monitoring
--
--  lof
--    conf. regs for different modes and different set reset values
--	  conf. regs are written by an interface to uP serially.
--
--  oofese
--  lofese
--    set or unset, during some interval
--	  kept for next interval
--	  interval defined by period_pulse

ENTITY monitor IS
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
END monitor;

ARCHITECTURE monitor_rtl OF monitor IS
  SIGNAL if_cnt  : natural RANGE 0 to 15;
  SIGNAL oof_cnt : natural RANGE 0 to 15;
  
  SIGNAL oof_period_cur : std_logic;
  SIGNAL lof_period_cur : std_logic;
  
  SIGNAL lof_int : std_logic;

  TYPE uP_if_state_t is (idle, write_lof_set, write_lof_reset);
  SIGNAL uP_if_state : uP_if_state_t;
  SIGNAL uP_if_counter : natural RANGE 0 to 4;
  SIGNAL uP_buffer : std_logic_vector(3 DOWNTO 0);
  SIGNAL uP_serial_done : std_logic; --added to fix bug
  SIGNAL lof_set   : natural RANGE 0 to 15;
  SIGNAL lof_reset : natural RANGE 0 to 15;
BEGIN

  -- serial interface to uP for writing new values to the configuration registers
  -- protocol:
  --   lof_set:    1010 4bits = lof_set
  --   lof_reset:  1001 4bits = lof_reset
  
  uP_shif_reg:PROCESS(reset_n, clk)
  BEGIN
    IF reset_n = '0' THEN
      uP_buffer <= (others=>'0');
	ELSIF clk'event AND clk='1' THEN
	  IF uP_serial_done='1' THEN
	    uP_buffer <= (others=>'0');
	  ELSE
	    uP_buffer(3) <= uP_buffer(2);
	    uP_buffer(2) <= uP_buffer(1);
	    uP_buffer(1) <= uP_buffer(0);
	    uP_buffer(0) <= uP_serial;
	  END IF;
	END IF;
  END PROCESS uP_shif_reg;
  
  uP_counter:PROCESS(reset_n, clk)
  BEGIN
    IF reset_n = '0' THEN
      uP_if_counter <= 0;
	ELSIF clk'event AND clk='1' THEN
	  IF uP_if_state = idle THEN
	    uP_if_counter <= 0;
	  ELSE
	    uP_if_counter <= uP_if_counter + 1;
	  END IF;
	END IF;
  END PROCESS uP_counter;
  
  
  uP_if: PROCESS(reset_n,clk)
  BEGIN
    IF reset_n = '0' THEN
	  uP_if_state <= idle;
	  uP_serial_done <= '0';
	  lof_set <= 8;
	  lof_reset <= 8;
	ELSIF clk'event AND clk='1' THEN
	  uP_serial_done <= '0';
	  IF uP_if_state = idle THEN
	    IF    uP_buffer = "1010" AND uP_serial_done='0' THEN
		  uP_if_state <= write_lof_set;
	    ELSIF uP_buffer = "1001" AND uP_serial_done='0' THEN
		  uP_if_state <= write_lof_reset;
	    END IF;
	  ELSIF uP_if_state = write_lof_set AND uP_if_counter = 3 THEN
	    lof_set <= to_integer(unsigned(uP_buffer));
		uP_serial_done <= '1';
		uP_if_state <= idle;
	  ELSIF uP_if_state = write_lof_reset AND uP_if_counter = 3 THEN
	    lof_reset <= to_integer(unsigned(uP_buffer));
		uP_serial_done <= '1';
		uP_if_state <= idle;
	  END IF;
	END IF;
  END PROCESS uP_if;
  
  
  
  
  
  lof <= lof_int;
  lof_fsm: PROCESS(reset_n,clk) --CONSIDER COMB PROCESS
  BEGIN
	  IF reset_n = '0' THEN
	    lof_int <= '0';
	    if_cnt <= 0;
		oof_cnt <= 0;
	  ELSIF clk'event AND clk='1' THEN
		  IF frame_pulse='1' AND synchronized='0' THEN
		    if_cnt <= 0;
		    IF oof_cnt >= lof_set THEN
			    lof_int <= '1';
		    ELSE
			    oof_cnt <= oof_cnt+1;
		    END IF;
		  ELSIF frame_pulse='1' AND synchronized='1' THEN
		    oof_cnt <= 0;
		    IF if_cnt >= lof_reset THEN
		      lof_int <= '0';
			  oof_cnt <= 0;
		    ELSE
		      if_cnt <= if_cnt+1;
		    END IF;
		  END IF;
	  END IF;
	END PROCESS lof_fsm;

  
  
  
  periode_update: PROCESS(reset_n, clk)
  BEGIN
	  IF reset_n = '0' THEN
	    oof_period <= '0';
		lof_period <= '0';
		oof_period_cur <= '0';
		lof_period_cur <= '0';
	  ELSIF clk'event AND clk='1' THEN
	    IF period_pulse='1' THEN
		  oof_period <= oof_period_cur;
		  lof_period <= lof_period_cur;
          oof_period_cur <= '0';
		  lof_period_cur <= '0';
		ELSE
		  IF synchronized='0' THEN
		    oof_period_cur <= '1';
		  END IF;
		  IF lof_int='1' THEN
		    lof_period_cur <= '1';
		  END IF; 
		END IF;
	  END IF;
	END PROCESS periode_update;

  
  
END monitor_rtl;
