library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;

entity MasterDummy is
port(
              clk:  in std_logic;
              rst:  in std_logic;
        m_request:  out CUtoME_IF;
   m_request_sync:  in bool;
 m_request_notify:  out bool;
      m_interrupt:  in bool;
 m_interrupt_sync:  in bool;
       m_response:  in MEtoCU_IF;
  m_response_sync:  in bool;
m_response_notify:  out bool
);
end MasterDummy;

architecture m_arch of MasterDummy is 

type mdummy_sections is (ctrl1,ctrl2, intrup1, intrup2, intrup3, read1, read2, send1, send2, clrip1, clrip2, waiting);

signal section : mdummy_sections;
signal cr_reg  : unsigned(31 downto 0);
signal mask    : ME_MaskType;
signal run     : int;
signal resp_data : unsigned(31 downto 0);
signal send_data : unsigned(31 downto 0);
signal to_send : bool;
signal runcnt : int;


begin

process(clk)
  begin 
     if(clk = '1' and clk'event) then
	    if(rst = '1') then
		  m_request_notify <= false;
		  m_response_notify <= false;
		  cr_reg <= to_unsigned(65553, 32);  --TE flag, TCIE flag and clock div = 1 (we need a clock edge from baudgen)
		  mask <= MT_W;
		  run <= 1;
		  section <= ctrl1;
		  to_send <= false;
		  runcnt <= 0;

		else 
		  
		  
         --------------WRITE TO CR----------------------------------		  
		   if(section = ctrl1) then
		      m_request.addrIn <= to_unsigned(0,32); -- CR
		      m_request.dataIn <= cr_reg;
			  m_request.req <= ME_WR;
			  m_request.mask <= mask;
			  m_request_notify <= true;
			  section <= ctrl2;
		   end if;
		   
		   if(section = ctrl2) then
		      if(m_request_sync = true) then
			    m_request_notify <= false;
				if(run = 1) then
				  section <= send1;
				  send_data <= to_unsigned(255,32);
				elsif(to_send = true) then
				  section <= send1;
				  to_send <= false;
 				else
				  section <= intrup1;
				end if;
				
			  end if;
		   end if;
		   
		   
		   -------------------------WAIT FOR INTERRUPT-----------------------------------
		   
		   if(section = intrup1) then
		      if(m_interrupt_sync = true) then
			   m_request.addrIn <= to_unsigned(4,32); -- SR
		       m_request.dataIn <= to_unsigned(0,32); --dataIn is irrelevant for read
			   m_request.req <= ME_RD;
			   m_request.mask <= MT_W;
			   m_request_notify <= true;
			   section <= intrup2;
			  end if;
		   end if;
		   
		   if(section = intrup2) then
		      if(m_request_sync = true) then
			    m_request_notify <= false;
		      end if;
			  
			  if(m_response_sync = true) then
			   m_response_notify <= true;
			   resp_data <= m_response.loadedData;
			   section <= intrup3;
			  end if;

		   end if;
		   
		   if(section = intrup3) then
		     m_response_notify <= false;
			  
			 if(run = 3) then 
			   assert (resp_data(5 downto 5) = to_unsigned(1,1)) report "TXE flag should be set at run 3" severity error;
			   mask <= MT_HU;
			   cr_reg <= to_unsigned(11,32); -- switch to RE and RXNEIE, keep TE flag until transfer is finished
			   send_data <= to_unsigned(170,32);
			   section <= ctrl1; 
			   to_send <= true; ------in this case we wish to switch off TXE interrupts before clearing IP bit to prevent interrupt trigger 
			 elsif(run = 4) then
               assert (resp_data(3 downto 3) = to_unsigned(1,1)) report "RXNE flag should be set at run4" severity error;
			   assert (resp_data(7 downto 6) = to_unsigned(0,2)) report "neither PE or FE flag should be set at run 4" severity error;
			   section <= read1; -- Read RX to clear RXNE before clearing IP bit. 
			 elsif(run = 5) then
               assert (resp_data(3 downto 3) = to_unsigned(0,1)) report "RXNE flag should be set when error data at run5" severity error;
			   assert (resp_data(6 downto 6) = to_unsigned(1,1)) report "PE flag should be set at run 5" severity error;
			   section <= read1;
			 elsif(run = 6) then
               assert (resp_data(3 downto 3) = to_unsigned(0,1)) report "RXNE flag should be set when error data at run6" severity error;
			   assert (resp_data(7 downto 7) = to_unsigned(1,1)) report "FE flag should be set at run 6" severity error;
			   section <= read1;
             else 			 
			   section <= clrip1;			 
			 end if;
			  
		   end if;
		   
		   
		   --------------------------CLEAR INTERRUPT PENDING BIT--------------------------------
		   
		   if(section = clrip1) then
		       m_request.addrIn <= to_unsigned(4,32); -- SR
		       m_request.dataIn <= to_unsigned(0,32); --clears interrupt pending bit
			   m_request.req <= ME_WR;
			   m_request.mask <= MT_BU;
			   m_request_notify <= true;
			   section <= clrip2;
		   end if;
		   
		   if(section = clrip2) then
		      if(m_request_sync) then
			    m_request_notify <= false;
			  end if;
			  
			  if(run = 1) then
			    assert (resp_data(4 downto 4) = to_unsigned(1,1)) report "TC flag should be set at run1" severity error;
			    send_data <= to_unsigned(1,32);
			    section <= send1;
				run <= 2;
			  elsif(run = 2) then
			    assert (resp_data(4 downto 4) = to_unsigned(1,1)) report "TC flag should be set at run2" severity error;
			    mask <= MT_HU;
				cr_reg <= to_unsigned(33,32); -- switch to TXEIE
				section <= ctrl1;
				run <= 3;
		      elsif(run = 3) then
			    section <= intrup1;
				run <= 4;
			  elsif(run = 4) then
			    assert (resp_data(15 downto 8) = to_unsigned(87,8)) report "Correct value 87 should be in RX" severity error;
				assert (resp_data(23 downto 16) /= to_unsigned(87,8)) report "Correct value 87 should not be in fault register" severity error;
				run <= 5;
				mask <= MT_HU;
				cr_reg <= to_unsigned(66,32); -- switch to PEIE, RE, no TE
				section <= ctrl1;
			  elsif(run = 5) then
			   	assert (resp_data(15 downto 8) /= to_unsigned(15,8)) report "incorrect value 15 should not be in RX" severity error;
				assert (resp_data(23 downto 16) = to_unsigned(15,8)) report "incorrect value 15 should be in fault register" severity error;
				run <= 6;
				mask <= MT_HU;
				cr_reg <= to_unsigned(130,32); -- switch to FEIE
				section <= ctrl1;
			  	  elsif(run = 6) then
			   	assert (resp_data(15 downto 8) /= to_unsigned(248,8)) report "incorrect value 15 should not be in RX" severity error;
				assert (resp_data(23 downto 16) = to_unsigned(248,8)) report "incorrect value 15 should be in fault register" severity error;
				run <= 1;
				mask <= MT_HU;
				cr_reg <= to_unsigned(17,32); -- switch to TE, TCIE (back to run 1)
				section <= ctrl1;
				runcnt <= runcnt + 1;
				assert(runcnt <= 6) report "test over" severity failure;
			  end if;
			  
		   
		   end if;
		   
		   ---------------------------SEND DATA--------------------------------------------
		   
		   if(section = send1) then
		     m_request.addrIn <= to_unsigned(8,32); -- TX
		     m_request.dataIn <= send_data; 
			 m_request.req <= ME_WR;
			 m_request.mask <= MT_BU; --can essentially be all except MT_X because of read only registers above
			 m_request_notify <= true;
			 section <= send2;
		   end if;
		   
		   if(section = send2) then
		     if(m_request_sync = true) then
	            m_request_notify <= false;	
               if(run = 3) then
                 section <= clrip1;
               else				 
			    section <= intrup1;
			   end if;
			 end if;
		   end if;
		   
		   ------------------------READ DATA-----------------------------------------------------
		   
		   if(section = read1) then
		       m_request.addrIn <= to_unsigned(8,32); -- DR
		       m_request.dataIn <= to_unsigned(0,32); 
			   m_request.req <= ME_RD;
			   m_request.mask <= MT_W; --read whole register to verify fault register 
			   m_request_notify <= true;
		       section <= read2;
		   end if;
		   
		   if(section = read2) then
	          if(m_request_sync = true) then
			    m_request_notify <= false;
		      end if;
			  
			  if(m_response_sync = true) then
			   m_response_notify <= true;
			   resp_data <= m_response.loadedData;
			   section <= clrip1;
			  end if;
		   
		   end if;
		   
		
		end if;
	 end if;


end process;



end m_arch;