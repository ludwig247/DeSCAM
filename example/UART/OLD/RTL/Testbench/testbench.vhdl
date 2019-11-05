
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
         rxpin:  in bool;
         txpin: out bool;
  interrupt_sig: out bool;
  interrupt_sig_notify: out bool;
   response: out MEtoCU_IF;
   response_sync: in bool;
   response_notify: out bool
 );
 end component;
 
 component MasterDummy
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
 end component;

component ExternalDummy
port(
      	clk           	: 	in 	std_logic;
		rst          	: 	in 	std_logic;
        rxpin : in bool;
        txpin : out bool
);
end component;


signal tx_to_ext_rx : bool;
signal rx_to_ext_tx : bool;

signal interrupt_signal : bool;
signal interrupt_signal_notify : bool;

signal req : CUtoME_IF;
signal req_notify_to_master : bool;
signal req_sync_from_master   : bool;

signal resp : MEtoCU_IF;
signal resp_notify_to_master : bool;
signal resp_sync_from_master : bool;

signal clk : std_logic := '0';
signal rst : std_logic := '1';


begin


 uart1 : UART port map (clk, rst, req, 
                       req_sync_from_master, req_notify_to_master,
                       rx_to_ext_tx, tx_to_ext_rx, interrupt_signal, interrupt_signal_notify,
                       resp, resp_sync_from_master, resp_notify_to_master);
                       
masterd : MasterDummy port map (clk, rst, req, req_notify_to_master, req_sync_from_master,
                                interrupt_signal, interrupt_signal_notify, resp,
                                 resp_notify_to_master,resp_sync_from_master);
                                 
extd    : ExternalDummy port map (clk, rst, tx_to_ext_rx, rx_to_ext_tx);


clock_process: process
begin

clk <= not clk;

wait for 100 ns;

end process;

reset_proc: process
begin
wait for 1 us;

rst <= '0';

wait;
end process;




end architecture;

