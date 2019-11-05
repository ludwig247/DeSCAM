library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.SCAM_Model_types.all;


entity MasterDummy is
port(
      	clk           	: 	in 	std_logic;
		rst          	: 	in 	std_logic;
        m_request:  out CUtoME_IF;
        m_request_sync:  in bool;
        m_request_notify: out bool;
        m_interrupt_sig: in bool;
        m_interrupt_sig_notify: in bool;
        m_response: in MEtoCU_IF;
        m_response_sync: in bool;
        m_response_notify: out bool
);
end MasterDummy;



architecture m_arch of MasterDummy is

type M_dummy_sections is (CONTROL1, CONTROL2, INTERRUPT1, INTERRUPT2, INTERRUPT3, READ1, READ2, SEND1, SEND2, CLEARIP1, CLEARIP2);

signal section : M_dummy_sections;
signal cr_reg  : unsigned (31 downto 0);
signal cr_addr : unsigned (31 downto 0);
signal mask    : ME_MaskType;
signal run     : int;
signal resp_data : unsigned(31 downto 0);

begin

process(clk)
   begin
      if(clk='1' and clk'event) then
		if rst = '1' then
		  m_request_notify <= false;
		  m_response_notify <= false;
		  cr_reg <= to_unsigned(522, 32);   --RE, RXNEIE, EVEN PARITY, NO CLK DIV
		  cr_addr <= to_unsigned(0,32); --cr base address
		  mask <= MT_W;
		  run <= 0;
		  section <= CONTROL1;
		 
	  else
		   
		if(section = CONTROL1) then
		  m_request.addrIn <= cr_addr;
		  m_request.dataIn <= cr_reg;
		  m_request.req <= ME_WR;
		  m_request.mask <= mask;  
		  m_request_notify <= true;     
		  section <= CONTROL2;  
		end if;

		if(section = CONTROL2) then 
		  if(m_request_sync <= true) then
		    m_request_notify <= false;
		    section <= INTERRUPT1;
		    run <= run + 1;
		  end if;
		end if;
		 
		if(section = INTERRUPT1) then   
		  if(m_interrupt_sig_notify = true) then
		    m_request.addrIn <= to_unsigned(4, 32);   --status register
		    m_request.dataIn <= to_unsigned(0,32);
		    m_request.req <= ME_RD;
		    m_request.mask <= MT_W;  
		    m_request_notify <= true;
		    section <= INTERRUPT2;
		  end if;
		end if;
		 
		if(section = INTERRUPT2) then
		  if(m_request_sync = true) then
		    m_request_notify <= false;
		  end if; 
		  if(m_response_sync = true) then
		    m_response_notify <= true;
		    resp_data <= m_response.loadedData;
		    section <= INTERRUPT3;
		  end if;
		end if;
		 
		if(section = INTERRUPT3) then
		  m_response_notify <= false;		 
		  assert ((resp_data and to_unsigned(2,32)) /= to_unsigned(0,32)) report "IP FAIL" severity error;   
		  if(run = 1) then
		    assert ((resp_data and to_unsigned(8,32)) /= to_unsigned(0,32)) report "RXNE FAIL" severity error;
		    assert ((resp_data and to_unsigned(64,32)) = to_unsigned(0,32)) report "PARITY FAIL" severity error;
		    assert ((resp_data and to_unsigned(128,32)) = to_unsigned(0,32)) report "FRAME FAIL" severity error;
		    section <= READ1;
		  elsif(run = 2) then
		    assert ((resp_data and to_unsigned(8,32)) /= to_unsigned(0,32)) report "RXNE FAIL" severity error;
		    assert ((resp_data and to_unsigned(64,32)) = to_unsigned(0,32)) report "PARITY FAIL" severity error;
		    assert ((resp_data and to_unsigned(128,32)) = to_unsigned(0,32)) report "FRAME FAIL" severity error;   
		    section <= READ1;
		  elsif(run = 3) then
		    assert ((resp_data and to_unsigned(64,32)) /= to_unsigned(0,32)) report "PE_FLAG FAIL" severity error;
		    section <= CLEARIP1;
		  elsif(run = 4) then
		    assert ((resp_data and to_unsigned(128,32)) /= to_unsigned(0,32)) report "FE_FLAG FAIL" severity error;
		    section <= READ1; --Need to read data to clear RXNE flag 
		  elsif(run = 5) then
		    assert ((resp_data and to_unsigned(32,32)) /= to_unsigned(0,32)) report "TXE_FLAG FAIL" severity error;
		    m_request.addrIn <= to_unsigned(0,32); --cr base
		    m_request.dataIn <= to_unsigned(17,32); --TE, TCIE, NO PARITY
		    m_request.req <= ME_WR;
		    m_request.mask <= MT_W;  
		    m_request_notify <= true;
		    if(m_request_sync <= true) then
		      section <= CLEARIP1;
		    end if;
		     
		  elsif(run = 6) then
		   assert ((resp_data and to_unsigned(16,32)) /= to_unsigned(0,32)) report "TC_FLAG FAIL" severity error;
		   section <= CLEARIP1;
		  end if;
		end if;
		 
		if(section = READ1) then		    
		  m_request.addrIn <= to_unsigned(9, 32);   --RX register
		  m_request.dataIn <= to_unsigned(0,32);
		  m_request.req <= ME_RD;
		  m_request.mask <= MT_B;  
		  m_request_notify <= true;	    
		  section <= READ2;
		end if;
		 
		 
		if(section = READ2) then		   
		  if(m_request_sync = true) then
		    m_request_notify <= false;
		  end if; 
		  if(m_response_sync = true) then
		    m_response_notify <= true;
		    resp_data <= m_response.loadedData;
		    section <= CLEARIP1;
	      end if;   
		end if;
		 
		 
	    if(section = CLEARIP1) then
		  m_response_notify <= false;
		  m_request.addrIn <= to_unsigned(4, 32);   --CLEAR IP BIT
		  m_request.dataIn <= to_unsigned(0,32);
		  m_request.req <= ME_WR;
		  m_request.mask <= MT_B;  
		  m_request_notify <= true; 
		  section <= CLEARIP2;
		end if;
		 
		if(section = CLEARIP2) then   
		  if(m_request_sync = true) then	   
		    m_request_notify <= false;
		    if(run = 1) then
		      assert(resp_data = to_unsigned(85, 32)) report "Wrong data" severity error;
		      mask <= MT_B;
		      cr_addr <= to_unsigned(1,32); --cr base + 1
		      cr_reg <= to_unsigned(1,32); --ODD PARITY
		      section <= CONTROL1;
		    elsif(run = 2) then
		      assert(resp_data = to_unsigned(15, 32)) report "Wrong data" severity error;
		      mask <= MT_H;
		      cr_addr <= to_unsigned(0,32); --cr base 
		      cr_reg <= to_unsigned(578,32); --RE, PEIE, EVEN PARITY
		      section <= CONTROL1;
		    elsif(run = 3) then
		      mask <= MT_H;
		      cr_addr <= to_unsigned(0,32); --cr base 
		      cr_reg <= to_unsigned(130,32); --RE, FEIE, NO PARITY
		      section <= CONTROL1;
		    elsif(run = 4) then
		      mask <= MT_H;
		      cr_addr <= to_unsigned(0,32); --cr base 
		      cr_reg <= to_unsigned(33,32); --TE, TXEIE, NO PARITY
		      section <= CONTROL1;
		    elsif(run = 5) then    
		      section <= SEND1;
			  run <= 6;
		    elsif(run = 6) then
		      mask <= MT_W;
		      cr_addr <= to_unsigned(0,32); --cr base
		      cr_reg <= to_unsigned(522, 32);   --RE, RXNEIE, EVEN PARITY, NO CLK DIV
		      run <= 0;
		      section <= CONTROL1;
		    end if;   
		  end if;
		end if;
		 
		if(section = SEND1) then
		  m_request.addrIn <= to_unsigned(8, 32);   
		  m_request.dataIn <= to_unsigned(85,32);
		  m_request.req <= ME_WR;
		  m_request.mask <= MT_B;  
		  m_request_notify <= true;    
		  section <= SEND2;
		end if;
		
		if(section = SEND2) then
		  if(m_request_sync) then
		      m_request_notify <= false;
		      section <= INTERRUPT1;
		  end if; 
		end if;
		 
		 
		 
		 end if;
    end if;
    
 end process;
 
 end m_arch;
