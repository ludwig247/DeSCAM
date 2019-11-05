library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;

entity UART is
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
end UART;

architecture structure of UART is

component Memory_manager
       port(
       	clk:		in std_logic;
	    rst:		in std_logic;
	bus_to_mem_man:		in CUtoME_IF;
	bus_to_mem_man_sync:	 in bool;
	bus_to_mem_man_notify:	 out bool;
	ctrl_to_mem_man:		in reg_files;
	mem_man_to_bus:		out MEtoCU_IF;
	mem_man_to_bus_sync:	 in bool;
	mem_man_to_bus_notify:	 out bool;
	mem_man_to_ctrl:		out CUtoME_IF;
	mem_man_to_ctrl_notify:	 out bool
       );
end component;

component Control 
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	TX_flags_in:		in unsigned(1 downto 0);
	TX_flags_in_sync:	 in bool;
        baud_clk_div:           out unsigned(15 downto 0);
        TE_flag:                out unsigned(0 downto 0);
        RE_flag:                out unsigned(0 downto 0);
	ctrl_from_rx:		in rx_data;
	ctrl_from_rx_sync:	 in bool;
	ctrl_to_tx:		out tx_data;
	interrupt:		out bool;
	interrupt_notify:	 out bool;
	req_from_mem:		in CUtoME_IF;
	req_from_mem_sync:	 in bool;
	resp_to_mem:		out reg_files
);
end component;


component TX
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
end component;

component RX
port(	
	clk:		in std_logic;
        baud_clk:       in std_logic;
	rst:		in std_logic;
	RX_pin:		in unsigned(0 downto 0);
	rx_to_ctrl:		out rx_data;
	rx_to_ctrl_notify:	 out bool
	);
end component;

component baudgen
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	baudrate_control:       in unsigned(15 downto 0);
        TE_flag:                in unsigned(0 downto 0);
        RE_flag:                in unsigned(0 downto 0);
	rec_trigger:		out std_logic;
	trans_trigger:		out std_logic
	);
end component;

signal ctrl_mem_man: reg_files;
signal mem_man_ctrl: CUtoME_IF;
signal mem_man_ctrl_notify: bool;

signal ctrl_baud: unsigned(15 downto 0);
signal re_flg: unsigned(0 downto 0);
signal te_flg: unsigned(0 downto 0);



signal trans_flag: unsigned(1 downto 0);
signal trans_flag_notify: bool;

signal TXreg: tx_data;
signal RXreg: rx_data;
signal RXreg_notify: bool;

signal baud_tx: std_logic;
signal baud_rx: std_logic;


signal tx_notify: bool;

begin



   mem_man: Memory_manager port map (clk, rst, request, request_sync, request_notify, 
                                     ctrl_mem_man, response, response_sync, response_notify, 
                                     mem_man_ctrl, mem_man_ctrl_notify); 
                                     
   ctrl: Control port map (clk, rst,trans_flag, trans_flag_notify, ctrl_baud, 
                                 te_flg, re_flg, Rxreg, RXreg_notify, TXreg ,interrupt_sig,
                                interrupt_sig_notify, mem_man_ctrl, 
                                mem_man_ctrl_notify, ctrl_mem_man); 
                                
   trans: TX port map (clk, baud_tx, rst, trans_flag, trans_flag_notify,
                         txpin, tx_notify, TXreg);                         
     
   rec: RX port map (clk, baud_rx, rst, rxpin, RXreg, RXreg_notify);
     

     baud: baudgen port map (clk, rst, ctrl_baud, te_flg, re_flg, baud_rx, baud_tx);
         

end structure;
