library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use work.SCAM_Model_types.all;

entity core_equivalence is
port(
    clk                : in  std_logic;
    rst                : in  std_logic;
    COtoME_port_sig1   : out CUtoME_IF;
    COtoME_port_sig2   : out CUtoME_IF;
    COtoME_port_sync   : in  boolean;
    COtoME_port_notify1: out boolean;
    COtoME_port_notify2: out boolean;
    MEtoCO_port_sig    : in  MEtoCU_IF;
    MEtoCO_port_sync   : in  boolean;
    MEtoCO_port_notify1: out boolean;
    MEtoCO_port_notify2: out boolean
);
end core_equivalence;

architecture core_equivalence_arch of core_equivalence is

    component core is
        port(
            clk                : in  std_logic;
            rst                : in  std_logic;
            COtoME_port_sig    : out CUtoME_IF;
            COtoME_port_sync   : in  boolean;
            COtoME_port_notify : out boolean;
            MEtoCO_port_sig    : in  MEtoCU_IF;
            MEtoCO_port_sync   : in  boolean;
            MEtoCO_port_notify : out boolean
        );
    end component;

    component core_alt is
        port(
            clk                : in  std_logic;
            rst                : in  std_logic;
            COtoME_port_sig    : out CUtoME_IF;
            COtoME_port_sync   : in  boolean;
            COtoME_port_notify : out boolean;
            MEtoCO_port_sig    : in  MEtoCU_IF;
            MEtoCO_port_sync   : in  boolean;
            MEtoCO_port_notify : out boolean
        );
    end component; 

begin

    --------------- INSTANTIATION ----------------
    CO1: core
        port map (
            clk                => clk,
            rst                => rst,
            COtoME_port_sig    => COtoME_port_sig1,
            COtoME_port_sync   => COtoME_port_sync,
            COtoME_port_notify => COtoME_port_notify1,
            MEtoCO_port_sig    => MEtoCO_port_sig,
            MEtoCO_port_sync   => MEtoCO_port_sync,
            MEtoCO_port_notify => MEtoCO_port_notify1
        );
        
    CO2: core_alt
        port map (
            clk                => clk,
            rst                => rst,
            COtoME_port_sig    => COtoME_port_sig2,
            COtoME_port_sync   => COtoME_port_sync,
            COtoME_port_notify => COtoME_port_notify2,
            MEtoCO_port_sig    => MEtoCO_port_sig,
            MEtoCO_port_sync   => MEtoCO_port_sync,
            MEtoCO_port_notify => MEtoCO_port_notify2
        );
        
end architecture;
