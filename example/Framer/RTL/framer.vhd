library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


ENTITY framer IS
  port (
    clk          : IN   std_logic;
    reset_n      : IN   std_logic;
    
    data_in      : IN   std_logic_vector(7 DOWNTO 0);
    data_word    : OUT  std_logic_vector(7 DOWNTO 0);
    word_ID      : OUT  std_logic_vector(5 DOWNTO 0);
	  frame_pulse  : OUT  std_logic;
	  synchronized : OUT  std_logic
	);
END framer;



ARCHITECTURE framer_rtl OF framer IS
  CONSTANT FRAMEMARK_C : std_logic_vector(15 DOWNTO 0) := x"A738";
  SIGNAL data_buffer   : std_logic_vector(22 DOWNTO 0);
  SIGNAL alignment     : natural RANGE 0 to 7;
  SIGNAL prev_alignment: natural RANGE 0 to 7;
  SIGNAL frame_start   : std_logic;
  SIGNAL prev_miss     : std_logic;
  SIGNAL frame_cnt_int : unsigned(5 downto 0);
  SIGNAL synchronized_int  : std_logic;
  SIGNAL sync_hit      : std_logic;
BEGIN
  
  word_ID <= std_logic_vector(frame_cnt_int);

  FramemarkSearch: PROCESS(reset_n,clk)
	  VARIABLE found_v : std_logic;
	  VARIABLE alignment_v  : natural RANGE 0 to 7; 
	BEGIN
	  IF reset_n = '0' THEN
		  alignment <= 0;
		  frame_start <= '0';
	  ELSIF clk'event AND clk='1' THEN
		  found_v := '0';
		  alignment_v := alignment;
		  FOR i IN 0 to 7 LOOP
		    IF data_buffer(i+15 DOWNTO i) = FRAMEMARK_C THEN
			    found_v := '1';
			    alignment_v := i;
		    END IF;
		  END LOOP;
	  
		  frame_start <= found_v;
		  alignment <= alignment_v;
		
	  END IF;
END PROCESS FramemarkSearch;


	DataBuffering : PROCESS(reset_n,clk)
	BEGIN
	  IF reset_n = '0' THEN
		  data_buffer <= (others => '0');
	  ELSIF clk'event AND clk='1' THEN
		  data_buffer(22 DOWNTO 16) <= data_buffer(14 DOWNTO 8);
		  data_buffer(15 DOWNTO 8) <= data_buffer(7 DOWNTO 0);
		  data_buffer(7 DOWNTO 0) <= data_in;
	  END IF;
	END PROCESS DataBuffering;

	data_word <= data_buffer((prev_alignment+7) downto prev_alignment);


	FrameCounter: PROCESS(reset_n,clk)
	BEGIN
      IF reset_n = '0' THEN
		frame_cnt_int <= to_unsigned(0,frame_cnt_int'LENGTH);
      ELSIF clk'event AND clk='1' THEN
        IF frame_start = '1' and prev_miss='1' and synchronized_int='0' THEN
		frame_cnt_int <= to_unsigned(3,frame_cnt_int'LENGTH);
		ELSE
		frame_cnt_int <= frame_cnt_int + 1; 
		END IF;
	  END IF;
	END PROCESS FrameCounter;
	
	frame_pulse_p: PROCESS(reset_n,clk)
	BEGIN
	  IF reset_n = '0' THEN
	    frame_pulse <= '0';
	  ELSIF clk'event AND clk='1' THEN
	    IF frame_cnt_int="000011" THEN
		  frame_pulse <= '1';
		ELSE
		  frame_pulse <= '0';
		END IF;
	  END IF;
	END PROCESS frame_pulse_p;
	
	
	
	sync_hit <= '1' WHEN frame_cnt_int = 2 AND prev_alignment = alignment AND frame_start='1'
	                ELSE '0';	

	InFrame: PROCESS(reset_n,clk)
	BEGIN
	  IF reset_n = '0' THEN
		  synchronized_int <= '0';
		  prev_miss    <= '1';
		  prev_alignment <= 0;
	  ELSIF clk'event AND clk='1' THEN
	    
	    IF prev_miss = '1' AND synchronized_int = '0' AND frame_start = '1' THEN
	      prev_alignment <= alignment;
	      prev_miss <= '0';
		
		ELSIF prev_miss = '0' AND synchronized_int = '0' AND sync_hit='1' THEN
		  synchronized_int <= '1';
		ELSIF prev_miss = '0' AND synchronized_int = '0' AND frame_cnt_int=2 THEN
		  prev_miss <= '1';
		
		ELSIF prev_miss = '0' AND synchronized_int = '1' AND (sync_hit='0' AND frame_cnt_int=2) THEN
		  prev_miss <='1';
		  
		ELSIF prev_miss = '1' AND synchronized_int = '1' AND sync_hit='1' THEN
		  prev_miss <='0';
		ELSIF prev_miss = '1' AND synchronized_int = '1' AND frame_cnt_int=2 THEN
		  synchronized_int <= '0';
		  
	    END IF;
	    		  
	  END IF;
	END PROCESS InFrame;
	
	synchronized <= synchronized_int;

END framer_rtl;






