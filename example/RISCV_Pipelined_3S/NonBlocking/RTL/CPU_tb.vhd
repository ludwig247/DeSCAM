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

    component Core is
        port(
            clk                : in  std_logic;
            rst                : in  std_logic;
            COtoME_port        : out COtoME_IF;
            COtoME_port_sync   : in  bool;
            COtoME_port_notify : out bool;
            MEtoCO_port        : in  MEtoCO_IF;
            MEtoCO_port_sync   : in  bool;
            MEtoCO_port_notify : out bool
        );
    end component;

    component Memory is
        port(    
            clk                : in  std_logic;
            rst                : in  std_logic;
            COtoME_port        : in  COtoME_IF;
            COtoME_port_sync   : in  bool;
            COtoME_port_notify : out bool;
            MEtoCO_port        : out MEtoCO_IF;
            MEtoCO_port_sync   : in  bool;
            MEtoCO_port_notify : out bool
        );
    end component;

    signal clk : std_logic := '0';
    signal rst : std_logic;

    signal COtoME_port        : COtoME_IF;
    signal COtoME_port_sync   : bool;
    signal COtoME_port_notify : bool;
    signal MEtoCO_port        : MEtoCO_IF;
    signal MEtoCO_port_sync   : bool;
    signal MEtoCO_port_notify : bool;

begin

    -- CLOCK
    clk <= not clk  after  10 ns;

    -- RESET
    rst <= '1', '0' after  20 ns;

    --------------- INSTANTIATION ----------------
    CO: Core
        port map (
            clk                => clk,
            rst                => rst,
            COtoME_port        => COtoME_port,
            COtoME_port_sync   => COtoME_port_sync,
            COtoME_port_notify => COtoME_port_notify,
            MEtoCO_port        => MEtoCO_port,
            MEtoCO_port_sync   => MEtoCO_port_notify,
            MEtoCO_port_notify => MEtoCO_port_sync
        );

    ME: Memory
        port map (
            clk                => clk,
            rst                => rst,
            COtoME_port        => COtoME_port,
            COtoME_port_sync   => COtoME_port_notify,
            COtoME_port_notify => COtoME_port_sync,
            MEtoCO_port        => MEtoCO_port,
            MEtoCO_port_sync   => MEtoCO_port_sync,
            MEtoCO_port_notify => MEtoCO_port_notify
        );

    stimuli: process
    begin

        wait for 40 ns;

        while not (MEtoCO_port.loadedData = to_unsigned(1048691, 32)) loop
            wait for 20 ns;
        end loop;

        report "simulation finished successfully" severity FAILURE;

    end process stimuli;

end architecture;
