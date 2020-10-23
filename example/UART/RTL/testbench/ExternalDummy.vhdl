library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;

entity ExternalDummy is
port(
clk    : in std_logic;
rst    : in std_logic;
rx_pin : in unsigned(0 downto 0);
tx_pin : out unsigned(0 downto 0)
);
end ExternalDummy;

architecture e_arch of ExternalDummy is




signal shiftreg : unsigned(10 downto 0);
signal run : int;
signal bitcnt : int;
signal start : bool;
signal clk_cnt : int;


begin 

process(clk)
 begin
   if(clk = '1' and clk'event) then
     if(rst = '1') then
	  tx_pin <= to_unsigned(1,1);
	  shiftreg <= to_unsigned(0,11);
	  run <= 1;
	  bitcnt <= 0; 
	  start <= false;
	  clk_cnt <= 0;
	 else
	  
	  
	  if(clk_cnt = 1) then --keep equal with clk_div provided by masterdummy
	   clk_cnt <= 0;
	  else
	   clk_cnt <= 1;
	  end if; 
	  
	
	  
	  
	  

	    --------------------------------RUN1---------------------------------------
		if(run = 1) then
		  
		  if((rx_pin = to_unsigned(0,1)) and (start = false)) then
		   start <= true;
		   shiftreg(10 downto 10) <= rx_pin;
		  end if;
		  
		  if((start = true) and (clk_cnt = 0) and (bitcnt < 10)) then
		    shiftreg(10 downto 10) <= rx_pin;
		    shiftreg(9 downto 0) <= shiftreg(10 downto 1);
			bitcnt <= bitcnt + 1;
		  end if;
		  
		  if(bitcnt = 10) then
		    assert (shiftreg(0 downto 0) = to_unsigned(0,1)) report "should always be startbit" severity error;
		    assert (shiftreg(8 downto 1) = to_unsigned(255,8)) report "ext should read 255 at run 1" severity error;
			assert (shiftreg(9 downto 9) = to_unsigned(0,1)) report "should not be parity bit at run1" severity error;
			assert (shiftreg(10 downto 10) = to_unsigned(1,1)) report "should always be stopbit" severity error;
		    bitcnt <= 0;
			start <= false;
			run <= 2;
		  end if;
		  
		
		end if;
		
		--------------------------------RUN2---------------------------------------
		if(run = 2) then
		  if((rx_pin = to_unsigned(0,1)) and (start = false)) then
		   start <= true;
		   shiftreg(10 downto 10) <= rx_pin;
		  end if;
		  
		  if((start = true) and (clk_cnt = 0) and (bitcnt < 10)) then
		    shiftreg(10 downto 10) <= rx_pin;
		    shiftreg(9 downto 0) <= shiftreg(10 downto 1);
			bitcnt <= bitcnt + 1;
		  end if;
		  
		  if(bitcnt = 10) then
		    assert (shiftreg(0 downto 0) = to_unsigned(0,1)) report "should always be startbit" severity error;
		    assert (shiftreg(8 downto 1) = to_unsigned(1,8)) report "ext should read 1 at run 2" severity error;
			assert (shiftreg(9 downto 9) = to_unsigned(1,1)) report "should be parity bit at run2" severity error;
			assert (shiftreg(10 downto 10) = to_unsigned(1,1)) report "should always be stopbit" severity error;
		    bitcnt <= 0;
			start <= false;
			run <= 3;
		  end if;
		  
		
		end if;
		--------------------------------RUN3---------------------------------------
		if(run = 3) then
		  if((rx_pin = to_unsigned(0,1)) and (start = false)) then
		   start <= true;
		   shiftreg(10 downto 10) <= rx_pin;
		  end if;
		  
		  if((start = true) and (clk_cnt = 0) and (bitcnt < 10)) then
		    shiftreg(10 downto 10) <= rx_pin;
		    shiftreg(9 downto 0) <= shiftreg(10 downto 1);
			bitcnt <= bitcnt + 1;
		  end if;
		  
		  if(bitcnt = 10) then
		    assert (shiftreg(0 downto 0) = to_unsigned(0,1)) report "should always be startbit" severity error;
		    assert (shiftreg(8 downto 1) = to_unsigned(170,8)) report "ext should read 170 at run 3" severity error;
			assert (shiftreg(9 downto 9) = to_unsigned(0,1)) report "should not be parity bit at run3" severity error;
			assert (shiftreg(10 downto 10) = to_unsigned(1,1)) report "should always be stopbit" severity error;
		    bitcnt <= 0;
			start <= false;
			run <= 4;
		  end if;
		  
		
		end if;
		--------------------------------RUN4---------------------------------------
		if(run = 4) then
		  
		 if(start = false) then 
              shiftreg <= to_unsigned(1,1) & to_unsigned(1,1) & to_unsigned(87,8) & to_unsigned(0,1); --stop bit = 1, parity bit = 1, data = 87, start bit = 0 	
              start <= true;			  
		 end if;
		 
		 if((start = true) and (clk_cnt = 0) and (bitcnt < 11)) then
		   tx_pin <= shiftreg(0 downto 0);
		   shiftreg(9 downto 0) <= shiftreg(10 downto 1);
		   bitcnt <= bitcnt + 1;
		 end if;
		 
		 if(bitcnt = 11) then
		   bitcnt <= 0;
		   start <= false;
		   run <= 5;
		 end if;
		
		end if;
		--------------------------------RUN5---------------------------------------
		if(run = 5) then
		  
		 if(start = false) then 
              shiftreg <= to_unsigned(1,1) & to_unsigned(1,1) & to_unsigned(15,8) & to_unsigned(0,1); --stop bit = 1, parity bit = 1 (error), data = 15, start bit = 0 	
              start <= true;			  
		 end if;
		 
		 if((start = true) and (clk_cnt = 0) and (bitcnt < 11)) then
		   tx_pin <= shiftreg(0 downto 0);
		   shiftreg(9 downto 0) <= shiftreg(10 downto 1);
		   bitcnt <= bitcnt + 1;
		 end if;
		 
		 if(bitcnt = 11) then
		   bitcnt <= 0;
		   start <= false;
		   run <= 6;
		 end if;
		
		end if;
		--------------------------------RUN6---------------------------------------
		if(run = 6) then
		  
		 if(start = false) then 
              shiftreg <= to_unsigned(0,1) & to_unsigned(1,1) & to_unsigned(248,8) & to_unsigned(0,1); --stop bit = 0 (error), parity bit = 1, data = 248, start bit = 0 	
              start <= true;			  
		 end if;
		 
		 if((start = true) and (clk_cnt = 0) and (bitcnt < 11)) then
		   tx_pin <= shiftreg(0 downto 0);
		   shiftreg(9 downto 0) <= shiftreg(10 downto 1);
		   bitcnt <= bitcnt + 1;
		 end if;
		 
		 if((bitcnt = 11) and (clk_cnt = 0)) then
		   tx_pin <= to_unsigned(1,1); -- Need to keep tx pin high while not transmitting (last bit was zero in this case)
		   bitcnt <= 0;
		   start <= false;
		   run <= 1;
		 end if;
		
		end if;
		
	  
	 
	 
	 end if;

   end if;   
 
end process;




end e_arch;