--
-- Core unwrapper used as a workaround for problem with record type ports
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SCAM_Model_types.all;

entity Core_unwrapper is
port(    
    clk                  	: in  std_logic;
    rst                  	: in  std_logic;
    MEtoCO_port_sig		: in  MEtoCU_IF;
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
        clk                     	: in  std_logic;
        rst                      	: in  std_logic;
        MEtoCO_port_sig_data  	: in  unsigned(31 downto 0);
        MEtoCO_port_sync   		: in  boolean;
        MEtoCO_port_notify 		: out boolean;
        COtoME_port_sig_addr      	: out unsigned(31 downto 0);
        COtoME_port_sig_data      	: out unsigned(31 downto 0);
        COtoME_port_sig_rw        	: out ME_AccessType;
        COtoME_port_sig_mask      	: out ME_maskType;
        COtoME_port_sync      		: in  boolean;
        COtoME_port_notify    		: out boolean
    );
    end component;

begin

    Core_wrapper_inst: Core_wrapper
    port map (
        clk=> clk,
        rst                   	=> rst,
        MEtoCO_port_sig_data	=> MEtoCO_port_sig.loadedData,
        MEtoCO_port_sync    	=> MEtoCO_port_sync,
        MEtoCO_port_notify	=> MEtoCO_port_notify,
        COtoME_port_sig_data  	=> COtoME_port_sig.dataIn,
        COtoME_port_sig_addr 	=> COtoME_port_sig.addrIn,
        COtoME_port_sig_mask  	=> COtoME_port_sig.mask,
        COtoME_port_sig_rw  	=> COtoME_port_sig.req,
        COtoME_port_sync  		=> COtoME_port_sync,
        COtoME_port_notify		=> COtoME_port_notify
    );

end Core_unwrapper_arch;
