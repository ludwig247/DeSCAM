library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use work.SCAM_Model_types.all;

entity core_tb is
end entity core_tb;

architecture core_tb_sim of core_tb is

    component core is
        port(
            clk                : in  std_logic;
            rst                : in  std_logic;
            CUtoME_port_sig    : out CUtoME_IF;
            CUtoME_port_sync   : in  boolean;
            CUtoME_port_notify : out boolean;
            MEtoCU_port_sig    : in  MEtoCU_IF;
            MEtoCU_port_sync   : in  boolean;
            MEtoCU_port_notify : out boolean
        );
    end component;

    component memory is
        port(    
            clk                : in  std_logic;
            rst                : in  std_logic;
            CUtoME_port        : in  CUtoME_IF;
            CUtoME_port_sync   : in  boolean;
            CUtoME_port_notify : out boolean;
            MEtoCU_port        : out MEtoCU_IF;
            MEtoCU_port_sync   : in  boolean;
            MEtoCU_port_notify : out boolean
        );
    end component;

    signal clk : std_logic := '0';
    signal rst : std_logic;

    signal CUtoME_channel                   : CUtoME_IF;
    signal CUtoME_channel_sync              : boolean;
    signal CUtoME_channel_notify            : boolean;
    signal CUtoME_channel_sync_delayed      : boolean := true;
    signal CUtoME_channel_notify_delayed    : boolean := true;
    
    signal MEtoCU_channel                   : MEtoCU_IF;
    signal MEtoCU_channel_sync              : boolean;
    signal MEtoCU_channel_notify            : boolean;
    signal MEtoCU_channel_sync_delayed      : boolean := false;
    signal MEtoCU_channel_notify_delayed    : boolean := false;

begin

    --------------- INSTANTIATION ----------------
    CO: core
        port map (
            clk                => clk,
            rst                => rst,
            CUtoME_port_sig    => CUtoME_channel,
            CUtoME_port_sync   => CUtoME_channel_sync_delayed,
            CUtoME_port_notify => CUtoME_channel_notify,
            MEtoCU_port_sig    => MEtoCU_channel,
            MEtoCU_port_sync   => MEtoCU_channel_notify_delayed,
            MEtoCU_port_notify => MEtoCU_channel_sync
        );

    ME: memory
        port map (
            clk                => clk,
            rst                => rst,
            CUtoME_port        => CUtoME_channel,
            CUtoME_port_sync   => CUtoME_channel_notify_delayed,
            CUtoME_port_notify => CUtoME_channel_sync,
            MEtoCU_port        => MEtoCU_channel,
            MEtoCU_port_sync   => MEtoCU_channel_sync_delayed,
            MEtoCU_port_notify => MEtoCU_channel_notify
        );

    -- CLOCK
    clk <= not clk after 10 ns;

    -- RESET
    rst <= '1', '0' after 20 ns;


    -- WARNING: this type of delay might cause some transitions to be suspended depending on reset type used in modules, use with caution
    CUtoME_channel_notify_delayed <= CUtoME_channel_notify after 25 ns when CUtoME_channel_notify else CUtoME_channel_notify;
    CUtoME_channel_sync_delayed <= CUtoME_channel_sync after 25 ns when CUtoME_channel_sync else CUtoME_channel_sync;
    
    MEtoCU_channel_notify_delayed <= MEtoCU_channel_notify after 25 ns when MEtoCU_channel_notify else MEtoCU_channel_notify;
    MEtoCU_channel_sync_delayed <= MEtoCU_channel_sync after 25 ns when MEtoCU_channel_sync else MEtoCU_channel_sync;

    stimuli: process
    begin
        wait for 40 ns; -- wait for reset

        while not (MEtoCU_channel.loadedData = to_unsigned(1048691, 32)) loop -- loop while not(ebreak)
            wait for 20 ns;
        end loop;

        wait for 100 ns; -- wait for pipeline to be filled
        report "simulation finished successfully" severity failure;

    end process stimuli;

end architecture;
