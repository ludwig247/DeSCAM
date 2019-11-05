library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SCAM_Model_types.all;

entity Core is
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
end Core;

architecture Core_arch of Core is

    --------------- ISA ----------------
    component ISA is
    port(
        clk                     : in  std_logic;
        rst                     : in  std_logic;
        COtoME_port_sig       	: out CUtoME_IF;
        COtoME_port_sync      	: in  boolean;
        COtoME_port_notify    	: out boolean;
        ISAtoRF_port_sig        	: out RegfileWriteType;
        ISAtoRF_port_notify  		: out boolean;
        MEtoCO_port_sig     	: in  MEtoCU_IF;
        MEtoCO_port_sync   	: in  boolean;
        MEtoCO_port_notify  	: out boolean;
        RFtoISA_port_sig        : in  RegfileType
    	);
    end component;
  
    --------------- Register-File ---------------
    component Regs is
    port(    
        clk                 : in  std_logic;
        rst                 : in  std_logic;
        RFtoISA_port_sig    : out RegfileType;
        ISAtoRF_port_sig    	: in  RegfileWriteType;
        ISAtoRF_port_sync		: in  boolean
    	);
    end component;

    ------------------ Signals ------------------
    signal ISAtoRF_channel_sig  	: RegfileWriteType;
    signal ISAtoRF_channel_notify 	: boolean;
    signal RFtoISA_channel_sig   	: RegfileType;

begin
    ISA_inst: ISA
    port map (
        clk                     => clk,
        rst                     => rst,
        COtoME_port_sig       	=> COtoME_port_sig,
        COtoME_port_sync      	=> COtoME_port_sync,
        COtoME_port_notify    	=> COtoME_port_notify,
        ISAtoRF_port_sig        	=> ISAtoRF_channel_sig,
        ISAtoRF_port_notify 		=> ISAtoRF_channel_notify,     
        MEtoCO_port_sig    	=> MEtoCO_port_sig,
        MEtoCO_port_sync   	=> MEtoCO_port_sync,
        MEtoCO_port_notify 	=> MEtoCO_port_notify,
        RFtoISA_port_sig        => RFtoISA_channel_sig
    	);

    Regs_inst: Regs
	port map (
	    clk                     => clk,
	    rst                     => rst,
	    ISAtoRF_port_sig        	=> ISAtoRF_channel_sig,
	    ISAtoRF_port_sync   		=> ISAtoRF_channel_notify,
	    RFtoISA_port_sig        => RFtoISA_channel_sig
		);
        
end Core_arch;
