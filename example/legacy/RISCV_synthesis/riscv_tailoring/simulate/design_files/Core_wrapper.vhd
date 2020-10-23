--
-- CPU wrapper used as a workaround for problem with record, boolean and enum type ports
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SCAM_Model_types.all;

entity Core_wrapper is
port(    
    clk                         : in  std_logic;
    rst                         : in  std_logic;
    MEtoCO_port_sig_logic    : in  std_logic_vector(31 downto 0);
    MEtoCO_port_sync_logic  	: in  std_logic;
    MEtoCO_port_notify_logic	: out std_logic;
    COtoME_port_sig_addr_logic	: out std_logic_vector(31 downto 0);
    COtoME_port_sig_logic    	: out std_logic_vector(31 downto 0);
    COtoME_port_sig_rw_logic 	: out std_logic_vector(1 downto 0);
    COtoME_port_sig_mask_logic	: out std_logic_vector(2 downto 0);
    COtoME_port_sync_logic    	: in  std_logic;
    COtoME_port_notify_logic  	: out std_logic
    );
end Core_wrapper;

architecture Core_wrapper_arch of Core_wrapper is

    component Core is
    port (
        clk                  	: in  std_logic;
        rst                  	: in  std_logic;
        MEtoCO_port_sig 		: in  MEtoCU_IF;
        MEtoCO_port_sync   	: in  boolean;
        MEtoCO_port_notify 	: out boolean;
        COtoME_port_sig        : out CUtoME_IF;
        COtoME_port_sync   	: in  boolean;
        COtoME_port_notify 	: out boolean
    );
    end component;
    
    signal COtoME_port_sig_rw_enum        	: ME_AccessType;
    signal COtoME_port_sig_mask_enum      	: ME_MaskType;
    signal MEtoCO_port_sync_bool      	: boolean;
    signal MEtoCO_port_notify_bool    	: boolean;
    signal COtoME_port_sync_bool      		: boolean; 
    signal COtoME_port_notify_bool    		: boolean;  
    signal COtoME_port_sig_addr_unsigned	: unsigned(31 downto 0);
    signal COtoME_port_sig_unsigned  		: unsigned(31 downto 0);
    signal MEtoCO_port_sig_unsigned  	: unsigned(31 downto 0);  
    

begin

    Core_inst: Core
    port map (
        clk                         	=> clk,
        rst                         	=> rst,
        MEtoCO_port_sig.loadedData	=> MEtoCO_port_sig_unsigned,
        MEtoCO_port_sync          	=> MEtoCO_port_sync_bool,
        MEtoCO_port_notify        	=> MEtoCO_port_notify_bool,
        COtoME_port_sig.dataIn        	=> COtoME_port_sig_unsigned,
        COtoME_port_sig.addrIn        	=> COtoME_port_sig_addr_unsigned,
        COtoME_port_sig.mask          	=> COtoME_port_sig_mask_enum,
        COtoME_port_sig.req           	=> COtoME_port_sig_rw_enum,
        COtoME_port_sync          		=> COtoME_port_sync_bool,
        COtoME_port_notify        		=> COtoME_port_notify_bool
    );
    
    MEtoCO_port_sig_unsigned <= unsigned(MEtoCO_port_sig_logic);
    COtoME_port_sig_logic <= std_logic_vector(COtoME_port_sig_unsigned);
    COtoME_port_sig_addr_logic <= std_logic_vector(COtoME_port_sig_addr_unsigned);
    
    COtoME_port_sig_rw_logic <= "00" when (COtoME_port_sig_rw_enum = ME_WR) else
                        		 "01" when (COtoME_port_sig_rw_enum = ME_RD) else
                        		 "11";
    
    COtoME_port_sig_mask_logic <=	"000" when (COtoME_port_sig_mask_enum = MT_B) else
                            		"001" when (COtoME_port_sig_mask_enum = MT_BU) else
                            		"010" when (COtoME_port_sig_mask_enum = MT_H) else
                            		"011" when (COtoME_port_sig_mask_enum = MT_HU) else
                            		"100" when (COtoME_port_sig_mask_enum = MT_W) else 
                            		"101";
                            
    MEtoCO_port_notify_logic <= '1' when MEtoCO_port_notify_bool else '0';
    COtoME_port_notify_logic <= '1' when COtoME_port_notify_bool else '0';
    
    MEtoCO_port_sync_bool <= true when (MEtoCO_port_sync_logic = '1') else false;
    COtoME_port_sync_bool <= true when (COtoME_port_sync_logic = '1') else false;   
       
end Core_wrapper_arch;
