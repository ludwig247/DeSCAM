library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use work.SCAM_Model_types.all;

entity Core_tb is
end entity Core_tb;

architecture Core_tb_arch of Core_tb is
    component Core_unwrapper is
        port (
            clk                  	: in  std_logic;
            rst                  	: in  std_logic;
        	fromMemoryPort_sig   	: in  MEtoCU_IF;
            fromMemoryPort_sync   	: in  boolean;
            fromMemoryPort_notify 	: out boolean;
            toMemoryPort_sig        : out CUtoME_IF;
            toMemoryPort_sync   	: in  boolean;
            toMemoryPort_notify		: out boolean
        	);
    end component;

    component Memory is
        port(    
            clk                     : in  std_logic;
            rst                     : in  std_logic;
            CPUtoMEM_port_sig     	: in  CUtoME_IF;
            CPUtoMEM_port_sync      : in  boolean;
            CPUtoMEM_port_notify    : out boolean;
            MEMtoCPU_port_sig     	: out MEtoCU_IF;
            MEMtoCPU_port_sync      : in  boolean;
            MEMtoCPU_port_notify    : out boolean
        	);
    end component;

    signal clk                      : std_logic := '0';
    signal rst                      : std_logic;
    signal MEMtoCPU_channel_sig  	: MEtoCU_IF;
    signal MEMtoCPU_channel_sync    : boolean;
    signal MEMtoCPU_channel_notify  : boolean;
    signal CPUtoMEM_channel_sig    	: CUtoME_IF;
    signal CPUtoMEM_channel_sync    : boolean;
    signal CPUtoMEM_channel_notify  : boolean;

begin
    -- Clock
    clk <= not clk after 10 ns;
    -- Reset
    rst <= '1', '0' after 20 ns;

    Core_unwrapper_inst: Core_unwrapper
        port map (
            clk                     => clk,
            rst                     => rst,
            fromMemoryPort_sig     	=> MEMtoCPU_channel_sig,
            fromMemoryPort_sync    	=> MEMtoCPU_channel_notify,
            fromMemoryPort_notify  	=> MEMtoCPU_channel_sync,
            toMemoryPort_sig      	=> CPUtoMEM_channel_sig,
            toMemoryPort_sync      	=> CPUtoMEM_channel_sync,
            toMemoryPort_notify    	=> CPUtoMEM_channel_notify
        	);

    Memory_inst: Memory
        port map (
            clk                     => clk,
            rst                     => rst,
            MEMtoCPU_port_sig      	=> MEMtoCPU_channel_sig,
            MEMtoCPU_port_sync      => MEMtoCPU_channel_sync,
            MEMtoCPU_port_notify    => MEMtoCPU_channel_notify,
            CPUtoMEM_port_sig      	=> CPUtoMEM_channel_sig,
            CPUtoMEM_port_sync      => CPUtoMEM_channel_notify,
            CPUtoMEM_port_notify    => CPUtoMEM_channel_sync
        	);
        
    stimuli: process
    begin
    wait;
    end process stimuli;

    stimuli: process
    begin

        wait for 40 ns;

        while not (MemToCtl_port = to_unsigned(1048691, 32)) loop
            wait for 20 ns;
        end loop;

        report "simulation finished successfully" severity FAILURE;

    end process stimuli;
    
end architecture;































