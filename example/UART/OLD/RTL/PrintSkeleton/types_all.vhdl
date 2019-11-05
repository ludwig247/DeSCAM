library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

package SCAM_Model_types is
subtype bool is Boolean;
subtype int is Integer;
type Control_SECTIONS is (INIT,RUN);
type RX_SECTIONS is (IDLE,INIT,PARITY,RECEIVE,SCAN,STOP1, STOP2);
type TX_SECTIONS is (IDLE1, IDLE2,INIT,PARITY,SEND,START,STOP1,STOP2);
type baudgen_SECTIONS is (RUN);
type Memory_manager_SECTIONS is (RUN1, RUN2);
type ME_AccessType is (ME_RD,ME_WR,ME_X);
type ME_MaskType is (MT_B,MT_BU,MT_H,MT_HU,MT_W,MT_X);
type reg_action is (CR_RD,CR_WR,NA,RX_RD,RX_WR,SR_RD,SR_WR,TX_WR);
type tx_flags is (NF,RESET,SET);
type CUtoME_IF is record
	addrIn: unsigned(31 downto 0);
	dataIn: unsigned(31 downto 0);
	mask: ME_MaskType;
	req: ME_AccessType;
end record;
type MEtoCU_IF is record
	loadedData: unsigned(31 downto 0);
end record;
type reg_files is record
	CR_reg: unsigned(31 downto 0);
	DR_reg: unsigned(31 downto 0);
	SR_reg: unsigned(31 downto 0);
	r_act: reg_action;
end record;
type tx_data is record
	TX_temp_register: unsigned(31 downto 0);
	r_act: reg_action;
end record;
type tx_flag_values is record
	tc_flag: tx_flags;
	txe_flag: tx_flags;
end record;
end package SCAM_Model_types;
