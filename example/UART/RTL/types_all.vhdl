library ieee;
use IEEE.numeric_std.all;

package SCAM_Model_types is
constant ZERO : unsigned(31 downto 0) := to_unsigned(0,32);

constant IP_bit : unsigned(31 downto 0) := to_unsigned(2,32);
constant RXNE_flag : unsigned(31 downto 0) := to_unsigned(8,32);
constant TC_flag : unsigned(31 downto 0) := to_unsigned(16,32);
constant TXE_flag : unsigned(31 downto 0) := to_unsigned(32,32);
constant PE_flag : unsigned(31 downto 0) := to_unsigned(64,32);
constant FE_flag : unsigned(31 downto 0) := to_unsigned(128,32);

constant PARBIT : unsigned(31 downto 0) := to_unsigned(512,32);
constant STOP_BIT : unsigned(31 downto 0) := to_unsigned(1024,32);

constant L1_BYTEMASK : unsigned(31 downto 0) := to_unsigned(65280, 32);
constant L2_BYTEMASK : unsigned(31 downto 0) := to_unsigned(16711680, 32);


constant DR_ADDR : unsigned(31 downto 0) := to_unsigned(8,32);


constant SR_MASK : unsigned(31 downto 0) := to_unsigned(40,32);




subtype bool is Boolean;
subtype int is integer;
type TX_SECTIONS is (IDLE1, IDLE2 ,SEND,START, START2 ,STOP);
type Control_SECTIONS is (RUN);
type Memory_manager_SECTIONS is (RUN1, RUN2);
type RX_SECTIONS is (IDLE,RECEIVE,SCAN, SCAN2 ,STOP1, STOP2);
type ME_AccessType is (ME_RD,ME_WR,ME_X);
type ME_MaskType is (MT_B,MT_BU,MT_H,MT_HU,MT_W,MT_X);
type reg_action is (NA,TX_WR);
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
end record;
type rx_data is record
	DR_reg: unsigned(31 downto 0);
	SR_reg: unsigned(31 downto 0);
end record;
type tx_data is record
	tx_reg: unsigned(31 downto 0);
	r_act: reg_action;
end record;
end package SCAM_Model_types;
