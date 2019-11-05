library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;

entity TX is
port(	
	clk:		in std_logic;
    baud_clk:       in std_logic;
	rst:		in std_logic;
	TX_flags_out:		out unsigned(1 downto 0);
	TX_flags_out_notify:	 out bool;
	TX_pin:		out unsigned(0 downto 0);
	TX_pin_notify:	 out bool;
	tx_from_ctrl:		in tx_data
);
end TX;

architecture TX_arch of TX is
signal section: TX_SECTIONS;
signal TX_shiftreg_signal:unsigned(10 downto 0);
signal regs_signal:tx_data;
signal strt:bool;
signal load: bool;
signal loaded: bool;
signal cnt:unsigned(3 downto 0);
signal TX_temp:unsigned(10 downto 0);
                                  
begin

	 process(clk)
	 begin
	  if(clk='1' and clk'event) then
	   if(rst = '1') then
		  section <=IDLE1;
	      TX_flags_out_notify <= false;
		  TX_pin_notify <= false;
		  load <= false;
          strt<= false;
          TX_temp <= to_unsigned(0,11);
	   else

        if(loaded = true) then
           load <= false;
        end if;
        
	    if(section = IDLE1) then
		   regs_signal <= tx_from_ctrl;
           if(tx_from_ctrl.r_act = TX_WR) then
              TX_flags_out_notify <= true;
              TX_flags_out <= to_unsigned(1,2); --notify TXE
			  load <= true; --Need immediate notification for onespin, and stored notification for baudrate < clk 
              section <= IDLE2;
              TX_temp <= tx_from_ctrl.tx_reg(10 downto 0); --needed because of slower baudrate to secure correct behaviour of TXE flag
           end if;                               
		end if;

        if(section = IDLE2) then
           section <= START;
           TX_flags_out_notify <= false;
           strt <= true; -- Transfer will commence when value is loaded to shiftregister.
        end if;

		if(section = START) then      
           section <= START2;
		end if;

        if(section = START2) then
         if(cnt >= to_unsigned(10,4))then
            section <= SEND;
            strt <= false;
            TX_pin_notify <= true; --This is not part of uart spec, ideally remove if it doesnt ruin completeness.
         end if;
        end if;

		if(section = SEND) then
		   section <= STOP;
           TX_flags_out <= to_unsigned(2,2); --Notify TC
           TX_flags_out_notify <= true;
           TX_pin_notify <= false;
		end if;

		if(section = STOP) then
		   section <= IDLE1;
           TX_flags_out_notify <= false;
		end if;
	   end if;
	  end if;
	 end process;

         process(baud_clk)
         begin
		  if(baud_clk='0' and baud_clk'event) then -- Due to baudrate module being reset simultaneously to baud_clk = 0 we need a low edge baud_clk for toplevel 
		   if(rst = '1') then
              TX_shiftreg_signal <= to_unsigned(0,11);
              cnt <= to_unsigned(0,4);
              TX_pin <= to_unsigned(1,1);
			  loaded <= false;
		   end if;
		  end if;
		 
          if(baud_clk='1' and baud_clk'event) then
           if(rst = '1') then                   -- Still need high edge for onespin to synchronize reset with process clk
              TX_shiftreg_signal <= to_unsigned(0,11);
              cnt <= to_unsigned(0,4);
              TX_pin <= to_unsigned(1,1);
	          loaded <= false;
           else 
            if(((section = IDLE1) and (tx_from_ctrl.r_act = TX_WR)) or ((load = true) and (loaded = false))) then --many conditions needed for both properties to hold and for baudrate < clkrate to work
             if(section = IDLE1) then
                TX_shiftreg_signal <= tx_from_ctrl.tx_reg(10 downto 0); --load value directly from port
             else
                TX_shiftreg_signal <= TX_temp; -- After section > IDLE1 port may legally be written with a new value, need temporary register. 
             end if;   
                loaded <= true;
             elsif((strt = true) and (loaded <= true)) then     
                cnt <= cnt + to_unsigned(1,4);
                TX_pin <= TX_shiftreg_signal(0 downto 0);
                TX_shiftreg_signal(9 downto 0) <= TX_shiftreg_signal(10 downto 1);  --Right shift values out on TX_pin
                TX_shiftreg_signal(10 downto 10) <= TX_shiftreg_signal(0 downto 0);
                if(cnt >= to_unsigned(9,4))then
                   loaded <= false;
                end if;
             else
                cnt <= to_unsigned(0,4);
                TX_pin <= to_unsigned(1,1); -- TX_pin held high when idle
             end if;
            end if;
          end if; 
         end process;


end TX_arch;
