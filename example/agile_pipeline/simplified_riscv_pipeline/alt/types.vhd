library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

package SCAM_Model_types is

    constant MEM_SIZE : integer := 65536;

    subtype bool is boolean;
    subtype int  is integer;

    type ram_type is array (0 to (MEM_SIZE-1)) of unsigned (7 downto 0);

    type CU_SECTIONS  is (writeMem, readMem, writeDmem, readDmem);
    type MEM_SECTIONS is (read, write);

    type ME_MaskType is (MT_B, MT_BU, MT_H, MT_HU, MT_W, MT_X);
    type ME_AccessType is (ME_RD, ME_WR, ME_X);
    
    type CUtoME_IF is record
        req    : ME_AccessType;
        mask   : ME_MaskType;
        addrIn : unsigned (31 downto 0);
        dataIn : unsigned (31 downto 0);
    end record;

    type MEtoCU_IF is record
        loadedData : unsigned (31 downto 0);
    end record;

    type CUtoDE_IF is record
        encodedInstr : unsigned (31 downto 0);
    end record;

    type CUtoRF_IF is record
        src1    : unsigned ( 4 downto 0);
        src2    : unsigned ( 4 downto 0);
        dst     : unsigned ( 4 downto 0);
        dstData : unsigned (31 downto 0);
    end record;

    type RFtoCU_IF is record
        reg1Content : unsigned (31 downto 0);
        reg2Content : unsigned (31 downto 0);
    end record;

type opcode is (LOAD,STORE,unknown);

end package SCAM_Model_types;
