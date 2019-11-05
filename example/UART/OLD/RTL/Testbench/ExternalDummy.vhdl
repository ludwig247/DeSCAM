library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.SCAM_Model_types.all;


entity ExternalDummy is
port(
      	clk           	: 	in 	std_logic;
		rst          	: 	in 	std_logic;
        rxpin : in bool;
        txpin : out bool
);
end ExternalDummy;


architecture e_arch of ExternalDummy is

type E_dummy_sections is (WAITING, RUN1,  RX, PARITY, STOP, TX);

signal section : E_dummy_sections;
signal counter : int;
signal shiftreg: unsigned (7 downto 0);
signal run : int;
signal bitcount: int;
signal tx_temp : bool;
signal start : bool;


begin

process(clk)
   begin
     if(clk='1' and clk'event) then
		 if rst = '1' then
		   txpin <= true;
		   section <= WAITING;
		   counter <= 0;
		   shiftreg <= to_unsigned(0,8);
		   run <= 0;
		   bitcount <= 0;
		   start <= false;
	  else
		 
	    if(section = WAITING) then
		  counter <= counter + 1;  
		  txpin <= true;
		  if(counter = 10) then
		    run <= run + 1;
		    counter <= 0;
		    section <= RUN1;
		  end if;
		end if;
		
		if(section = RUN1) then
		  if(run = 1) then
		    txpin <= false;
		    tx_temp <= false;
		    section <= TX;
		  elsif(run = 2) then
		    txpin <= false;
		    section <= TX;
		  elsif(run = 3) then
		  	txpin <= false;
		    section <= TX;
		  elsif(run = 4) then
		    txpin <= false;
		    section <= TX;
		  elsif(run = 5) then
		    section <= RX;
		  elsif(run = 6) then
		    run <= 0;
		    section <= WAITING;
		  end if;
		
		end if;     
		
		if(section = TX) then
		  if(run = 1) then
		    if(tx_temp = true) then
		      tx_temp <= false;
		      txpin <= false;
		    else
		      tx_temp <= true;
		      txpin <= true;
		    end if;		    
		    if(bitcount = 7) then
		      section <= PARITY;
		      bitcount <= 0;
		    else
		      bitcount <= bitcount + 1;
		    end if; 
		  elsif(run = 2) then        
	        if(bitcount < 4) then
	          txpin <= true;
	        else
	          txpin <= false;
			end if;		
			if(bitcount = 7) then
		      section <= PARITY;
		      bitcount <= 0;
		    else
		      bitcount <= bitcount + 1;
		    end if; 
		  elsif(run = 3) then
		    if(bitcount = 7) then
		      section <= PARITY;
		      bitcount <= 0;
		    else
		      bitcount <= bitcount + 1;
		    end if;     
		  elsif(run = 4) then
		    if(bitcount = 7) then
		      section <= STOP;
		      bitcount <= 0;
		    else
		      bitcount <= bitcount + 1;
		    end if; 
		  end if;
		end if;       
		
		if(section = PARITY) then
		  if(run = 1) then
		    txpin <= false; --even parity
		  elsif(run = 2) then
		    txpin <= true; --odd parity
		  elsif(run = 3) then
		    txpin <= true; --parity error
		  end if;		  
		  section <= STOP;
		  
		end if;   
		 
		if(section = STOP) then
		  if(run = 1) then
		    txpin <= true; --correct stop
		  elsif(run = 2) then
		    txpin <= true; --correct stop
		  elsif(run = 3) then
		    txpin <= true; --correct stop
		  elsif(run = 4) then
		    txpin <= false; --frame error
		  end if;
		  
		  section <= WAITING;
		
		end if;
		
		if(section = RX) then
		  
		  if(rxpin = false and start = false) then
		    start <= true;
		  elsif(start = true and rxpin = true and bitcount < 8) then
		    shiftreg <= shiftreg SRL 1 or to_unsigned(128,8);
		    bitcount <= bitcount + 1;
		  elsif(start = true and rxpin = false and bitcount < 8) then
		    shiftreg <= shiftreg SRL 1;
		    bitcount <= bitcount + 1;
		  elsif(start = true and bitcount = 8) then
		    assert rxpin report "FRAME ERROR EXTERNAL" severity error;
		    assert (shiftreg = to_unsigned(85,8)) report "wrong data external" severity error;
		    start <= false;
		    bitcount <= 0;
		    shiftreg <= to_unsigned(0,8);
		    section <= WAITING;
		  end if;
		  
		  
		  
		
		end if; 
		 
		 
		 
		 end if;
    end if;
    
 end process;
 
 end e_arch;
