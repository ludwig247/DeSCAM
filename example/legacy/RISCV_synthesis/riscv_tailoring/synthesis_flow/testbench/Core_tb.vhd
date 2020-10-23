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
        	MEtoCO_port_sig   	: in  MEtoCU_IF;
            MEtoCO_port_sync   	: in  boolean;
            MEtoCO_port_notify 	: out boolean;
            COtoME_port_sig        : out CUtoME_IF;
            COtoME_port_sync   	: in  boolean;
            COtoME_port_notify		: out boolean
        	);
    end component;

    component Memory is
        port(    
            clk                     : in  std_logic;
            rst                     : in  std_logic;
            COtoME_port_sig     	: in  CUtoME_IF;
            COtoME_port_sync      : in  boolean;
            COtoME_port_notify    : out boolean;
            MEtoCO_port_sig     	: out MEtoCU_IF;
            MEtoCO_port_sync      : in  boolean;
            MEtoCO_port_notify    : out boolean
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
    clk <= not clk after 500 ns;
    -- Reset
    rst <= '1', '0' after 1000 ns;

    Core_unwrapper_inst: Core_unwrapper
        port map (
            clk                     => clk,
            rst                     => rst,
            MEtoCO_port_sig     	=> MEMtoCPU_channel_sig,
            MEtoCO_port_sync    	=> MEMtoCPU_channel_notify,
            MEtoCO_port_notify  	=> MEMtoCPU_channel_sync,
            COtoME_port_sig      	=> CPUtoMEM_channel_sig,
            COtoME_port_sync      	=> CPUtoMEM_channel_sync,
            COtoME_port_notify    	=> CPUtoMEM_channel_notify
        	);

    Memory_inst: Memory
        port map (
            clk                     => clk,
            rst                     => rst,
            MEtoCO_port_sig      	=> MEMtoCPU_channel_sig,
            MEtoCO_port_sync      => MEMtoCPU_channel_sync,
            MEtoCO_port_notify    => MEMtoCPU_channel_notify,
            COtoME_port_sig      	=> CPUtoMEM_channel_sig,
            COtoME_port_sync      => CPUtoMEM_channel_notify,
            COtoME_port_notify    => CPUtoMEM_channel_sync
        	);
      
    stimuli: process
    begin

        wait for 2000 ns;

        while not (MEMtoCPU_channel_sig.loadedData = x"00100073") loop
            wait for 1000 ns;
        end loop;

        report "simulation finished successfully" severity failure;

    end process stimuli;
    
end architecture;































