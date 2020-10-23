--
-- Created by deutschmann on 13.02.18
--

library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use work.SCAM_Model_types.all;

entity Memory_tb is
end entity Memory_tb;

architecture sim of Memory_tb is
    component Memory is
        port (
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

    -- Input
    signal clk                : std_logic := '0';
    signal rst                : std_logic;
    signal CtlToMem_port      : MemoryAccess;
    signal CtlToMem_port_sync : bool;
    signal MemToCtl_port_sync : bool;
    signal MemToDec_port_sync : bool;

    -- Output
    signal MemToCtl_port        : Unsigned (31 downto 0);
    signal MemToDec_port        : Unsigned (31 downto 0);
    signal CtlToMem_port_notify : bool;
    signal MemToCtl_port_notify : bool;
    signal MemToDec_port_notify : bool;


begin

    -- Clock
    clk <= not clk  after  10 ns;

    -- Reset
    rst <= '1', '0' after  20 ns;

    dut: Memory
        port map (
            clk                  => clk,
            rst                  => rst,
            CtlToMem_port        => CtlToMem_port,
            CtlToMem_port_sync   => CtlToMem_port_sync,
            CtlToMem_port_notify => CtlToMem_port_notify,
            MemToCtl_port        => MemToCtl_port, 
            MemToCtl_port_sync   => MemToCtl_port_sync, 
            MemToCtl_port_notify => MemToCtl_port_notify, 
            MemToDec_port        => MemToDec_port, 
            MemToDec_port_sync   => MemToDec_port_sync,
            MemToDec_port_notify => MemToDec_port_notify 
        );


    stimuli: process
    begin

    -- Write X"CD" at Address 244 (Byte)
    wait for 20 ns;
    wait for 5 ns;
    CtlToMem_port.addrIn <= to_unsigned(244, 32);
    CtlToMem_port.dataIn <= X"67890BCD";
    CtlToMem_port.mask   <= MT_B;
    CtlToMem_port.req    <= MEM_STORE;
    CtlToMem_port_sync <= true;
    wait for 20 ns;
    CtlToMem_port_sync <= false;
    wait for 20 ns;

    -- Write X"0BCD" at Address 248 (Halfword)
    CtlToMem_port.addrIn <= to_unsigned(248, 32);
    CtlToMem_port.dataIn <= X"67890BCD";
    CtlToMem_port.mask   <= MT_H;
    CtlToMem_port.req    <= MEM_STORE;
    CtlToMem_port_sync <= true;
    wait for 20 ns;
    CtlToMem_port_sync <= false;
    wait for 20 ns;

    -- Write X"67890BCD" at Address 252 (Word)
    CtlToMem_port.addrIn <= to_unsigned(252, 32);
    CtlToMem_port.dataIn <= X"67890BCD";
    CtlToMem_port.mask   <= MT_W;
    CtlToMem_port.req    <= MEM_STORE;
    CtlToMem_port_sync <= true;
    wait for 20 ns;
    CtlToMem_port_sync <= false;
    wait for 20 ns;

    -- Load Content at Address 244
    CtlToMem_port.addrIn <= to_unsigned(244, 32);
    CtlToMem_port.dataIn <= X"00000000";
    CtlToMem_port.mask   <= MT_W;
    CtlToMem_port.req    <= MEM_LOAD;
    CtlToMem_port_sync <= true;
    wait for 20 ns;
    CtlToMem_port_sync <= false;
    assert MemToCtl_port = X"000000CD" report "unexpected value for MemToCtl_port" severity warning;
    assert MemToCtl_port_notify = true report "unexpected value for MemToCtl_port_notify" severity warning;
    MemToCtl_port_sync <= true;
    wait for 20 ns;
    MemToCtl_port_sync <= false;

    -- Load Content at Address 248
    CtlToMem_port.addrIn <= to_unsigned(248, 32);
    CtlToMem_port.dataIn <= X"00000000";
    CtlToMem_port.mask   <= MT_W;
    CtlToMem_port.req    <= MEM_LOAD;
    CtlToMem_port_sync <= true;
    wait for 20 ns;
    CtlToMem_port_sync <= false;
    assert MemToCtl_port = X"00000BCD" report "unexpected value for MemToCtl_port" severity warning;
    assert MemToCtl_port_notify = true report "unexpected value for MemToCtl_port_notify" severity warning;
    MemToCtl_port_sync <= true;
    wait for 20 ns;
    MemToCtl_port_sync <= false;

    -- Load Content at Address 252 as Byte
    CtlToMem_port.addrIn <= to_unsigned(252, 32);
    CtlToMem_port.dataIn <= X"00000000";
    CtlToMem_port.mask   <= MT_B;
    CtlToMem_port.req    <= MEM_LOAD;
    CtlToMem_port_sync <= true;
    wait for 20 ns;
    CtlToMem_port_sync <= false;
    assert MemToCtl_port = X"FFFFFFCD" report "unexpected value for MemToCtl_port" severity warning;
    assert MemToCtl_port_notify = true report "unexpected value for MemToCtl_port_notify" severity warning;
    MemToCtl_port_sync <= true;
    wait for 20 ns;
    MemToCtl_port_sync <= false;

    -- Load Content at Address 252 as Halfword
    CtlToMem_port.addrIn <= to_unsigned(252, 32);
    CtlToMem_port.dataIn <= X"00000000";
    CtlToMem_port.mask   <= MT_H;
    CtlToMem_port.req    <= MEM_LOAD;
    CtlToMem_port_sync <= true;
    wait for 20 ns;
    CtlToMem_port_sync <= false;
    assert MemToCtl_port = X"00000BCD" report "unexpected value for MemToCtl_port" severity warning;
    assert MemToCtl_port_notify = true report "unexpected value for MemToCtl_port_notify" severity warning;
    MemToCtl_port_sync <= true;
    wait for 20 ns;
    MemToCtl_port_sync <= false;

    -- Load Content at Address 252 as Word
    CtlToMem_port.addrIn <= to_unsigned(252, 32);
    CtlToMem_port.dataIn <= X"00000000";
    CtlToMem_port.mask   <= MT_W;
    CtlToMem_port.req    <= MEM_LOAD;
    CtlToMem_port_sync <= true;
    wait for 20 ns;
    CtlToMem_port_sync <= false;
    assert MemToCtl_port = X"67890BCD" report "unexpected value for MemToCtl_port" severity warning;
    assert MemToCtl_port_notify = true report "unexpected value for MemToCtl_port_notify" severity warning;
    MemToCtl_port_sync <= true;
    wait for 20 ns;
    MemToCtl_port_sync <= false;

    -- Read Instruction at Address 252
    CtlToMem_port.addrIn <= to_unsigned(252, 32);
    CtlToMem_port.dataIn <= X"00000000";
    CtlToMem_port.mask   <= MT_W;
    CtlToMem_port.req    <= MEM_RD_I;
    CtlToMem_port_sync <= true;
    wait for 20 ns;
    CtlToMem_port_sync <= false;
    assert MemToDec_port = X"67890BCD" report "unexpected value for MemToDec_port" severity warning;
    assert MemToDec_port_notify = true report "unexpected value for MemToDec_port_notify" severity warning;
    MemToDec_port_sync <= true;
    wait for 20 ns;
    MemToDec_port_sync <= false;


    wait;

    end process stimuli;


end architecture;





















































