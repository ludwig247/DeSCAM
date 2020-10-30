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
    fromMemoryPort_sig_logic    : in  std_logic_vector(31 downto 0);
    fromMemoryPort_sync_logic  	: in  std_logic;
    fromMemoryPort_notify_logic	: out std_logic;
    toMemoryPort_sig_addr_logic	: out std_logic_vector(31 downto 0);
    toMemoryPort_sig_logic    	: out std_logic_vector(31 downto 0);
    toMemoryPort_sig_rw_logic 	: out std_logic_vector(1 downto 0);
    toMemoryPort_sig_mask_logic	: out std_logic_vector(2 downto 0);
    toMemoryPort_sync_logic    	: in  std_logic;
    toMemoryPort_notify_logic  	: out std_logic
    );
end Core_wrapper;

architecture Core_wrapper_arch of Core_wrapper is

    component Core is
    port (
        clk                  	: in  std_logic;
        rst                  	: in  std_logic;
        fromMemoryPort_sig 		: in  MEtoCU_IF;
        fromMemoryPort_sync   	: in  boolean;
        fromMemoryPort_notify 	: out boolean;
        toMemoryPort_sig        : out CUtoME_IF;
        toMemoryPort_sync   	: in  boolean;
        toMemoryPort_notify 	: out boolean
    );
    end component;
    
    signal toMemoryPort_sig_rw_enum        	: ME_AccessType;
    signal toMemoryPort_sig_mask_enum      	: ME_MaskType;
    signal fromMemoryPort_sync_bool      	: boolean;
    signal fromMemoryPort_notify_bool    	: boolean;
    signal toMemoryPort_sync_bool      		: boolean; 
    signal toMemoryPort_notify_bool    		: boolean;  
    signal toMemoryPort_sig_addr_unsigned	: unsigned(31 downto 0);
    signal toMemoryPort_sig_unsigned  		: unsigned(31 downto 0);
    signal fromMemoryPort_sig_unsigned  	: unsigned(31 downto 0);  
    

begin

    Core_inst: Core
    port map (
        clk                         	=> clk,
        rst                         	=> rst,
        fromMemoryPort_sig.loadedData	=> fromMemoryPort_sig_unsigned,
        fromMemoryPort_sync          	=> fromMemoryPort_sync_bool,
        fromMemoryPort_notify        	=> fromMemoryPort_notify_bool,
        toMemoryPort_sig.dataIn        	=> toMemoryPort_sig_unsigned,
        toMemoryPort_sig.addrIn        	=> toMemoryPort_sig_addr_unsigned,
        toMemoryPort_sig.mask          	=> toMemoryPort_sig_mask_enum,
        toMemoryPort_sig.req           	=> toMemoryPort_sig_rw_enum,
        toMemoryPort_sync          		=> toMemoryPort_sync_bool,
        toMemoryPort_notify        		=> toMemoryPort_notify_bool
    );
    
    fromMemoryPort_sig_unsigned <= unsigned(fromMemoryPort_sig_logic);
    toMemoryPort_sig_logic <= std_logic_vector(toMemoryPort_sig_unsigned);
    toMemoryPort_sig_addr_logic <= std_logic_vector(toMemoryPort_sig_addr_unsigned);
    
    toMemoryPort_sig_rw_logic <= "00" when (toMemoryPort_sig_rw_enum = ME_WR) else
                        		 "01" when (toMemoryPort_sig_rw_enum = ME_RD) else
                        		 "11";
    
    toMemoryPort_sig_mask_logic <=	"000" when (toMemoryPort_sig_mask_enum = MT_B) else
                            		"001" when (toMemoryPort_sig_mask_enum = MT_BU) else
                            		"010" when (toMemoryPort_sig_mask_enum = MT_H) else
                            		"011" when (toMemoryPort_sig_mask_enum = MT_HU) else
                            		"100" when (toMemoryPort_sig_mask_enum = MT_W) else 
                            		"101";
                            
    fromMemoryPort_notify_logic <= '1' when fromMemoryPort_notify_bool else '0';
    toMemoryPort_notify_logic <= '1' when toMemoryPort_notify_bool else '0';
    
    fromMemoryPort_sync_bool <= true when (fromMemoryPort_sync_logic = '1') else false;
    toMemoryPort_sync_bool <= true when (toMemoryPort_sync_logic = '1') else false;   
       
end Core_wrapper_arch;
