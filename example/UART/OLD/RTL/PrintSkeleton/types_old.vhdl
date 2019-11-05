library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

package SCAM_Model_types is
subtype bool is Boolean;
subtype int is Integer;
type Controller_SECTIONS is (INIT, OUTPUT,SEND,READ_INPUT,SERVICE_COMMS);
type Receiver_SECTIONS is (INIT,IDLE, WRITE_DATA,PARITY,RECEIVE,SCAN,STOP);
type Transmitter_SECTIONS is (INIT,PARITY,READ_DATA,SEND,START,STOP);
type ME_AccessType is (ME_RD,ME_WR,ME_X);
type ME_MaskType is (MT_B,MT_BU,MT_H,MT_HU,MT_W,MT_X);
type reg_action is (CR_RD,CR_WR,NA,RX_RD,RX_WR,SR_RD,SR_WR,TX_WR);
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
	RX_reg: unsigned(7 downto 0);
	SR_reg: unsigned(31 downto 0);
	TX_reg: unsigned(7 downto 0);
	r_act: reg_action;
end record;
end package SCAM_Model_types;
