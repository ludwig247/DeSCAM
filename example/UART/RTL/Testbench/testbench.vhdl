library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;

entity testbench is
end entity testbench;


architecture test of testbench is

component UART 
port(
             clk:  in std_logic;
             rst:  in std_logic;
         request:  in CUtoME_IF;
    request_sync:  in bool;
    request_notify: out bool;
         rxpin:  in unsigned(0 downto 0);
         txpin: out unsigned(0 downto 0);
  interrupt_sig: out bool;
  interrupt_sig_notify: out bool;
   response: out MEtoCU_IF;
   response_sync: in bool;
   response_notify: out bool
   );
end component;

component MasterDummy
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
end component;

component ExternalDummy
port(
clk    : in std_logic;
rst    : in std_logic;
rx_pin : in unsigned(0 downto 0);
tx_pin : out unsigned(0 downto 0)
);
end component;

signal uart_tx : unsigned(0 downto 0);
signal uart_rx : unsigned(0 downto 0);

signal interrupt : bool;
signal interrupt_notify : bool;

signal req : CUtoME_IF;
signal req_sync_notify : bool;
signal req_notify_sync : bool;

signal resp : MEtoCU_IF;
signal resp_sync_notify : bool;
signal resp_notify_sync : bool;




signal clk : std_logic := '0';
signal rst : std_logic := '1';

begin 

uart1 : UART port map (clk, rst, req, req_sync_notify, req_notify_sync, 
                        uart_rx, uart_tx, interrupt, interrupt_notify, 
						 resp, resp_sync_notify, resp_notify_sync);
	
masterd : MasterDummy port map (clk, rst, req, req_notify_sync, 
                                req_sync_notify, interrupt, interrupt_notify, 
								resp, resp_notify_sync, resp_sync_notify);	

extd : ExternalDummy port map (clk, rst, uart_tx, uart_rx);




clock_process: process 
begin

clk <= not clk;

wait for 100ns;

end process;

reset_proc: process
begin
wait for 1 us;

rst <= '0';

wait;
end process;

end architecture;