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
         rxpin:  in bool;
         txpin: out bool;
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
	Baudrate_control:		out unsigned(31 downto 0);
	Parity_control_RX:		out unsigned(31 downto 0);
	Parity_control_TX:		out unsigned(31 downto 0);
	RE_flag_out:		out unsigned(31 downto 0);
	TE_flag_out:		out unsigned(31 downto 0);
	TX_flags_in:		in tx_flag_values;
	TX_flags_in_sync:	 in bool;
	TX_reg_to_shiftreg:		out tx_data;
	interrupt:		out bool;
	interrupt_notify:	 out bool;
	req_from_mem:		in CUtoME_IF;
	req_from_mem_sync:	 in bool;
	resp_to_mem:		out reg_files;
	shiftreg_to_RX_reg:		in reg_files;
	shiftreg_to_RX_reg_sync:	 in bool
	);
end component;

component TX
    port(
    	clk:		in std_logic;
	rst:		in std_logic;
	Parity_control_in:		in unsigned(31 downto 0);
	TE_flag_in:		in unsigned(31 downto 0);
	TX_flags_out:		out tx_flag_values;
	TX_flags_out_notify:	 out bool;
	TX_pin:		out bool;
	TX_reg_to_shiftreg:		in tx_data;
	baudrate_in:		in bool
    );
end component;

component RX  
     port(
     	clk:		in std_logic;
	rst:		in std_logic;
	Parity_control_in:		in unsigned(31 downto 0);
	RE_flag_in:		in unsigned(31 downto 0);
	RX_pin:		in bool;
	baudrate_in:		in bool;
	shiftreg_to_RX_reg:		out reg_files;
	shiftreg_to_RX_reg_notify:	 out bool
     );
end component;

component baudgen
     port(
    clk:		        in std_logic;
	rst:		        in std_logic;
	baudrate_control:	in unsigned(31 downto 0);
	rec_trigger:		out bool;
	trans_trigger:		out bool
     );
end component;

signal ctrl_mem_man: reg_files;
signal mem_man_ctrl: CUtoME_IF;
signal mem_man_ctrl_notify: bool;

signal ctrl_baud: unsigned(31 downto 0);
signal ctrl_par_rx: unsigned(31 downto 0);
signal ctrl_par_tx: unsigned(31 downto 0);
signal re_flag: unsigned(31 downto 0);
signal te_flag: unsigned(31 downto 0);
signal trans_flag: tx_flag_values;
signal trans_flag_notify: bool;

signal TXreg: tx_data;
signal RXreg: reg_files;
signal RXreg_notify: bool;


signal baud_tx: bool;
signal baud_rx: bool;



begin

   mem_man: Memory_manager port map (clk, rst, request, request_sync, request_notify, 
                                     ctrl_mem_man, response, response_sync, response_notify, 
                                     mem_man_ctrl, mem_man_ctrl_notify); 
                              
          
      ctrl: Control port map (clk, rst, ctrl_baud, ctrl_par_rx, ctrl_par_tx, re_flag, te_flag, 
                               trans_flag, trans_flag_notify, TXreg ,interrupt_sig,
                                interrupt_sig_notify, mem_man_ctrl, 
                                mem_man_ctrl_notify, ctrl_mem_man,
                                Rxreg, RXreg_notify); 
                               
                               
     trans: TX port map (clk, rst, ctrl_par_tx, te_flag, trans_flag, trans_flag_notify,
                         txpin, TXreg, baud_tx);
     
     rec: RX port map (clk, rst, ctrl_par_rx, re_flag, rxpin, baud_rx, RXreg, RXreg_notify);
     
     baud: baudgen port map (clk, rst, ctrl_baud, baud_rx, baud_tx);
                         

end structure;
