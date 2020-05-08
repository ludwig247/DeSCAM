library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;

entity Tranceiver is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
      --  rx_baud_trigger:        in std_logic;
     --   tx_baud_trigger:        in std_logic;
	data_in:		in unsigned(0 downto 0);
	valid_out:		out unsigned(0 downto 0);
	data_out_notify:	 out bool;
	from_mem_if:		in CUtoME_IF;
	from_mem_if_sync:	 in bool;
	from_mem_if_notify:	 out bool;
	interrupt_out:		out bool;
	interrupt_out_notify:	 out bool;
	to_mem_if:		out reg_files;
	to_mem_if_sync:	 in bool;
	to_mem_if_notify:	 out bool);
end Tranceiver;

architecture Tranceiver_arch of Tranceiver is

function check_interrupt(cr2 : unsigned (31 downto 0) ; sr1 : unsigned(31 downto 0) ; sr2 : unsigned(31 downto 0)) return unsigned is
begin

if(((cr2 and to_unsigned(1,32)) /= to_unsigned(0,32)) and ((sr1 and to_unsigned(1,32)) /= to_unsigned(0,32)) and ((sr2 and to_unsigned(1,32)) = to_unsigned(0,32))) then
 return to_unsigned(1,32);
elsif(((cr2 and to_unsigned(2,32)) /= to_unsigned(0,32)) and ((sr1 and to_unsigned(2,32)) /= to_unsigned(0,32)) and ((sr2 and to_unsigned(2,32)) = to_unsigned(0,32))) then
 return to_unsigned(1,32);
elsif(((cr2 and to_unsigned(4,32)) /= to_unsigned(0,32)) and ((sr1 and to_unsigned(4,32)) /= to_unsigned(0,32)) and ((sr2 and to_unsigned(4,32)) = to_unsigned(0,32))) then
 return to_unsigned(1,32);
elsif(((cr2 and to_unsigned(8,32)) /= to_unsigned(0,32)) and ((sr1 and to_unsigned(8,32)) /= to_unsigned(0,32)) and ((sr2 and to_unsigned(8,32)) = to_unsigned(0,32))) then
 return to_unsigned(1,32);
elsif(((cr2 and to_unsigned(16,32)) /= to_unsigned(0,32)) and ((sr1 and to_unsigned(16,32)) /= to_unsigned(0,32)) and ((sr2 and to_unsigned(16,32)) = to_unsigned(0,32))) then
 return to_unsigned(1,32);
else
 return to_unsigned(0,32);
end if;

end check_interrupt;

function registerop(addr : unsigned(31 downto 0) ; data : unsigned(31 downto 0) ; reg : unsigned(31 downto 0) ;  tag : unsigned(31 downto 0) ; mt : ME_MaskType ; rw : ME_AccessType) return unsigned is
begin

if((rw = ME_WR) and ((mt = MT_B) or (mt = MT_BU))) then
if((addr = tag)) then
return to_unsigned(0,24) & data(7 downto 0);
elsif((addr = to_unsigned(8, 32)) and (tag = to_unsigned(4,32))) then
return reg or to_unsigned(4, 32);
else 
return reg;
end if;
elsif ((rw = ME_WR) and ((mt = MT_H) or (mt = MT_HU))) then
return to_unsigned(0,32);
--if((tag >= addr) and ((tag - addr) = to_unsigned(0,32))) then
-- return (to_unsigned(0,24) & data(7 downto 0)) and to_unsigned(255,32);
--elsif((tag >= addr) and ((tag - addr) = to_unsigned(1,32))) then
-- return (to_unsigned(0,24) & data(15 downto 8)) and to_unsigned(255,32);
--elsif((addr = to_unsigned(8, 32)) and (tag = to_unsigned(4,32))) then
--return reg or to_unsigned(4, 32);
--else 
--return reg;
--end if;
elsif ((rw = ME_WR) and (mt = MT_W)) then
return to_unsigned(0,32);
elsif (rw = ME_RD) then
if((addr = to_unsigned(9,32)) and (tag = to_unsigned(4,32))) then
return reg and not(to_unsigned(1,32));
else
return reg;
end if;
else
return reg;
end if;

end registerop;

function countones(reg : unsigned(7 downto 0)) return unsigned is
begin

return (reg(0 downto 0) + reg(1 downto 1) + reg(2 downto 2) + reg(3 downto 3) + reg(4 downto 4) + reg(5 downto 5) + reg(6 downto 6) + reg(7 downto 7));

end countones;



function updateSr1(sr1 : unsigned(31 downto 0) ; rx_buff : unsigned(10 downto 0)) return unsigned is
begin

if(rx_buff(10 downto 10) = to_unsigned(0,1)) then

if(((countones(rx_buff(9 downto 2)) mod to_unsigned(2,32)) = to_unsigned(0,32)) and rx_buff(1 downto 1) = to_unsigned(0,1) and rx_buff(0 downto 0) = to_unsigned(1,1)) then
return sr1 or to_unsigned(1, 32); --RXNE flag
elsif(((countones(rx_buff(9 downto 2)) mod to_unsigned(2,32)) /= to_unsigned(0,32)) and rx_buff(1 downto 1) = to_unsigned(1,1) and rx_buff(0 downto 0) = to_unsigned(1,1)) then
return sr1 or to_unsigned(1, 32); --RXNE flag
elsif(((countones(rx_buff(9 downto 2)) mod to_unsigned(2,32)) = to_unsigned(0,32)) and rx_buff(1 downto 1) = to_unsigned(1,1) and rx_buff(0 downto 0) = to_unsigned(1,1)) then
return sr1 or to_unsigned(8, 32); --PE flag
elsif(((countones(rx_buff(9 downto 2)) mod to_unsigned(2,32)) /= to_unsigned(0,32)) and rx_buff(1 downto 1) = to_unsigned(0,1) and rx_buff(0 downto 0) = to_unsigned(1,1)) then
return sr1 or to_unsigned(8, 32); --PE flag
elsif(((countones(rx_buff(9 downto 2)) mod to_unsigned(2,32)) /= to_unsigned(0,32)) and rx_buff(1 downto 1) = to_unsigned(1,1) and rx_buff(0 downto 0) = to_unsigned(0,1)) then
return sr1 or to_unsigned(16, 32); --FE flag
elsif(((countones(rx_buff(9 downto 2)) mod to_unsigned(2,32)) = to_unsigned(0,32)) and rx_buff(1 downto 1) = to_unsigned(0,1) and rx_buff(0 downto 0) = to_unsigned(0,1)) then
return sr1 or to_unsigned(16, 32); --FE flag
else
return sr1 or to_unsigned(24, 32); --FE and PE flag
end if;
else
return sr1;
end if;


end updateSr1;

function updateRx(rx : unsigned(31 downto 0) ; rx_buff : unsigned(10 downto 0)) return unsigned is
begin

if(rx_buff(10 downto 10) = to_unsigned(0,1)) then

if(((countones(rx_buff(9 downto 2)) mod to_unsigned(2,32)) = to_unsigned(0,32)) and rx_buff(1 downto 1) = to_unsigned(0,1) and rx_buff(0 downto 0) = to_unsigned(1,1)) then
return to_unsigned(0,24) &  rx_buff(9 downto 2); -- temporary concatenation of 24 zeroes
elsif(((countones(rx_buff(9 downto 2)) mod to_unsigned(2,32)) /= to_unsigned(0,32)) and rx_buff(1 downto 1) = to_unsigned(1,1) and rx_buff(0 downto 0) = to_unsigned(1,1)) then
return to_unsigned(0,24) &  rx_buff(9 downto 2); -- temporary concatenation of 24 zeroes
else
return rx;
end if;

else
return rx;
end if;

end updateRx;

function updateSr3(sr3 : unsigned(31 downto 0) ; rx_buff : unsigned(10 downto 0)) return unsigned is
begin

if(rx_buff(10 downto 10) = to_unsigned(0,1)) then

if(((countones(rx_buff(9 downto 2)) mod to_unsigned(2,32)) = to_unsigned(0,32)) and rx_buff(1 downto 1) = to_unsigned(0,1) and rx_buff(0 downto 0) = to_unsigned(1,1)) then
return sr3;
elsif(((countones(rx_buff(9 downto 2)) mod to_unsigned(2,32)) /= to_unsigned(0,32)) and rx_buff(1 downto 1) = to_unsigned(1,1) and rx_buff(0 downto 0) = to_unsigned(1,1)) then
return sr3;
else
return to_unsigned(0,24) &  rx_buff(9 downto 2); -- temporary concatenation of 24 zeroes
end if;
else
return sr3;
end if;




end updateSr3;

  
        shared variable write_tx : bool;
        shared variable parity_tx : bool;   

signal section: Tranceiver_SECTIONS;
			 signal regs_signal:reg_files;
			 signal req_signal:bool;
			 signal request_signal:CUtoME_IF;
			 signal rx_buffer_signal:unsigned(10 downto 0);
			 signal tx_buffer_signal:unsigned(10 downto 0);
begin



	 process(clk)

         variable regs_temp : reg_files;
         

	 begin
	 if(clk='1' and clk'event) then
		 if rst = '1' then
			 section <=run0;
			regs_signal.CR1<=to_unsigned(0,32);
			regs_signal.CR2<=to_unsigned(0,32);
			regs_signal.CR3<=to_unsigned(0,32);
			regs_signal.RX<=to_unsigned(0,32);
			regs_signal.SR1<=to_unsigned(0,32);
			regs_signal.SR2<=to_unsigned(0,32);
			regs_signal.SR3<=to_unsigned(0,32);
			regs_signal.TX<=to_unsigned(0,32);
			request_signal.addrIn<=to_unsigned(0,32);
			request_signal.dataIn<=to_unsigned(0,32);
			request_signal.mask<=MT_B;
			request_signal.req<=ME_RD;
			data_out_notify <= false;
			from_mem_if_notify <= true;
			interrupt_out_notify <= false;
			to_mem_if_notify <= false;
	rx_buffer_signal<= to_unsigned(2047,11);
--tx_buffer_signal<= to_unsigned(2047,11);
		 else



		 if section = run0 then

                 regs_temp := regs_signal;

                 if(check_interrupt(regs_signal.CR2, regs_signal.SR1, regs_signal.SR2) /= to_unsigned(0,32)) then
                   if(regs_signal.SR2 = to_unsigned(0,32)) then
                     interrupt_out <= true;
                     interrupt_out_notify <= true;
                   else
                     interrupt_out <= false;
                     interrupt_out_notify <= false; 
                   end if;
                    regs_temp.SR2 := regs_temp.SR2 or (regs_signal.SR1 and regs_signal.CR2);
                 end if;                   

                  if((regs_signal.SR1 and to_unsigned(4,32)) /= to_unsigned(0,32)) then
                   regs_temp.SR1(2 downto 2) := to_unsigned(0,1); -- TXNE = 0
                  write_tx := true;
                   if( (countones(regs_signal.TX(7 downto 0)) mod to_unsigned(2, 32)) /= to_unsigned(0,32)) then
                      parity_tx := true;
                     tx_buffer_signal <= to_unsigned(3,2)  & regs_signal.TX(7 downto 0) & to_unsigned(0,1); 
                   else 
                      tx_buffer_signal <= to_unsigned(2,2)  & regs_signal.TX(7 downto 0) & to_unsigned(0,1); 
                 end if;
                  else
                     tx_buffer_signal(9 downto 0) <= tx_buffer_signal(10 downto 1);  
                     tx_buffer_signal(10 downto 10) <= to_unsigned(1,1);        
                  end if;
                  
                  regs_temp.SR1 := updateSr1(regs_temp.SR1, rx_buffer_signal);
                  regs_temp.RX := updateRx(regs_temp.RX, rx_buffer_signal);
                  regs_temp.SR3 := updateSr3(regs_temp.SR3, rx_buffer_signal);

                   if(from_mem_if_sync) then                  
                    regs_temp.CR1 := registerop(from_mem_if.addrIn, from_mem_if.dataIn, regs_temp.CR1, to_unsigned(0,32), from_mem_if.mask, from_mem_if.req);
                    regs_temp.CR2 := registerop(from_mem_if.addrIn, from_mem_if.dataIn, regs_temp.CR2, to_unsigned(1,32), from_mem_if.mask, from_mem_if.req);
                    regs_temp.CR3 := registerop(from_mem_if.addrIn, from_mem_if.dataIn, regs_temp.CR3, to_unsigned(2,32), from_mem_if.mask, from_mem_if.req);
                    regs_temp.SR1 := registerop(from_mem_if.addrIn, from_mem_if.dataIn, regs_temp.SR1, to_unsigned(4,32), from_mem_if.mask, from_mem_if.req);
                    regs_temp.SR2 := registerop(from_mem_if.addrIn, from_mem_if.dataIn, regs_temp.SR2, to_unsigned(5,32), from_mem_if.mask, from_mem_if.req);
                    regs_temp.SR3 := registerop(from_mem_if.addrIn, from_mem_if.dataIn, regs_temp.SR3, to_unsigned(6,32), from_mem_if.mask, from_mem_if.req);
                    regs_temp.TX := registerop(from_mem_if.addrIn, from_mem_if.dataIn, regs_temp.TX, to_unsigned(8,32), from_mem_if.mask, from_mem_if.req);
                    regs_temp.RX := registerop(from_mem_if.addrIn, from_mem_if.dataIn, regs_temp.RX, to_unsigned(9,32), from_mem_if.mask, from_mem_if.req);
                   end if;	

                 regs_signal <= regs_temp;
                 to_mem_if <= regs_temp;

                 from_mem_if_notify <= false;
                 to_mem_if_notify <= true;
                 data_out_notify <= true;
                 section <= run4;
		 end if;



                     rx_buffer_signal(10 downto 10) <= data_in;
                     rx_buffer_signal(9 downto 0) <= rx_buffer_signal(10 downto 1);

             --     valid_out <= tx_buffer_signal(0 downto 0);
              --    tx_buffer_signal(9 downto 0) <= tx_buffer_signal(10 downto 1);
               --    tx_buffer_signal(10 downto 10) <= to_unsigned(1,1);

  

                 if section = run4 then
	
                     tx_buffer_signal(9 downto 0) <= tx_buffer_signal(10 downto 1);  
                     tx_buffer_signal(10 downto 10) <= to_unsigned(1,1);     

                 to_mem_if_notify <= false;
                 interrupt_out_notify <= false;
                 interrupt_out <= false;
                 from_mem_if_notify <= true;
                 data_out_notify <= false;
                 section <= run0;
		 end if;


		 end if;
	 end if;
	 end process;


			
  --       process(rx_baud_trigger)
  --       begin
  --         if(rx_baud_trigger='1' and rx_baud_trigger'event) then
  --                if(rst = '1') then
  --                   rx_buffer_signal<= to_unsigned(2047,32);
  --                else
  --                   rx_buffer_signal(0 downto 0) <= data_in;
  --                   rx_buffer_signal(31 downto 1) <= rx_buffer_signal(30 downto 0);
  --                end if;           

   --        end if;
  --       end process;


     


         process(clk)
         begin
           if(clk='1' and clk'event) then
                  if(rst = '1') then
                     tx_buffer_signal<= to_unsigned(2047,11);
         --         elsif(((regs_signal.SR1 and to_unsigned(4,32)) /= to_unsigned(0,32)) and ((countones(regs_signal.TX(7 downto 0)) mod to_unsigned(2, 32)) /= to_unsigned(0,32))) then
         --            valid_out <= tx_buffer_signal(0 downto 0);
         --            tx_buffer_signal <= to_unsigned(3,2)  & regs_signal.TX(7 downto 0) & to_unsigned(0,1);
         --         elsif(((regs_signal.SR1 and to_unsigned(4,32)) /= to_unsigned(0,32)) and ((countones(regs_signal.TX(7 downto 0)) mod to_unsigned(2, 32)) = to_unsigned(0,32))) then
         --            valid_out <= tx_buffer_signal(0 downto 0);
         --            tx_buffer_signal <= to_unsigned(2,2)  & regs_signal.TX(7 downto 0) & to_unsigned(0,1);
                  else
                     valid_out <= tx_buffer_signal(0 downto 0);
                   --  tx_buffer_signal(9 downto 0) <= tx_buffer_signal(10 downto 1);  
                   --  tx_buffer_signal(10 downto 10) <= to_unsigned(1,1);
                  end if;      
           end if;
         end process;




end Tranceiver_arch;
