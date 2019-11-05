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
            COtoME_port_sig    : out CUtoME_IF;
            COtoME_port_sync   : in  boolean;
            COtoME_port_notify : out boolean;
            MEtoCO_port_sig    : in  MEtoCU_IF;
            MEtoCO_port_sync   : in  boolean;
            MEtoCO_port_notify : out boolean
        );
    end component;

    component memory is
        generic (
            PROGRAM: string
        );
        port(    
            clk                : in  std_logic;
            rst                : in  std_logic;
            COtoME_port        : in  CUtoME_IF;
            COtoME_port_sync   : in  boolean;
            COtoME_port_notify : out boolean;
            MEtoCO_port        : out MEtoCU_IF;
            MEtoCO_port_sync   : in  boolean;
            MEtoCO_port_notify : out boolean
        );
    end component;

    signal clk : std_logic := '0';
    signal rst : std_logic;

    signal COtoME_channel                   : CUtoME_IF;
    signal COtoME_channel_sync              : boolean;
    signal COtoME_channel_notify            : boolean;
    signal COtoME_channel_sync_delayed      : boolean := true;
    signal COtoME_channel_notify_delayed    : boolean := true;
    
    signal MEtoCO_channel                   : MEtoCU_IF;
    signal MEtoCO_channel_sync              : boolean;
    signal MEtoCO_channel_notify            : boolean;
    signal MEtoCO_channel_sync_delayed      : boolean := false;
    signal MEtoCO_channel_notify_delayed    : boolean := false;

begin

    --------------- INSTANTIATION ----------------
    CO: core
        port map (
            clk                => clk,
            rst                => rst,
            COtoME_port_sig    => COtoME_channel,
            COtoME_port_sync   => COtoME_channel_sync_delayed,
            COtoME_port_notify => COtoME_channel_notify,
            MEtoCO_port_sig    => MEtoCO_channel,
            MEtoCO_port_sync   => MEtoCO_channel_notify_delayed,
            MEtoCO_port_notify => MEtoCO_channel_sync
        );

    ME: memory
        generic map (
            PROGRAM => "/import/home/morkunas/SCAM/example/RISCV_Test/Programs/store.hex"
        )
        port map (
            clk                => clk,
            rst                => rst,
            COtoME_port        => COtoME_channel,
            COtoME_port_sync   => COtoME_channel_notify_delayed,
            COtoME_port_notify => COtoME_channel_sync,
            MEtoCO_port        => MEtoCO_channel,
            MEtoCO_port_sync   => MEtoCO_channel_sync_delayed,
            MEtoCO_port_notify => MEtoCO_channel_notify
        );

    -- CLOCK
    clk <= not clk after 10 ns;

    -- RESET
    rst <= '1', '0' after 20 ns;


    -- WARNING: this type of delay might cause some transitions to be suspended depending on reset type used in modules, use with caution
    COtoME_channel_notify_delayed <= COtoME_channel_notify after 25 ns when COtoME_channel_notify else COtoME_channel_notify;
    COtoME_channel_sync_delayed <= COtoME_channel_sync after 25 ns when COtoME_channel_sync else COtoME_channel_sync;
    
    MEtoCO_channel_notify_delayed <= MEtoCO_channel_notify after 25 ns when MEtoCO_channel_notify else MEtoCO_channel_notify;
    MEtoCO_channel_sync_delayed <= MEtoCO_channel_sync after 25 ns when MEtoCO_channel_sync else MEtoCO_channel_sync;

    stimuli: process
    begin
        wait for 40 ns; -- wait for reset

        while not (MEtoCO_channel.loadedData = to_unsigned(1048691, 32)) loop -- loop while not(ebreak)
            wait for 20 ns;
        end loop;

        wait for 100 ns; -- wait for pipeline to be filled
        report "simulation finished successfully" severity failure;

    end process stimuli;

end architecture;
