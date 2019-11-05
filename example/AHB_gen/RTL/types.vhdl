library ieee;
use IEEE.numeric_std.all;

package wrp_types is

type mWrp_sec is (init_cycle, addr_phase, data_phase, resp);
type sWrp_sec is (addr_phase, data_phase, req, resp, err);

type trans_type is (AHB_READ, AHB_WRITE);
type mask is (MT_B, MT_BU, MT_H, MT_HU, MT_W, MT_X);
type burst_type is (SINGLE, INCR, WRAP4,INCR4, WRAP8, INCR8, WRAP16, INCR16);



constant AHB_WRITES : unsigned(0 downto 0) := to_unsigned(1,1);
constant AHB_READS : unsigned(0 downto 0) := to_unsigned(0,1);

constant IDLE_t : unsigned(1 downto 0) := to_unsigned(0,2);
constant BUSY : unsigned(1 downto 0) := to_unsigned(1,2);
constant NONSEQ : unsigned(1 downto 0) := to_unsigned(2,2);
constant SEQ : unsigned(1 downto 0) := to_unsigned(3,2);

constant BYTE : unsigned(2 downto 0) := to_unsigned(0,3);
constant HALFWORD : unsigned(2 downto 0) := to_unsigned(1,3);
constant WORD : unsigned(2 downto 0) := to_unsigned(2,3);
constant X : unsigned(2 downto 0) := to_unsigned(3,3); -- to simplify properties in the case of MT_X

constant AHB_NOLOCK : unsigned(0 downto 0) := to_unsigned(0,1);
constant AHB_DEF_PROT : unsigned(3 downto 0) := to_unsigned(3,4);

constant SELECTED : unsigned(0 downto 0) := to_unsigned(1,1);

constant AHB_READY : unsigned(0 downto 0) := to_unsigned(1,1);
constant AHB_NOTREADY : unsigned(0 downto 0) := to_unsigned(0,1);

constant AHB_ERROR : unsigned(1 downto 0) := to_unsigned(1,2);
constant AHB_OKAY : unsigned(1 downto 0) := to_unsigned(0,2);

constant SINGLE_TRANSFER : unsigned(2 downto 0) := to_unsigned(0,3);



type CUtoAHB_IF is record
haddr: unsigned(31 downto 0);
hwdata: unsigned(31 downto 0);
--hburst: burst_type;
hwrite: trans_type;
hsize: mask;
end record;

type ahb_mst_out is record
haddr: unsigned(31 downto 0);
hburst: unsigned(2 downto 0);
hlock: unsigned(0 downto 0);
hprot: unsigned(3 downto 0);
hsize: unsigned(2 downto 0);
htrans: unsigned(1 downto 0);
hwdata: unsigned(31 downto 0);
hwrite: unsigned(0 downto 0); 
end record;

type ahb_mst_in is record
hrdata: unsigned(31 downto 0);
hready: unsigned(0 downto 0);
hresp: unsigned(1 downto 0); -- only lsb used in Lite
end record;

type ahb_slv_in is record
haddr: unsigned(31 downto 0);
hburst: unsigned(2 downto 0);
hlock: unsigned(0 downto 0);
hprot: unsigned(3 downto 0);
hsize: unsigned(2 downto 0);
htrans: unsigned(1 downto 0);
hwdata: unsigned(31 downto 0);
hwrite: unsigned(0 downto 0); 
end record;

type ahb_slv_out is record 
hrdata: unsigned(31 downto 0);
hreadyout: unsigned(0 downto 0);
hresp: unsigned(1 downto 0); -- only lsb used in Lite
end record;


type AHBtoCU_IF is record
hrdata: unsigned(31 downto 0);
hresp: unsigned(1 downto 0);
end record;

end package wrp_types;