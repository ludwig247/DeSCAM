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
    MemToCtl_port        : in  Unsigned (31 downto 0);
    MemToCtl_port_sync   : in  std_logic;
    MemToCtl_port_notify : out std_logic;
    CtlToMem_port_addrIn : out Unsigned (31 downto 0);
    CtlToMem_port_dataIn : out Unsigned (31 downto 0);
    CtlToMem_port_mask   : out Unsigned ( 2 downto 0);
    CtlToMem_port_req    : out std_logic;
    CtlToMem_port_sync   : in  std_logic;
    CtlToMem_port_notify : out std_logic
        );
    end component;

    component Memory is
        port(    
    clk                  : in  std_logic;
    rst                  : in  std_logic;
    CtlToMem_port_addrIn : in  Unsigned (31 downto 0);
    CtlToMem_port_dataIn : in  Unsigned (31 downto 0);
    CtlToMem_port_mask   : in  Unsigned ( 2 downto 0);
    CtlToMem_port_req    : in  std_logic;
    CtlToMem_port_sync   : in  std_logic;
    CtlToMem_port_notify : out std_logic;
    MemToCtl_port        : out Unsigned (31 downto 0);
    MemToCtl_port_sync   : in  std_logic;
    MemToCtl_port_notify : out std_logic
        );
    end component;

    signal clk : std_logic := '0';
    signal rst : std_logic;

    signal MemToCtl_port        : Unsigned (31 downto 0);
    signal MemToCtl_port_sync   : std_logic;
    signal MemToCtl_port_notify : std_logic;
    signal CtlToMem_port_addrIn : Unsigned (31 downto 0);
    signal CtlToMem_port_dataIn : Unsigned (31 downto 0);
    signal CtlToMem_port_mask   : Unsigned ( 2 downto 0);
    signal CtlToMem_port_req    : std_logic;
    signal CtlToMem_port_sync   : std_logic;
    signal CtlToMem_port_notify : std_logic;

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
            CtlToMem_port_addrIn  => CtlToMem_port_addrIn,
            CtlToMem_port_dataIn  => CtlToMem_port_dataIn,
            CtlToMem_port_mask    => CtlToMem_port_mask,
            CtlToMem_port_req     => CtlToMem_port_req,
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
            CtlToMem_port_addrIn  => CtlToMem_port_addrIn,
            CtlToMem_port_dataIn  => CtlToMem_port_dataIn,
            CtlToMem_port_mask    => CtlToMem_port_mask,
            CtlToMem_port_req     => CtlToMem_port_req,
            CtlToMem_port_sync   => CtlToMem_port_notify,
            CtlToMem_port_notify => CtlToMem_port_sync
        );


    stimuli: process
    begin

        wait for 40 ns;

        while not (MemToCtl_port = to_unsigned(1048691, 32)) loop
            wait for 20 ns;
        end loop;

        report "simulation finished successfully" severity FAILURE;

    end process stimuli;


end architecture;































