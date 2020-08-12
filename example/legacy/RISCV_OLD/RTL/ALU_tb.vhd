--
-- Created by deutschmann on 07.02.18
--

library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use work.SCAM_Model_types.all;

entity ALU_tb is
end entity ALU_tb;

architecture sim of ALU_tb is
    component ALU is
        port (
            clk                  : in  std_logic;
            rst                  : in  std_logic;
            ALUtoCtl_port        : out ALUtoCtl_IF;
            ALUtoCtl_port_sync   : in  bool;
            ALUtoCtl_port_notify : out bool;
            CtlToALU_port        : in  CtlToALU_IF;
            CtlToALU_port_sync   : in  bool;
            CtlToALU_port_notify : out bool
        );
    end component;

    -- Input
    signal clk                  : std_logic := '0';
    signal rst                  : std_logic;
    signal ALUtoCtl_port_sync   : bool;
    signal CtlToALU_port        : CtlToALU_IF;
    signal CtlToALU_port_sync   : bool;

    -- Output
    signal ALUtoCtl_port        : ALUtoCtl_IF;
    signal ALUtoCtl_port_notify : bool;
    signal CtlToALU_port_notify : bool;

begin

    -- Clock
    clk <= not clk  after  10 ns;

    -- Reset
    rst <= '1', '0' after  20 ns;

    dut: ALU
        port map (
            clk                  => clk,
            rst                  => rst,
            ALUtoCtl_port        => ALUtoCtl_port,
            ALUtoCtl_port_sync   => ALUtoCtl_port_sync,
            ALUtoCtl_port_notify => ALUtoCtl_port_notify,
            CtlToALU_port        => CtlToALU_port,
            CtlToALU_port_sync   => CtlToALU_port_sync,
            CtlToALU_port_notify => CtlToALU_port_notify

        );


    stimuli: process
    begin

    ------------- ADDI R1 (= 7) + 5 -------------
    wait until CtlToALU_port_notify = true;
    ALUtoCtl_port_sync <= false;
    wait for 5 ns;
    CtlToALU_port.alu_fun       <= ALU_ADD;
    CtlToALU_port.imm           <= to_unsigned(5, 32);
    CtlToALU_port.op1_sel       <= OP_REG;
    CtlToALU_port.op2_sel       <= OP_IMM;
    CtlToALU_port.pc_reg        <= to_unsigned(0, 32);
    CtlToALU_port.reg1_contents <= to_unsigned(7, 32);
    CtlToALU_port.reg2_contents <= to_unsigned(0, 32);
    CtlToALU_port_sync <= true;
    wait until ALUtoCtl_port_notify = true;
    CtlToALU_port_sync <= false;
    assert ALUtoCtl_port.ALU_result = to_unsigned(12, 32) report "unexpected value for result" severity warning;
    wait for 5 ns;
    ALUtoCtl_port_sync <= true;

    ------------ ADDI R1 (= 7) + (-9) -----------
    wait until CtlToALU_port_notify = true;
    ALUtoCtl_port_sync <= false;
    wait for 5 ns;
    CtlToALU_port.alu_fun       <= ALU_ADD;
    CtlToALU_port.imm           <= unsigned(to_signed(-9, 32));
    CtlToALU_port.op1_sel       <= OP_REG;
    CtlToALU_port.op2_sel       <= OP_IMM;
    CtlToALU_port.pc_reg        <= to_unsigned(0, 32);
    CtlToALU_port.reg1_contents <= to_unsigned(7, 32);
    CtlToALU_port.reg2_contents <= to_unsigned(0, 32);
    CtlToALU_port_sync <= true;
    wait until ALUtoCtl_port_notify = true;
    CtlToALU_port_sync <= false;
    assert ALUtoCtl_port.ALU_result = unsigned(to_signed(-2, 32)) report "unexpected value for result" severity warning;
    wait for 5 ns;
    ALUtoCtl_port_sync <= true;

    ---------- SUB R1 (= 7) - R2 (= 5) ----------
    wait until CtlToALU_port_notify = true;
    ALUtoCtl_port_sync <= false;
    wait for 5 ns;
    CtlToALU_port.alu_fun       <= ALU_SUB;
    CtlToALU_port.imm           <= to_unsigned(0, 32);
    CtlToALU_port.op1_sel       <= OP_REG;
    CtlToALU_port.op2_sel       <= OP_REG;
    CtlToALU_port.pc_reg        <= to_unsigned(0, 32);
    CtlToALU_port.reg1_contents <= to_unsigned(7, 32);
    CtlToALU_port.reg2_contents <= to_unsigned(5, 32);
    CtlToALU_port_sync <= true;
    wait until ALUtoCtl_port_notify = true;
    CtlToALU_port_sync <= false;
    assert ALUtoCtl_port.ALU_result = to_unsigned(2, 32) report "unexpected value for result" severity warning;
    wait for 5 ns;
    ALUtoCtl_port_sync <= true;

    ---------- SUB R1 (= 7) - R2 (= 9) ----------
    wait until CtlToALU_port_notify = true;
    ALUtoCtl_port_sync <= false;
    wait for 5 ns;
    CtlToALU_port.alu_fun       <= ALU_SUB;
    CtlToALU_port.imm           <= to_unsigned(0, 32);
    CtlToALU_port.op1_sel       <= OP_REG;
    CtlToALU_port.op2_sel       <= OP_REG;
    CtlToALU_port.pc_reg        <= to_unsigned(0, 32);
    CtlToALU_port.reg1_contents <= to_unsigned(7, 32);
    CtlToALU_port.reg2_contents <= to_unsigned(9, 32);
    CtlToALU_port_sync <= true;
    wait until ALUtoCtl_port_notify = true;
    CtlToALU_port_sync <= false;
    assert ALUtoCtl_port.ALU_result = unsigned(to_signed(-2, 32)) report "unexpected value for result" severity warning;
    wait for 5 ns;
    ALUtoCtl_port_sync <= true;

    -------------------- AND --------------------
    wait until CtlToALU_port_notify = true;
    ALUtoCtl_port_sync <= false;
    wait for 5 ns;
    CtlToALU_port.alu_fun       <= ALU_AND;
    CtlToALU_port.imm           <= to_unsigned(0, 32);
    CtlToALU_port.op1_sel       <= OP_REG;
    CtlToALU_port.op2_sel       <= OP_REG;
    CtlToALU_port.pc_reg        <= to_unsigned(0, 32);
    CtlToALU_port.reg1_contents <= "01010101010101010101010101010101";
    CtlToALU_port.reg2_contents <= "00000000000000001111111111111111";
    CtlToALU_port_sync <= true;
    wait until ALUtoCtl_port_notify = true;
    CtlToALU_port_sync <= false;
    assert ALUtoCtl_port.ALU_result = "00000000000000000101010101010101" report "unexpected value for result" severity warning;
    wait for 5 ns;
    ALUtoCtl_port_sync <= true;

    --------------------- OR --------------------
    wait until CtlToALU_port_notify = true;
    ALUtoCtl_port_sync <= false;
    wait for 5 ns;
    CtlToALU_port.alu_fun       <= ALU_OR;
    CtlToALU_port.imm           <= to_unsigned(0, 32);
    CtlToALU_port.op1_sel       <= OP_REG;
    CtlToALU_port.op2_sel       <= OP_REG;
    CtlToALU_port.pc_reg        <= to_unsigned(0, 32);
    CtlToALU_port.reg1_contents <= "01010101010101010101010101010101";
    CtlToALU_port.reg2_contents <= "00000000000000001111111111111111";
    CtlToALU_port_sync <= true;
    wait until ALUtoCtl_port_notify = true;
    CtlToALU_port_sync <= false;
    assert ALUtoCtl_port.ALU_result = "01010101010101011111111111111111" report "unexpected value for result" severity warning;
    wait for 5 ns;
    ALUtoCtl_port_sync <= true;

    -------------------- XOR --------------------
    wait until CtlToALU_port_notify = true;
    ALUtoCtl_port_sync <= false;
    wait for 5 ns;
    CtlToALU_port.alu_fun       <= ALU_XOR;
    CtlToALU_port.imm           <= to_unsigned(0, 32);
    CtlToALU_port.op1_sel       <= OP_REG;
    CtlToALU_port.op2_sel       <= OP_REG;
    CtlToALU_port.pc_reg        <= to_unsigned(0, 32);
    CtlToALU_port.reg1_contents <= "01010101010101010101010101010101";
    CtlToALU_port.reg2_contents <= "00000000000000001111111111111111";
    CtlToALU_port_sync <= true;
    wait until ALUtoCtl_port_notify = true;
    CtlToALU_port_sync <= false;
    assert ALUtoCtl_port.ALU_result = "01010101010101011010101010101010" report "unexpected value for result" severity warning;
    wait for 5 ns;
    ALUtoCtl_port_sync <= true;

    ----------- SLT R1 (= 5) R2 (= 7) -----------
    wait until CtlToALU_port_notify = true;
    ALUtoCtl_port_sync <= false;
    wait for 5 ns;
    CtlToALU_port.alu_fun       <= ALU_SLT;
    CtlToALU_port.imm           <= to_unsigned(0, 32);
    CtlToALU_port.op1_sel       <= OP_REG;
    CtlToALU_port.op2_sel       <= OP_REG;
    CtlToALU_port.pc_reg        <= to_unsigned(0, 32);
    CtlToALU_port.reg1_contents <= to_unsigned(5, 32);
    CtlToALU_port.reg2_contents <= to_unsigned(7, 32);
    CtlToALU_port_sync <= true;
    wait until ALUtoCtl_port_notify = true;
    CtlToALU_port_sync <= false;
    assert ALUtoCtl_port.ALU_result = to_unsigned(1, 32) report "unexpected value for result" severity warning;
    wait for 5 ns;
    ALUtoCtl_port_sync <= true;

    ---------- SLT R1 (= 5) R2 (= -2) -----------
    wait until CtlToALU_port_notify = true;
    ALUtoCtl_port_sync <= false;
    wait for 5 ns;
    CtlToALU_port.alu_fun       <= ALU_SLT;
    CtlToALU_port.imm           <= to_unsigned(0, 32);
    CtlToALU_port.op1_sel       <= OP_REG;
    CtlToALU_port.op2_sel       <= OP_REG;
    CtlToALU_port.pc_reg        <= to_unsigned(0, 32);
    CtlToALU_port.reg1_contents <= to_unsigned(5, 32);
    CtlToALU_port.reg2_contents <= unsigned(to_signed(-2, 32));
    CtlToALU_port_sync <= true;
    wait until ALUtoCtl_port_notify = true;
    CtlToALU_port_sync <= false;
    assert ALUtoCtl_port.ALU_result = to_unsigned(0, 32) report "unexpected value for result" severity warning;
    wait for 5 ns;
    ALUtoCtl_port_sync <= true;

    ---------- SLTU R1 (= 5) R2 (= 7) -----------
    wait until CtlToALU_port_notify = true;
    ALUtoCtl_port_sync <= false;
    wait for 5 ns;
    CtlToALU_port.alu_fun       <= ALU_SLTU;
    CtlToALU_port.imm           <= to_unsigned(0, 32);
    CtlToALU_port.op1_sel       <= OP_REG;
    CtlToALU_port.op2_sel       <= OP_REG;
    CtlToALU_port.pc_reg        <= to_unsigned(0, 32);
    CtlToALU_port.reg1_contents <= to_unsigned(5, 32);
    CtlToALU_port.reg2_contents <= to_unsigned(7, 32);
    CtlToALU_port_sync <= true;
    wait until ALUtoCtl_port_notify = true;
    CtlToALU_port_sync <= false;
    assert ALUtoCtl_port.ALU_result = to_unsigned(1, 32) report "unexpected value for result" severity warning;
    wait for 5 ns;
    ALUtoCtl_port_sync <= true;

    -------- SLTU R1 (= 5) R2 (= "-2") ----------
    wait until CtlToALU_port_notify = true;
    ALUtoCtl_port_sync <= false;
    wait for 5 ns;
    CtlToALU_port.alu_fun       <= ALU_SLTU;
    CtlToALU_port.imm           <= to_unsigned(0, 32);
    CtlToALU_port.op1_sel       <= OP_REG;
    CtlToALU_port.op2_sel       <= OP_REG;
    CtlToALU_port.pc_reg        <= to_unsigned(0, 32);
    CtlToALU_port.reg1_contents <= to_unsigned(5, 32);
    CtlToALU_port.reg2_contents <= unsigned(to_signed(-2, 32));
    CtlToALU_port_sync <= true;
    wait until ALUtoCtl_port_notify = true;
    CtlToALU_port_sync <= false;
    assert ALUtoCtl_port.ALU_result = to_unsigned(1, 32) report "unexpected value for result" severity warning;
    wait for 5 ns;
    ALUtoCtl_port_sync <= true;

    ----------------- SLL R1 2 ------------------
    wait until CtlToALU_port_notify = true;
    ALUtoCtl_port_sync <= false;
    wait for 5 ns;
    CtlToALU_port.alu_fun       <= ALU_SLL;
    CtlToALU_port.imm           <= to_unsigned(2, 32);
    CtlToALU_port.op1_sel       <= OP_REG;
    CtlToALU_port.op2_sel       <= OP_IMM;
    CtlToALU_port.pc_reg        <= to_unsigned(0, 32);
    CtlToALU_port.reg1_contents <= "11111100111111111111111111111111";
    CtlToALU_port.reg2_contents <= to_unsigned(0, 32);
    CtlToALU_port_sync <= true;
    wait until ALUtoCtl_port_notify = true;
    CtlToALU_port_sync <= false;
    assert ALUtoCtl_port.ALU_result = "11110011111111111111111111111100" report "unexpected value for result" severity warning;
    wait for 5 ns;
    ALUtoCtl_port_sync <= true;

    ----------------- SRA R1 2 ------------------
    wait until CtlToALU_port_notify = true;
    ALUtoCtl_port_sync <= false;
    wait for 5 ns;
    CtlToALU_port.alu_fun       <= ALU_SRA;
    CtlToALU_port.imm           <= to_unsigned(2, 32);
    CtlToALU_port.op1_sel       <= OP_REG;
    CtlToALU_port.op2_sel       <= OP_IMM;
    CtlToALU_port.pc_reg        <= to_unsigned(0, 32);
    CtlToALU_port.reg1_contents <= "11111100111111111111111111111111";
    CtlToALU_port.reg2_contents <= to_unsigned(0, 32);
    CtlToALU_port_sync <= true;
    wait until ALUtoCtl_port_notify = true;
    CtlToALU_port_sync <= false;
    assert ALUtoCtl_port.ALU_result = "11111111001111111111111111111111" report "unexpected value for result" severity warning;
    wait for 5 ns;
    ALUtoCtl_port_sync <= true;

    ----------------- SRL R1 2 ------------------
    wait until CtlToALU_port_notify = true;
    ALUtoCtl_port_sync <= false;
    wait for 5 ns;
    CtlToALU_port.alu_fun       <= ALU_SRL;
    CtlToALU_port.imm           <= to_unsigned(2, 32);
    CtlToALU_port.op1_sel       <= OP_REG;
    CtlToALU_port.op2_sel       <= OP_IMM;
    CtlToALU_port.pc_reg        <= to_unsigned(0, 32);
    CtlToALU_port.reg1_contents <= "11111100111111111111111111111111";
    CtlToALU_port.reg2_contents <= to_unsigned(0, 32);
    CtlToALU_port_sync <= true;
    wait until ALUtoCtl_port_notify = true;
    CtlToALU_port_sync <= false;
    assert ALUtoCtl_port.ALU_result = "00111111001111111111111111111111" report "unexpected value for result" severity warning;
    wait for 5 ns;
    ALUtoCtl_port_sync <= true;

    -------------- COPY R1 (= 42) ---------------
    wait until CtlToALU_port_notify = true;
    ALUtoCtl_port_sync <= false;
    wait for 5 ns;
    CtlToALU_port.alu_fun       <= ALU_COPY1;
    CtlToALU_port.imm           <= to_unsigned(0, 32);
    CtlToALU_port.op1_sel       <= OP_REG;
    CtlToALU_port.op2_sel       <= OP_X;
    CtlToALU_port.pc_reg        <= to_unsigned(0, 32);
    CtlToALU_port.reg1_contents <= to_unsigned(42, 32);
    CtlToALU_port.reg2_contents <= to_unsigned(0, 32);
    CtlToALU_port_sync <= true;
    wait until ALUtoCtl_port_notify = true;
    CtlToALU_port_sync <= false;
    assert ALUtoCtl_port.ALU_result = to_unsigned(42, 32) report "unexpected value for result" severity warning;
    wait for 5 ns;
    ALUtoCtl_port_sync <= true;




    wait;

    end process stimuli;


end architecture;





















































