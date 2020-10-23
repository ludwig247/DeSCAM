--
-- Created by deutschmann on 13.02.18
--

library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use work.SCAM_Model_types.all;

entity Regs_tb is
end entity Regs_tb;

architecture sim of Regs_tb is
    component Regs is
        port (
            clk                   : in  std_logic;
            rst                   : in  std_logic;
            CtlToRegs_port        : in  CtlToRegs_IF;
            CtlToRegs_port_sync   : in  bool;
            CtlToRegs_port_notify : out bool;
            RegsToCtl_port        : out RegsToCtl_IF;
            RegsToCtl_port_sync   : in  bool;
            RegsToCtl_port_notify : out bool
        );
    end component;

    -- Input
    signal clk                 : std_logic := '0';
    signal rst                 : std_logic;
    signal CtlToRegs_port      : CtlToRegs_IF;
    signal CtlToRegs_port_sync : bool;
    signal RegsToCtl_port_sync : bool;

    -- Output
    signal RegsToCtl_port        : RegsToCtl_IF;
    signal CtlToRegs_port_notify : bool;
    signal RegsToCtl_port_notify : bool;


begin

    -- Clock
    clk <= not clk  after  10 ns;

    -- Reset
    rst <= '1', '0' after  20 ns;

    dut: Regs
        port map (
            clk                   => clk,
            rst                   => rst,
            CtlToRegs_port        => CtlToRegs_port,
            CtlToRegs_port_sync   => CtlToRegs_port_sync,
            CtlToRegs_port_notify => CtlToRegs_port_notify,
            RegsToCtl_port        => RegsToCtl_port,
            RegsToCtl_port_sync   => RegsToCtl_port_sync,
            RegsToCtl_port_notify => RegsToCtl_port_notify
        );


    stimuli: process
    begin

    -- Write 17 in Register 5
    wait for 20 ns;
    wait for 5 ns;
    CtlToRegs_port.dst      <= to_unsigned( 5, 32);
    CtlToRegs_port.dst_data <= to_unsigned(17, 32);
    CtlToRegs_port.req      <= REG_WR;
    CtlToRegs_port.src1     <= to_unsigned( 0, 32);
    CtlToRegs_port.src2     <= to_unsigned( 0, 32);
    CtlToRegs_port_sync <= true;
    wait for 20 ns;
    CtlToRegs_port_sync <= false;
    wait for 20 ns;

    -- Read Registers 0 and 5
    -- R0 always contains the value zero
    CtlToRegs_port.dst      <= to_unsigned(0, 32);
    CtlToRegs_port.dst_data <= to_unsigned(0, 32);
    CtlToRegs_port.req      <= REG_RD;
    CtlToRegs_port.src1     <= to_unsigned(0, 32);
    CtlToRegs_port.src2     <= to_unsigned(5, 32);
    CtlToRegs_port_sync <= true;
    wait for 20 ns;
    CtlToRegs_port_sync <= false;
    assert RegsToCtl_port.contents1 = to_unsigned( 0, 32) report "unexpected value for RegsToCtl_port.contents1" severity warning;
    assert RegsToCtl_port.contents2 = to_unsigned(17, 32) report "unexpected value for RegsToCtl_port.contents2" severity warning;
    RegsToCtl_port_sync <= true;


    wait;

    end process stimuli;


end architecture;





















































