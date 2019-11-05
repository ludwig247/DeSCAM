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
            MemToCtl_port        : in  MEtoCU_IF;
            MemToCtl_port_sync   : in  bool;
            MemToCtl_port_notify : out bool;
            CtlToMem_port        : out CUtoME_IF;
            CtlToMem_port_sync   : in  bool;
            CtlToMem_port_notify : out bool
        );
    end component;

    component Memory is
        port(    
            clk                  : in  std_logic;
            rst                  : in  std_logic;
            CtlToMem_port        : in  CUtoME_IF;
            CtlToMem_port_sync   : in  bool;
            CtlToMem_port_notify : out bool;
            MemToCtl_port        : out MEtoCU_IF;
            MemToCtl_port_sync   : in  bool;
            MemToCtl_port_notify : out bool
        );
    end component;

    signal clk : std_logic := '0';
    signal rst : std_logic;

    signal MemToCtl_port        : MEtoCU_IF;
    signal MemToCtl_port_sync   : bool;
    signal MemToCtl_port_notify : bool;
    signal CtlToMem_port        : CUtoME_IF;
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
            MemToCtl_port        => MemToCtl_port,
            MemToCtl_port_sync   => MemToCtl_port_sync,
            MemToCtl_port_notify => MemToCtl_port_notify,
            CtlToMem_port        => CtlToMem_port,
            CtlToMem_port_sync   => CtlToMem_port_notify,
            CtlToMem_port_notify => CtlToMem_port_sync
        );


    stimuli: process
    begin

        wait for 40 ns;

        while not (MemToCtl_port.loadedData = to_unsigned(1048691, 32)) loop
            wait for 20 ns;
        end loop;

        report "simulation finished successfully" severity FAILURE;

    end process stimuli;


end architecture;































