--
-- CPU unwrapper used as a workaround for problem with record, boolean and enum type ports
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SCAM_Model_types.all;

entity Core_unwrapper is
port(    
    clk                  	: in  std_logic;
    rst                  	: in  std_logic;
    MEtoCO_port_sig   	: in  MEtoCU_IF;
    MEtoCO_port_sync   	: in  boolean;
    MEtoCO_port_notify 	: out boolean;
    COtoME_port_sig        : out CUtoME_IF;
    COtoME_port_sync   	: in  boolean;
    COtoME_port_notify 	: out boolean
);
end Core_unwrapper;

architecture Core_unwrapper_arch of Core_unwrapper is

    component Core_wrapper is
    port (
        clk                        	: in  std_logic;
        rst                        	: in  std_logic;
        MEtoCO_port_sig_logic   	: in  std_logic_vector(31 downto 0);
        MEtoCO_port_sync_logic  	: in  std_logic;
        MEtoCO_port_notify_logic	: out std_logic;
        COtoME_port_sig_addr_logic	: out std_logic_vector(31 downto 0);
        COtoME_port_sig_logic    	: out std_logic_vector(31 downto 0);
        COtoME_port_sig_rw_logic	: out std_logic_vector(1 downto 0);
        COtoME_port_sig_mask_logic	: out std_logic_vector(2 downto 0);
        COtoME_port_sync_logic    	: in  std_logic;
        COtoME_port_notify_logic  	: out std_logic
    );
    end component;
    
    signal COtoME_port_sig_rw_logic 	: std_logic_vector(1 downto 0);
    signal COtoME_port_sig_mask_logic 	: std_logic_vector(2 downto 0);
    signal COtoME_port_sig_addr_logic 	: std_logic_vector(31 downto 0);
    signal COtoME_port_sig_logic     	: std_logic_vector(31 downto 0);
    signal MEtoCO_port_sig_logic     : std_logic_vector(31 downto 0);  
    signal MEtoCO_port_sync_logic   	: std_logic;
    signal MEtoCO_port_notify_logic 	: std_logic;
    signal COtoME_port_sync_logic     	: std_logic; 
    signal COtoME_port_notify_logic   	: std_logic;


begin

    Core_wrapper_inst: Core_wrapper
    port map (
        clk                         	=> clk,
        rst                         	=> rst,
        MEtoCO_port_sig_logic    	=> MEtoCO_port_sig_logic,
        MEtoCO_port_sync_logic    	=> MEtoCO_port_sync_logic,
        MEtoCO_port_notify_logic  	=> MEtoCO_port_notify_logic,
        COtoME_port_sig_logic    		=> COtoME_port_sig_logic,
        COtoME_port_sig_addr_logic    	=> COtoME_port_sig_addr_logic,
        COtoME_port_sig_mask_logic    	=> COtoME_port_sig_mask_logic,
        COtoME_port_sig_rw_logic      	=> COtoME_port_sig_rw_logic,
        COtoME_port_sync_logic    		=> COtoME_port_sync_logic,
        COtoME_port_notify_logic  		=> COtoME_port_notify_logic
    );
    
    COtoME_port_sig.dataIn <= unsigned(COtoME_port_sig_logic);
    COtoME_port_sig.addrIn <= unsigned(COtoME_port_sig_addr_logic);
    MEtoCO_port_sig_logic <= std_logic_vector(MEtoCO_port_sig.loadedData);
    
    COtoME_port_sig.mask <= MT_B when (COtoME_port_sig_mask_logic = "000") else
                             MT_BU when (COtoME_port_sig_mask_logic = "001") else
                             MT_H when (COtoME_port_sig_mask_logic = "010") else
                             MT_HU when (COtoME_port_sig_mask_logic = "011") else
                             MT_W when (COtoME_port_sig_mask_logic = "100") else
                             MT_X;
                      
    COtoME_port_sig.req <= ME_WR when (COtoME_port_sig_rw_logic = "00") else
                            ME_RD when (COtoME_port_sig_rw_logic = "01") else
                            ME_X;
                            
    MEtoCO_port_notify <= true when (MEtoCO_port_notify_logic = '1') else false;
    COtoME_port_notify <= true when (COtoME_port_notify_logic = '1') else false;
    
    MEtoCO_port_sync_logic <= '1' when MEtoCO_port_sync else '0';
    COtoME_port_sync_logic <= '1' when COtoME_port_sync else '0';   
       
end Core_unwrapper_arch;
