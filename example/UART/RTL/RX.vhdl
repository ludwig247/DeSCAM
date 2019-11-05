library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;

entity RX is
port(	
	clk:		in std_logic;
        baud_clk:       in std_logic;
	rst:		in std_logic;
	RX_pin:		in unsigned(0 downto 0);
	rx_to_ctrl:		out rx_data;
	rx_to_ctrl_notify:	 out bool
	);
end RX;

architecture RX_arch of RX is

function countones(reg : unsigned(31 downto 0)) return unsigned is
begin

return resize((reg(1 downto 1) and to_unsigned(1,1)),32) + resize((reg(2 downto 2) and to_unsigned(1,1)),32) + resize((reg(3 downto 3) and to_unsigned(1,1)),32) +
       resize((reg(4 downto 4) and to_unsigned(1,1)),32) + resize((reg(5 downto 5) and to_unsigned(1,1)),32) + resize((reg(6 downto 6) and to_unsigned(1,1)),32) + 
	   resize((reg(7 downto 7) and to_unsigned(1,1)),32) + resize((reg(8 downto 8) and to_unsigned(1,1)),32);

end countones;

function parity_check(count : unsigned(31 downto 0) ; parbit : unsigned(0 downto 0 )) return unsigned is
begin

if((parbit /= to_unsigned(0,1)) and ((count mod to_unsigned(2,32)) /= ZERO)) then
 return ZERO;
elsif((parbit = to_unsigned(0,1)) and ((count mod to_unsigned(2,32)) = ZERO)) then
 return ZERO;
else
 return PE_flag;
end if;

end parity_check;

function frame_check(stopbit : unsigned(0 downto 0)) return unsigned is
begin

if(stopbit /= ZERO) then
 return ZERO;
else
 return FE_flag;
end if;

end frame_check;

signal section: RX_SECTIONS;
signal RX_shiftreg_signal:unsigned(31 downto 0); --need this to be 32 bits or onespin clips value when shift_left
signal regs_signal:rx_data;
signal strt:bool;
signal cnt:unsigned(3 downto 0);
signal scanning: bool;
signal scanned: bool;

begin

	 process(clk)
	 begin
	  if(clk='1' and clk'event) then
	   if(rst = '1') then
		  section <=IDLE;
		  regs_signal.DR_reg<= (others => '0');
		  regs_signal.SR_reg<= (others => '0');
		  rx_to_ctrl_notify <= false;
		  scanning <= false;
	   else
	 
		if(scanned <= true) then
		   scanning <= false;
		end if;
		 
		 
		if(section = IDLE) then
		   section <= SCAN;
		end if;
		
		if(section = SCAN) then
      	 if(RX_pin = to_unsigned(0,1)) then
            section <= SCAN2;
			scanning <= true; --Need both immediate and stored notification of start bit to satisfy both properties and baudrate < clk
         end if;
		end if;
		           
	    if(section = SCAN2) then
         if(cnt = to_unsigned(10,4)) then  --More appropriate name of state would imply receive rather than scan
            section <= RECEIVE;
         end if;
        end if;  

		if(section = RECEIVE)then		
         if((parity_check(countones(RX_shiftreg_signal), RX_shiftreg_signal(9 downto 9)) = ZERO) and (frame_check(RX_shiftreg_signal(10 downto 10)) = ZERO)) then
             rx_to_ctrl.DR_reg <= (shift_left(RX_shiftreg_signal,7) and L1_BYTEMASK);
             rx_to_ctrl.SR_reg <= RXNE_flag;
         else	  
             rx_to_ctrl.DR_reg <= (shift_left(RX_shiftreg_signal,15) and L2_BYTEMASK);
             rx_to_ctrl.SR_reg <= parity_check(countones(RX_shiftreg_signal), RX_shiftreg_signal(9 downto 9)) or frame_check(RX_shiftreg_signal(10 downto 10));
         end if;    
             rx_to_ctrl_notify <= true;
		     section <= STOP1;
		 end if;
		 
		 if(section = STOP1) then
            rx_to_ctrl_notify <= false;
		    section <= SCAN;
		 end if;

       
		end if;
	  end if;
	 end process;

	 process(baud_clk)
	 begin
	  if(baud_clk='0' and baud_clk'event) then  --As with TX baudrate is reset simultaneously on the toplevel so we need low edge baud_clk reset to initialize outside onespin
	   if(rst = '1') then
          RX_shiftreg_signal<= (others => '0');
          strt <= false;
          cnt <= to_unsigned(0,4);
	   end if;		   
	  end if; 
		 
	  if(baud_clk='1' and baud_clk'event) then
	   if(rst = '1') then
          RX_shiftreg_signal<= (others => '0');
          strt <= false;
          cnt <= to_unsigned(0,4);
	   else 
        if((RX_pin = to_unsigned(0,1)) and (strt = false) and ((section = SCAN) or ((scanning = true) and (scanned = false)))) then --need many conditions for both properties to hold and functionality with slower baudrate
            RX_shiftreg_signal(10 downto 10) <= RX_pin;  
            RX_shiftreg_signal(9 downto 0) <= RX_shiftreg_signal(10 downto 1);
            strt <= true;
			scanned <= true; -- notify other process that data is being received.
        elsif((strt = true) and (cnt <= to_unsigned(9,4))) then
            scanned <= false; --needs to be low before other process can possibly reach section SCAN
            cnt <= cnt + to_unsigned(1,4);
            RX_shiftreg_signal(10 downto 10) <= RX_pin;
            RX_shiftreg_signal(9 downto 0) <= RX_shiftreg_signal(10 downto 1);  -- right shift in data
        elsif(cnt = to_unsigned(10,4) and (strt = true)) then
            cnt <= to_unsigned(0,4);
            strt <= false; 
        end if;
	   end if;		 
      end if;
     end process;
end RX_arch;
