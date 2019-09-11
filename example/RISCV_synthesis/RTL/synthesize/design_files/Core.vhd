library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SCAM_Model_types.all;

entity Core is
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
end Core;

architecture Core_arch of Core is

    --------------- ISA ----------------
    component ISA is
    port(
        clk                     : in  std_logic;
        rst                     : in  std_logic;
        toMemoryPort_sig       	: out CUtoME_IF;
        toMemoryPort_sync      	: in  boolean;
        toMemoryPort_notify    	: out boolean;
        toRegsPort_sig        	: out RegfileWriteType;
        toRegsPort_notify  		: out boolean;
        fromMemoryPort_sig     	: in  MEtoCU_IF;
        fromMemoryPort_sync   	: in  boolean;
        fromMemoryPort_notify  	: out boolean;
        fromRegsPort_sig        : in  RegfileType
    	);
    end component;
  
    --------------- Register-File ---------------
    component Regs is
    port(    
        clk                 : in  std_logic;
        rst                 : in  std_logic;
        fromRegsPort_sig    : out RegfileType;
        toRegsPort_sig    	: in  RegfileWriteType;
        toRegsPort_sync		: in  boolean
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
        toMemoryPort_sig       	=> toMemoryPort_sig,
        toMemoryPort_sync      	=> toMemoryPort_sync,
        toMemoryPort_notify    	=> toMemoryPort_notify,
        toRegsPort_sig        	=> ISAtoRF_channel_sig,
        toRegsPort_notify 		=> ISAtoRF_channel_notify,     
        fromMemoryPort_sig    	=> fromMemoryPort_sig,
        fromMemoryPort_sync   	=> fromMemoryPort_sync,
        fromMemoryPort_notify 	=> fromMemoryPort_notify,
        fromRegsPort_sig        => RFtoISA_channel_sig
    	);

    Regs_inst: Regs
	port map (
	    clk                     => clk,
	    rst                     => rst,
	    toRegsPort_sig        	=> ISAtoRF_channel_sig,
	    toRegsPort_sync   		=> ISAtoRF_channel_notify,
	    fromRegsPort_sig        => RFtoISA_channel_sig
		);
        
end Core_arch;
