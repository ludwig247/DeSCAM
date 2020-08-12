--
-- Created by deutschmann on 06.02.18
--

library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use work.SCAM_Model_types.all;

entity Decoder_tb is
end entity Decoder_tb;

architecture sim of Decoder_tb is
    component Decoder is
        port (
            clk                  : in  std_logic;
            rst                  : in  std_logic;
            MemToDec_port        : in  Unsigned (31 downto 0);
            MemToDec_port_sync   : in  bool;
            MemToDec_port_notify : out bool;
            DecToCtl_port        : out DecodedInstr;
            DecToCtl_port_sync   : in  bool;
            DecToCtl_port_notify : out bool
        );
    end component;

    -- Input
    signal clk                : std_logic := '0';
    signal rst                : std_logic;
    signal MemToDec_port      : Unsigned (31 downto 0);
    signal MemToDec_port_sync : bool;
    signal DecToCtl_port_sync : bool;

    -- Output
    signal DecToCtl_port        : DecodedInstr;
    signal MemToDec_port_notify : bool;
    signal DecToCtl_port_notify : bool;


begin

    -- Clock
    clk <= not clk  after  10 ns;

    -- Reset
    rst <= '1', '0' after  20 ns;

    dut: Decoder
        port map (
            clk                  => clk,
            rst                  => rst,
            MemToDec_port        => MemToDec_port,
            MemToDec_port_sync   => MemToDec_port_sync,
            MemToDec_port_notify => MemToDec_port_notify,
            DecToCtl_port        => DecToCtl_port,
            DecToCtl_port_sync   => DecToCtl_port_sync,
            DecToCtl_port_notify => DecToCtl_port_notify

        );


    stimuli: process
    begin

    -- addi $5,$1,9
    wait until MemToDec_port_notify = true;
    DecToCtl_port_sync <= false;
    wait for 5 ns;
    MemToDec_port <= "00000000100100001000001010010011";
    MemToDec_port_sync <= true;
    wait until DecToCtl_port_notify = true;
    MemToDec_port_sync <= false;
    assert DecToCtl_port.encType   = I                  report "unexpected value for DecToCtl_port.encType"   severity warning;
    assert DecToCtl_port.imm       = to_unsigned(9, 32) report "unexpected value for DecToCtl_port.imm"       severity warning;
    assert DecToCtl_port.instrType = addi               report "unexpected value for DecToCtl_port.instrType" severity warning;
    assert DecToCtl_port.rd_addr   = to_unsigned(5, 32) report "unexpected value for DecToCtl_port.rd_addr"   severity warning;
    assert DecToCtl_port.rs1_addr  = to_unsigned(1, 32) report "unexpected value for DecToCtl_port.rs1_addr"  severity warning;
    assert DecToCtl_port.rs2_addr  = to_unsigned(9, 32) report "unexpected value for DecToCtl_port.rs2_addr"  severity warning;
    wait for 5 ns;
    DecToCtl_port_sync <= true;

    -- addi $5,$1,-7
    wait until MemToDec_port_notify = true;
    DecToCtl_port_sync <= false;
    wait for 5 ns;
    MemToDec_port <= "11111111100100001000001010010011";
    MemToDec_port_sync <= true;
    wait until DecToCtl_port_notify = true;
    MemToDec_port_sync <= false;
    assert DecToCtl_port.encType   = I                           report "unexpected value for DecToCtl_port.encType"   severity warning;
    assert DecToCtl_port.imm       = unsigned(to_signed(-7, 32)) report "unexpected value for DecToCtl_port.imm"       severity warning;
    assert DecToCtl_port.instrType = addi                        report "unexpected value for DecToCtl_port.instrType" severity warning;
    assert DecToCtl_port.rd_addr   = to_unsigned(5, 32)          report "unexpected value for DecToCtl_port.rd_addr"   severity warning;
    assert DecToCtl_port.rs1_addr  = to_unsigned(1, 32)          report "unexpected value for DecToCtl_port.rs1_addr"  severity warning;
    assert DecToCtl_port.rs2_addr  = to_unsigned(25, 32)         report "unexpected value for DecToCtl_port.rs2_addr"  severity warning;
    wait for 5 ns;
    DecToCtl_port_sync <= true;

    -- srai $3,$2,4
    wait until MemToDec_port_notify = true;
    DecToCtl_port_sync <= false;
    wait for 5 ns;
    MemToDec_port <= "01000000010000010101000110010011";
    MemToDec_port_sync <= true;
    wait until DecToCtl_port_notify = true;
    MemToDec_port_sync <= false;
    assert DecToCtl_port.encType   = I                  report "unexpected value for DecToCtl_port.encType"   severity warning;
    assert DecToCtl_port.imm       = to_unsigned(4, 32) report "unexpected value for DecToCtl_port.imm"       severity warning;
    assert DecToCtl_port.instrType = sraI               report "unexpected value for DecToCtl_port.instrType" severity warning;
    assert DecToCtl_port.rd_addr   = to_unsigned(3, 32) report "unexpected value for DecToCtl_port.rd_addr"   severity warning;
    assert DecToCtl_port.rs1_addr  = to_unsigned(2, 32) report "unexpected value for DecToCtl_port.rs1_addr"  severity warning;
    assert DecToCtl_port.rs2_addr  = to_unsigned(4, 32) report "unexpected value for DecToCtl_port.rs2_addr"  severity warning;
    wait for 5 ns;
    DecToCtl_port_sync <= true;

    -- xor $3,$1,$2
    wait until MemToDec_port_notify = true;
    DecToCtl_port_sync <= false;
    wait for 5 ns;
    MemToDec_port <= "00000000001000001100000110110011";
    MemToDec_port_sync <= true;
    wait until DecToCtl_port_notify = true;
    MemToDec_port_sync <= false;
    assert DecToCtl_port.encType   = R                  report "unexpected value for DecToCtl_port.encType"   severity warning;
    assert DecToCtl_port.imm       = to_unsigned(0, 32) report "unexpected value for DecToCtl_port.imm"       severity warning;
    assert DecToCtl_port.instrType = Xor_Instr          report "unexpected value for DecToCtl_port.instrType" severity warning;
    assert DecToCtl_port.rd_addr   = to_unsigned(3, 32) report "unexpected value for DecToCtl_port.rd_addr"   severity warning;
    assert DecToCtl_port.rs1_addr  = to_unsigned(1, 32) report "unexpected value for DecToCtl_port.rs1_addr"  severity warning;
    assert DecToCtl_port.rs2_addr  = to_unsigned(2, 32) report "unexpected value for DecToCtl_port.rs2_addr"  severity warning;
    wait for 5 ns;
    DecToCtl_port_sync <= true;

    -- bne $1,$2,24
    wait until MemToDec_port_notify = true;
    DecToCtl_port_sync <= false;
    wait for 5 ns;
    MemToDec_port <= "00000000001000001001110001100011";
    MemToDec_port_sync <= true;
    wait until DecToCtl_port_notify = true;
    MemToDec_port_sync <= false;
    assert DecToCtl_port.encType   = B                   report "unexpected value for DecToCtl_port.encType"   severity warning;
    assert DecToCtl_port.imm       = to_unsigned(24, 32) report "unexpected value for DecToCtl_port.imm"       severity warning;
    assert DecToCtl_port.instrType = bne                 report "unexpected value for DecToCtl_port.instrType" severity warning;
    assert DecToCtl_port.rd_addr   = to_unsigned(24, 32) report "unexpected value for DecToCtl_port.rd_addr"   severity warning;
    assert DecToCtl_port.rs1_addr  = to_unsigned(1, 32)  report "unexpected value for DecToCtl_port.rs1_addr"  severity warning;
    assert DecToCtl_port.rs2_addr  = to_unsigned(2, 32)  report "unexpected value for DecToCtl_port.rs2_addr"  severity warning;
    wait for 5 ns;
    DecToCtl_port_sync <= true;

    -- lw $3,$1(-20)
    wait until MemToDec_port_notify = true;
    DecToCtl_port_sync <= false;
    wait for 5 ns;
    MemToDec_port <= "11111110110000001010000110000011";
    MemToDec_port_sync <= true;
    wait until DecToCtl_port_notify = true;
    MemToDec_port_sync <= false;
    assert DecToCtl_port.encType   = I                             report "unexpected value for DecToCtl_port.encType"   severity warning;
    assert DecToCtl_port.imm       = unsigned(to_signed(-20, 32))  report "unexpected value for DecToCtl_port.imm"       severity warning;
    assert DecToCtl_port.instrType = lw                            report "unexpected value for DecToCtl_port.instrType" severity warning;
    assert DecToCtl_port.rd_addr   = to_unsigned(3, 32)            report "unexpected value for DecToCtl_port.rd_addr"   severity warning;
    assert DecToCtl_port.rs1_addr  = to_unsigned(1, 32)            report "unexpected value for DecToCtl_port.rs1_addr"  severity warning;
    assert DecToCtl_port.rs2_addr  = to_unsigned(12, 32)           report "unexpected value for DecToCtl_port.rs2_addr"  severity warning;
    wait for 5 ns;
    DecToCtl_port_sync <= true;

    -- jal $5, 72
    wait until MemToDec_port_notify = true;
    DecToCtl_port_sync <= false;
    wait for 5 ns;
    MemToDec_port <= "00000100100000000000001011101111";
    MemToDec_port_sync <= true;
    wait until DecToCtl_port_notify = true;
    MemToDec_port_sync <= false;
    assert DecToCtl_port.encType   = J                   report "unexpected value for DecToCtl_port.encType"   severity warning;
    assert DecToCtl_port.imm       = to_unsigned(72, 32) report "unexpected value for DecToCtl_port.imm"       severity warning;
    assert DecToCtl_port.instrType = jal                 report "unexpected value for DecToCtl_port.instrType" severity warning;
    assert DecToCtl_port.rd_addr   = to_unsigned(5, 32)  report "unexpected value for DecToCtl_port.rd_addr"   severity warning;
    assert DecToCtl_port.rs1_addr  = to_unsigned(0, 32)  report "unexpected value for DecToCtl_port.rs1_addr"  severity warning;
    assert DecToCtl_port.rs2_addr  = to_unsigned(8, 32)  report "unexpected value for DecToCtl_port.rs2_addr"  severity warning;
    wait for 5 ns;
    DecToCtl_port_sync <= true;

    -- sw $2, $3(92)
    wait until MemToDec_port_notify = true;
    DecToCtl_port_sync <= false;
    wait for 5 ns;
    MemToDec_port <= "00000100001100010010111000100011";
    MemToDec_port_sync <= true;
    wait until DecToCtl_port_notify = true;
    MemToDec_port_sync <= false;
    assert DecToCtl_port.encType   = S                   report "unexpected value for DecToCtl_port.encType"   severity warning;
    assert DecToCtl_port.imm       = to_unsigned(92, 32) report "unexpected value for DecToCtl_port.imm"       severity warning;
    assert DecToCtl_port.instrType = sw                  report "unexpected value for DecToCtl_port.instrType" severity warning;
    assert DecToCtl_port.rd_addr   = to_unsigned(28, 32) report "unexpected value for DecToCtl_port.rd_addr"   severity warning;
    assert DecToCtl_port.rs1_addr  = to_unsigned(2, 32)  report "unexpected value for DecToCtl_port.rs1_addr"  severity warning;
    assert DecToCtl_port.rs2_addr  = to_unsigned(3, 32)  report "unexpected value for DecToCtl_port.rs2_addr"  severity warning;
    wait for 5 ns;
    DecToCtl_port_sync <= true;

    wait;

    end process stimuli;


end architecture;





















































