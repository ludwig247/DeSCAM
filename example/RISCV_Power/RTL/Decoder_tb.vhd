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
            CtlToDec_port        : in  Unsigned (31 downto 0);
            CtlToDec_port_sync   : in  bool;
            DecToCtl_port        : out DecodedInstr
        );
    end component;

    -- Input
    signal clk                : std_logic := '0';
    signal rst                : std_logic;
    signal CtlToDec_port      : Unsigned (31 downto 0);
    signal CtlToDec_port_sync : bool;

    -- Output
    signal DecToCtl_port        : DecodedInstr;



begin

    -- Clock
    clk <= not clk  after  10 ns;

    -- Reset
    rst <= '1', '0' after  20 ns;

    dut: Decoder
        port map (
            clk                  => clk,
            rst                  => rst,
            CtlToDec_port        => CtlToDec_port,
            CtlToDec_port_sync   => CtlToDec_port_sync,
            DecToCtl_port        => DecToCtl_port

        );


    stimuli: process
    begin

    -- addi $5,$1,9
    wait for 25 ns;
    CtlToDec_port <= "00000000100100001000001010010011";
    CtlToDec_port_sync <= true;
    wait for 20 ns;
    CtlToDec_port_sync <= false;
    assert DecToCtl_port.encType   = I                  report "unexpected value for DecToCtl_port.encType"   severity warning;
    assert DecToCtl_port.imm       = to_unsigned(9, 32) report "unexpected value for DecToCtl_port.imm"       severity warning;
    assert DecToCtl_port.instrType = addi               report "unexpected value for DecToCtl_port.instrType" severity warning;
    assert DecToCtl_port.rd_addr   = to_unsigned(5, 32) report "unexpected value for DecToCtl_port.rd_addr"   severity warning;
    assert DecToCtl_port.rs1_addr  = to_unsigned(1, 32) report "unexpected value for DecToCtl_port.rs1_addr"  severity warning;
    assert DecToCtl_port.rs2_addr  = to_unsigned(9, 32) report "unexpected value for DecToCtl_port.rs2_addr"  severity warning;



    -- addi $5,$1,-7
    wait for 20 ns;
    CtlToDec_port <= "11111111100100001000001010010011";
    CtlToDec_port_sync <= true;
    wait for 20 ns;
    CtlToDec_port_sync <= false;
    assert DecToCtl_port.encType   = I                           report "unexpected value for DecToCtl_port.encType"   severity warning;
    assert DecToCtl_port.imm       = unsigned(to_signed(-7, 32)) report "unexpected value for DecToCtl_port.imm"       severity warning;
    assert DecToCtl_port.instrType = addi                        report "unexpected value for DecToCtl_port.instrType" severity warning;
    assert DecToCtl_port.rd_addr   = to_unsigned(5, 32)          report "unexpected value for DecToCtl_port.rd_addr"   severity warning;
    assert DecToCtl_port.rs1_addr  = to_unsigned(1, 32)          report "unexpected value for DecToCtl_port.rs1_addr"  severity warning;
    assert DecToCtl_port.rs2_addr  = to_unsigned(25, 32)         report "unexpected value for DecToCtl_port.rs2_addr"  severity warning;



    -- srai $3,$2,4
    wait for 20 ns;
    CtlToDec_port <= "01000000010000010101000110010011";
    CtlToDec_port_sync <= true;
    wait for 20 ns;
    CtlToDec_port_sync <= false;
    assert DecToCtl_port.encType   = I                  report "unexpected value for DecToCtl_port.encType"   severity warning;
    assert DecToCtl_port.imm       = to_unsigned(4, 32) report "unexpected value for DecToCtl_port.imm"       severity warning;
    assert DecToCtl_port.instrType = sraI               report "unexpected value for DecToCtl_port.instrType" severity warning;
    assert DecToCtl_port.rd_addr   = to_unsigned(3, 32) report "unexpected value for DecToCtl_port.rd_addr"   severity warning;
    assert DecToCtl_port.rs1_addr  = to_unsigned(2, 32) report "unexpected value for DecToCtl_port.rs1_addr"  severity warning;
    assert DecToCtl_port.rs2_addr  = to_unsigned(4, 32) report "unexpected value for DecToCtl_port.rs2_addr"  severity warning;



    -- xor $3,$1,$2
    wait for 20 ns;
    CtlToDec_port <= "00000000001000001100000110110011";
    CtlToDec_port_sync <= true;
    wait for 20 ns;
    CtlToDec_port_sync <= false;
    assert DecToCtl_port.encType   = R                  report "unexpected value for DecToCtl_port.encType"   severity warning;
    assert DecToCtl_port.imm       = to_unsigned(0, 32) report "unexpected value for DecToCtl_port.imm"       severity warning;
    assert DecToCtl_port.instrType = Xor_Instr          report "unexpected value for DecToCtl_port.instrType" severity warning;
    assert DecToCtl_port.rd_addr   = to_unsigned(3, 32) report "unexpected value for DecToCtl_port.rd_addr"   severity warning;
    assert DecToCtl_port.rs1_addr  = to_unsigned(1, 32) report "unexpected value for DecToCtl_port.rs1_addr"  severity warning;
    assert DecToCtl_port.rs2_addr  = to_unsigned(2, 32) report "unexpected value for DecToCtl_port.rs2_addr"  severity warning;



    -- bne $1,$2,24
    wait for 20 ns;
    CtlToDec_port <= "00000000001000001001110001100011";
    CtlToDec_port_sync <= true;
    wait for 20 ns;
    CtlToDec_port_sync <= false;
    assert DecToCtl_port.encType   = B                   report "unexpected value for DecToCtl_port.encType"   severity warning;
    assert DecToCtl_port.imm       = to_unsigned(24, 32) report "unexpected value for DecToCtl_port.imm"       severity warning;
    assert DecToCtl_port.instrType = bne                 report "unexpected value for DecToCtl_port.instrType" severity warning;
    assert DecToCtl_port.rd_addr   = to_unsigned(24, 32) report "unexpected value for DecToCtl_port.rd_addr"   severity warning;
    assert DecToCtl_port.rs1_addr  = to_unsigned(1, 32)  report "unexpected value for DecToCtl_port.rs1_addr"  severity warning;
    assert DecToCtl_port.rs2_addr  = to_unsigned(2, 32)  report "unexpected value for DecToCtl_port.rs2_addr"  severity warning;



    -- lw $3,$1(-20)
    wait for 20 ns;
    CtlToDec_port <= "11111110110000001010000110000011";
    CtlToDec_port_sync <= true;
    wait for 20 ns;
    CtlToDec_port_sync <= false;
    assert DecToCtl_port.encType   = I                             report "unexpected value for DecToCtl_port.encType"   severity warning;
    assert DecToCtl_port.imm       = unsigned(to_signed(-20, 32))  report "unexpected value for DecToCtl_port.imm"       severity warning;
    assert DecToCtl_port.instrType = lw                            report "unexpected value for DecToCtl_port.instrType" severity warning;
    assert DecToCtl_port.rd_addr   = to_unsigned(3, 32)            report "unexpected value for DecToCtl_port.rd_addr"   severity warning;
    assert DecToCtl_port.rs1_addr  = to_unsigned(1, 32)            report "unexpected value for DecToCtl_port.rs1_addr"  severity warning;
    assert DecToCtl_port.rs2_addr  = to_unsigned(12, 32)           report "unexpected value for DecToCtl_port.rs2_addr"  severity warning;



    -- jal $5, 72
    wait for 20 ns;
    CtlToDec_port <= "00000100100000000000001011101111";
    CtlToDec_port_sync <= true;
    wait for 20 ns;
    CtlToDec_port_sync <= false;
    assert DecToCtl_port.encType   = J                   report "unexpected value for DecToCtl_port.encType"   severity warning;
    assert DecToCtl_port.imm       = to_unsigned(72, 32) report "unexpected value for DecToCtl_port.imm"       severity warning;
    assert DecToCtl_port.instrType = jal                 report "unexpected value for DecToCtl_port.instrType" severity warning;
    assert DecToCtl_port.rd_addr   = to_unsigned(5, 32)  report "unexpected value for DecToCtl_port.rd_addr"   severity warning;
    assert DecToCtl_port.rs1_addr  = to_unsigned(0, 32)  report "unexpected value for DecToCtl_port.rs1_addr"  severity warning;
    assert DecToCtl_port.rs2_addr  = to_unsigned(8, 32)  report "unexpected value for DecToCtl_port.rs2_addr"  severity warning;



    -- sw $2, $3(92)
    wait for 20 ns;
    CtlToDec_port <= "00000100001100010010111000100011";
    CtlToDec_port_sync <= true;
    wait for 20 ns;
    CtlToDec_port_sync <= false;
    assert DecToCtl_port.encType   = S                   report "unexpected value for DecToCtl_port.encType"   severity warning;
    assert DecToCtl_port.imm       = to_unsigned(92, 32) report "unexpected value for DecToCtl_port.imm"       severity warning;
    assert DecToCtl_port.instrType = sw                  report "unexpected value for DecToCtl_port.instrType" severity warning;
    assert DecToCtl_port.rd_addr   = to_unsigned(28, 32) report "unexpected value for DecToCtl_port.rd_addr"   severity warning;
    assert DecToCtl_port.rs1_addr  = to_unsigned(2, 32)  report "unexpected value for DecToCtl_port.rs1_addr"  severity warning;
    assert DecToCtl_port.rs2_addr  = to_unsigned(3, 32)  report "unexpected value for DecToCtl_port.rs2_addr"  severity warning;



    wait;

    end process stimuli;


end architecture;





















































