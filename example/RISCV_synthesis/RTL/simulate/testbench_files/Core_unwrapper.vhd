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
    fromMemoryPort_sig   	: in  MEtoCU_IF;
    fromMemoryPort_sync   	: in  boolean;
    fromMemoryPort_notify 	: out boolean;
    toMemoryPort_sig        : out CUtoME_IF;
    toMemoryPort_sync   	: in  boolean;
    toMemoryPort_notify 	: out boolean
);
end Core_unwrapper;

architecture Core_unwrapper_arch of Core_unwrapper is

    component Core_wrapper is
    port (
        clk                        	: in  std_logic;
        rst                        	: in  std_logic;
        fromMemoryPort_sig_logic   	: in  std_logic_vector(31 downto 0);
        fromMemoryPort_sync_logic  	: in  std_logic;
        fromMemoryPort_notify_logic	: out std_logic;
        toMemoryPort_sig_addr_logic	: out std_logic_vector(31 downto 0);
        toMemoryPort_sig_logic    	: out std_logic_vector(31 downto 0);
        toMemoryPort_sig_rw_logic	: out std_logic_vector(1 downto 0);
        toMemoryPort_sig_mask_logic	: out std_logic_vector(2 downto 0);
        toMemoryPort_sync_logic    	: in  std_logic;
        toMemoryPort_notify_logic  	: out std_logic
    );
    end component;
    
    signal toMemoryPort_sig_rw_logic 	: std_logic_vector(1 downto 0);
    signal toMemoryPort_sig_mask_logic 	: std_logic_vector(2 downto 0);
    signal toMemoryPort_sig_addr_logic 	: std_logic_vector(31 downto 0);
    signal toMemoryPort_sig_logic     	: std_logic_vector(31 downto 0);
    signal fromMemoryPort_sig_logic     : std_logic_vector(31 downto 0);  
    signal fromMemoryPort_sync_logic   	: std_logic;
    signal fromMemoryPort_notify_logic 	: std_logic;
    signal toMemoryPort_sync_logic     	: std_logic; 
    signal toMemoryPort_notify_logic   	: std_logic;


begin

    Core_wrapper_inst: Core_wrapper
    port map (
        clk                         	=> clk,
        rst                         	=> rst,
        fromMemoryPort_sig_logic    	=> fromMemoryPort_sig_logic,
        fromMemoryPort_sync_logic    	=> fromMemoryPort_sync_logic,
        fromMemoryPort_notify_logic  	=> fromMemoryPort_notify_logic,
        toMemoryPort_sig_logic    		=> toMemoryPort_sig_logic,
        toMemoryPort_sig_addr_logic    	=> toMemoryPort_sig_addr_logic,
        toMemoryPort_sig_mask_logic    	=> toMemoryPort_sig_mask_logic,
        toMemoryPort_sig_rw_logic      	=> toMemoryPort_sig_rw_logic,
        toMemoryPort_sync_logic    		=> toMemoryPort_sync_logic,
        toMemoryPort_notify_logic  		=> toMemoryPort_notify_logic
    );
    
    toMemoryPort_sig.dataIn <= unsigned(toMemoryPort_sig_logic);
    toMemoryPort_sig.addrIn <= unsigned(toMemoryPort_sig_addr_logic);
    fromMemoryPort_sig_logic <= std_logic_vector(fromMemoryPort_sig.loadedData);
    
    toMemoryPort_sig.mask <= MT_B when (toMemoryPort_sig_mask_logic = "000") else
                             MT_BU when (toMemoryPort_sig_mask_logic = "001") else
                             MT_H when (toMemoryPort_sig_mask_logic = "010") else
                             MT_HU when (toMemoryPort_sig_mask_logic = "011") else
                             MT_W when (toMemoryPort_sig_mask_logic = "100") else
                             MT_X;
                      
    toMemoryPort_sig.req <= ME_WR when (toMemoryPort_sig_rw_logic = "00") else
                            ME_RD when (toMemoryPort_sig_rw_logic = "01") else
                            ME_X;
                            
    fromMemoryPort_notify <= true when (fromMemoryPort_notify_logic = '1') else false;
    toMemoryPort_notify <= true when (toMemoryPort_notify_logic = '1') else false;
    
    fromMemoryPort_sync_logic <= '1' when fromMemoryPort_sync else '0';
    toMemoryPort_sync_logic <= '1' when toMemoryPort_sync else '0';   
       
end Core_unwrapper_arch;
