--
-- Created by deutschmann on 14.02.18
--

library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use work.SCAM_Model_types.all;

entity CPU_tb is
end entity CPU_tb;

architecture sim of CPU_tb is

    component CPU is
        port (
            clk                  : in  std_logic;
            rst                  : in  std_logic;
            MemToDec_port        : in  Unsigned (31 downto 0);
            MemToDec_port_sync   : in  bool;
            MemToDec_port_notify : out bool;
            MemToCtl_port        : in  Unsigned (31 downto 0);
            MemToCtl_port_sync   : in  bool;
            MemToCtl_port_notify : out bool;
            CtlToMem_port        : out MemoryAccess;
            CtlToMem_port_sync   : in  bool;
            CtlToMem_port_notify : out bool
        );
    end component;

    component Memory is
        port(    
            clk                  : in  std_logic;
            rst                  : in  std_logic;
            CtlToMem_port        : in  MemoryAccess;
            CtlToMem_port_sync   : in  bool;
            CtlToMem_port_notify : out bool;
            MemToCtl_port        : out Unsigned (31 downto 0);
            MemToCtl_port_sync   : in  bool;
            MemToCtl_port_notify : out bool;
            MemToDec_port        : out Unsigned (31 downto 0);
            MemToDec_port_sync   : in  bool;
            MemToDec_port_notify : out bool
        );
    end component;

    signal clk : std_logic := '0';
    signal rst : std_logic;

    signal MemToDec_port        : Unsigned (31 downto 0);
    signal MemToDec_port_sync   : bool;
    signal MemToDec_port_notify : bool;
    signal MemToCtl_port        : Unsigned (31 downto 0);
    signal MemToCtl_port_sync   : bool;
    signal MemToCtl_port_notify : bool;
    signal CtlToMem_port        : MemoryAccess;
    signal CtlToMem_port_sync   : bool;
    signal CtlToMem_port_notify : bool;

begin

    -- Clock
    clk <= not clk  after  10 ns;

    -- Reset
    rst <= '1', '0' after  20 ns;

    IF_CPU: CPU
        port map (
            clk                  => clk,
            rst                  => rst,
            MemToDec_port        => MemToDec_port,
            MemToDec_port_sync   => MemToDec_port_notify,
            MemToDec_port_notify => MemToDec_port_sync,
            MemToCtl_port        => MemToCtl_port,
            MemToCtl_port_sync   => MemToCtl_port_notify,
            MemToCtl_port_notify => MemToCtl_port_sync,
            CtlToMem_port        => CtlToMem_port,
            CtlToMem_port_sync   => CtlToMem_port_sync,
            CtlToMem_port_notify => CtlToMem_port_notify
        );

    IF_Memory: Memory
        port map (
            clk                  => clk,
            rst                  => rst,
            MemToDec_port        => MemToDec_port,
            MemToDec_port_sync   => MemToDec_port_sync,
            MemToDec_port_notify => MemToDec_port_notify,
            MemToCtl_port        => MemToCtl_port,
            MemToCtl_port_sync   => MemToCtl_port_sync,
            MemToCtl_port_notify => MemToCtl_port_notify,
            CtlToMem_port        => CtlToMem_port,
            CtlToMem_port_sync   => CtlToMem_port_notify,
            CtlToMem_port_notify => CtlToMem_port_sync
        );


    stimuli: process
    begin



    wait;

    end process stimuli;


end architecture;































