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
            CtlToALU_port        : in  CtlToALU_IF;
            CtlToALU_port_sync   : in  bool
        );
    end component;

    -- Input
    signal clk                  : std_logic := '0';
    signal rst                  : std_logic;
    signal CtlToALU_port        : CtlToALU_IF;
    signal CtlToALU_port_sync   : bool;

    -- Output
    signal ALUtoCtl_port        : ALUtoCtl_IF;

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
            CtlToALU_port        => CtlToALU_port,
            CtlToALU_port_sync   => CtlToALU_port_sync

        );


    stimuli: process
    begin

    ------------- ADDI R1 (= 7) + 5 -------------
    wait for 25 ns;
    CtlToALU_port.alu_fun       <= ALU_ADD;
    CtlToALU_port.imm           <= to_unsigned(5, 32);
    CtlToALU_port.op1_sel       <= OP_REG;
    CtlToALU_port.op2_sel       <= OP_IMM;
    CtlToALU_port.pc_reg        <= to_unsigned(0, 32);
    CtlToALU_port.reg1_contents <= to_unsigned(7, 32);
    CtlToALU_port.reg2_contents <= to_unsigned(0, 32);
    CtlToALU_port_sync <= true;
    wait for 20 ns;
    CtlToALU_port_sync <= false;
    assert ALUtoCtl_port.ALU_result = to_unsigned(12, 32) report "unexpected value for result" severity warning;
    

    ------------ ADDI R1 (= 7) + (-9) -----------
    wait for 20 ns;
    CtlToALU_port.alu_fun       <= ALU_ADD;
    CtlToALU_port.imm           <= unsigned(to_signed(-9, 32));
    CtlToALU_port.op1_sel       <= OP_REG;
    CtlToALU_port.op2_sel       <= OP_IMM;
    CtlToALU_port.pc_reg        <= to_unsigned(0, 32);
    CtlToALU_port.reg1_contents <= to_unsigned(7, 32);
    CtlToALU_port.reg2_contents <= to_unsigned(0, 32);
    CtlToALU_port_sync <= true;
    wait for 20 ns;
    CtlToALU_port_sync <= false;
    assert ALUtoCtl_port.ALU_result = unsigned(to_signed(-2, 32)) report "unexpected value for result" severity warning;
    

    ---------- SUB R1 (= 7) - R2 (= 5) ----------
    wait for 20 ns;
    CtlToALU_port.alu_fun       <= ALU_SUB;
    CtlToALU_port.imm           <= to_unsigned(0, 32);
    CtlToALU_port.op1_sel       <= OP_REG;
    CtlToALU_port.op2_sel       <= OP_REG;
    CtlToALU_port.pc_reg        <= to_unsigned(0, 32);
    CtlToALU_port.reg1_contents <= to_unsigned(7, 32);
    CtlToALU_port.reg2_contents <= to_unsigned(5, 32);
    CtlToALU_port_sync <= true;
    wait for 20 ns;
    CtlToALU_port_sync <= false;
    assert ALUtoCtl_port.ALU_result = to_unsigned(2, 32) report "unexpected value for result" severity warning;
    

    ---------- SUB R1 (= 7) - R2 (= 9) ----------
    wait for 20 ns;
    CtlToALU_port.alu_fun       <= ALU_SUB;
    CtlToALU_port.imm           <= to_unsigned(0, 32);
    CtlToALU_port.op1_sel       <= OP_REG;
    CtlToALU_port.op2_sel       <= OP_REG;
    CtlToALU_port.pc_reg        <= to_unsigned(0, 32);
    CtlToALU_port.reg1_contents <= to_unsigned(7, 32);
    CtlToALU_port.reg2_contents <= to_unsigned(9, 32);
    CtlToALU_port_sync <= true;
    wait for 20 ns;
    CtlToALU_port_sync <= false;
    assert ALUtoCtl_port.ALU_result = unsigned(to_signed(-2, 32)) report "unexpected value for result" severity warning;
    

    -------------------- AND --------------------
    wait for 20 ns;
    CtlToALU_port.alu_fun       <= ALU_AND;
    CtlToALU_port.imm           <= to_unsigned(0, 32);
    CtlToALU_port.op1_sel       <= OP_REG;
    CtlToALU_port.op2_sel       <= OP_REG;
    CtlToALU_port.pc_reg        <= to_unsigned(0, 32);
    CtlToALU_port.reg1_contents <= "01010101010101010101010101010101";
    CtlToALU_port.reg2_contents <= "00000000000000001111111111111111";
    CtlToALU_port_sync <= true;
    wait for 20 ns;
    CtlToALU_port_sync <= false;
    assert ALUtoCtl_port.ALU_result = "00000000000000000101010101010101" report "unexpected value for result" severity warning;
    

    --------------------- OR --------------------
    wait for 20 ns;
    CtlToALU_port.alu_fun       <= ALU_OR;
    CtlToALU_port.imm           <= to_unsigned(0, 32);
    CtlToALU_port.op1_sel       <= OP_REG;
    CtlToALU_port.op2_sel       <= OP_REG;
    CtlToALU_port.pc_reg        <= to_unsigned(0, 32);
    CtlToALU_port.reg1_contents <= "01010101010101010101010101010101";
    CtlToALU_port.reg2_contents <= "00000000000000001111111111111111";
    CtlToALU_port_sync <= true;
    wait for 20 ns;
    CtlToALU_port_sync <= false;
    assert ALUtoCtl_port.ALU_result = "01010101010101011111111111111111" report "unexpected value for result" severity warning;
    

    -------------------- XOR --------------------
    wait for 20 ns;
    CtlToALU_port.alu_fun       <= ALU_XOR;
    CtlToALU_port.imm           <= to_unsigned(0, 32);
    CtlToALU_port.op1_sel       <= OP_REG;
    CtlToALU_port.op2_sel       <= OP_REG;
    CtlToALU_port.pc_reg        <= to_unsigned(0, 32);
    CtlToALU_port.reg1_contents <= "01010101010101010101010101010101";
    CtlToALU_port.reg2_contents <= "00000000000000001111111111111111";
    CtlToALU_port_sync <= true;
    wait for 20 ns;
    CtlToALU_port_sync <= false;
    assert ALUtoCtl_port.ALU_result = "01010101010101011010101010101010" report "unexpected value for result" severity warning;
    

    ----------- SLT R1 (= 5) R2 (= 7) -----------
    wait for 20 ns;
    CtlToALU_port.alu_fun       <= ALU_SLT;
    CtlToALU_port.imm           <= to_unsigned(0, 32);
    CtlToALU_port.op1_sel       <= OP_REG;
    CtlToALU_port.op2_sel       <= OP_REG;
    CtlToALU_port.pc_reg        <= to_unsigned(0, 32);
    CtlToALU_port.reg1_contents <= to_unsigned(5, 32);
    CtlToALU_port.reg2_contents <= to_unsigned(7, 32);
    CtlToALU_port_sync <= true;
    wait for 20 ns;
    CtlToALU_port_sync <= false;
    assert ALUtoCtl_port.ALU_result = to_unsigned(1, 32) report "unexpected value for result" severity warning;
    

    ---------- SLT R1 (= 5) R2 (= -2) -----------
    wait for 20 ns;
    CtlToALU_port.alu_fun       <= ALU_SLT;
    CtlToALU_port.imm           <= to_unsigned(0, 32);
    CtlToALU_port.op1_sel       <= OP_REG;
    CtlToALU_port.op2_sel       <= OP_REG;
    CtlToALU_port.pc_reg        <= to_unsigned(0, 32);
    CtlToALU_port.reg1_contents <= to_unsigned(5, 32);
    CtlToALU_port.reg2_contents <= unsigned(to_signed(-2, 32));
    CtlToALU_port_sync <= true;
    wait for 20 ns;
    CtlToALU_port_sync <= false;
    assert ALUtoCtl_port.ALU_result = to_unsigned(0, 32) report "unexpected value for result" severity warning;
    

    ---------- SLTU R1 (= 5) R2 (= 7) -----------
    wait for 20 ns;
    CtlToALU_port.alu_fun       <= ALU_SLTU;
    CtlToALU_port.imm           <= to_unsigned(0, 32);
    CtlToALU_port.op1_sel       <= OP_REG;
    CtlToALU_port.op2_sel       <= OP_REG;
    CtlToALU_port.pc_reg        <= to_unsigned(0, 32);
    CtlToALU_port.reg1_contents <= to_unsigned(5, 32);
    CtlToALU_port.reg2_contents <= to_unsigned(7, 32);
    CtlToALU_port_sync <= true;
    wait for 20 ns;
    CtlToALU_port_sync <= false;
    assert ALUtoCtl_port.ALU_result = to_unsigned(1, 32) report "unexpected value for result" severity warning;
    

    -------- SLTU R1 (= 5) R2 (= "-2") ----------
    wait for 20 ns;
    CtlToALU_port.alu_fun       <= ALU_SLTU;
    CtlToALU_port.imm           <= to_unsigned(0, 32);
    CtlToALU_port.op1_sel       <= OP_REG;
    CtlToALU_port.op2_sel       <= OP_REG;
    CtlToALU_port.pc_reg        <= to_unsigned(0, 32);
    CtlToALU_port.reg1_contents <= to_unsigned(5, 32);
    CtlToALU_port.reg2_contents <= unsigned(to_signed(-2, 32));
    CtlToALU_port_sync <= true;
    wait for 20 ns;
    CtlToALU_port_sync <= false;
    assert ALUtoCtl_port.ALU_result = to_unsigned(1, 32) report "unexpected value for result" severity warning;
    

    ----------------- SLL R1 2 ------------------
    wait for 20 ns;
    CtlToALU_port.alu_fun       <= ALU_SLL;
    CtlToALU_port.imm           <= to_unsigned(2, 32);
    CtlToALU_port.op1_sel       <= OP_REG;
    CtlToALU_port.op2_sel       <= OP_IMM;
    CtlToALU_port.pc_reg        <= to_unsigned(0, 32);
    CtlToALU_port.reg1_contents <= "11111100111111111111111111111111";
    CtlToALU_port.reg2_contents <= to_unsigned(0, 32);
    CtlToALU_port_sync <= true;
    wait for 20 ns;
    CtlToALU_port_sync <= false;
    assert ALUtoCtl_port.ALU_result = "11110011111111111111111111111100" report "unexpected value for result" severity warning;
    

    ----------------- SRA R1 2 ------------------
    wait for 20 ns;
    CtlToALU_port.alu_fun       <= ALU_SRA;
    CtlToALU_port.imm           <= to_unsigned(2, 32);
    CtlToALU_port.op1_sel       <= OP_REG;
    CtlToALU_port.op2_sel       <= OP_IMM;
    CtlToALU_port.pc_reg        <= to_unsigned(0, 32);
    CtlToALU_port.reg1_contents <= "11111100111111111111111111111111";
    CtlToALU_port.reg2_contents <= to_unsigned(0, 32);
    CtlToALU_port_sync <= true;
    wait for 20 ns;
    CtlToALU_port_sync <= false;
    assert ALUtoCtl_port.ALU_result = "11111111001111111111111111111111" report "unexpected value for result" severity warning;
    

    ----------------- SRL R1 2 ------------------
    wait for 20 ns;
    CtlToALU_port.alu_fun       <= ALU_SRL;
    CtlToALU_port.imm           <= to_unsigned(2, 32);
    CtlToALU_port.op1_sel       <= OP_REG;
    CtlToALU_port.op2_sel       <= OP_IMM;
    CtlToALU_port.pc_reg        <= to_unsigned(0, 32);
    CtlToALU_port.reg1_contents <= "11111100111111111111111111111111";
    CtlToALU_port.reg2_contents <= to_unsigned(0, 32);
    CtlToALU_port_sync <= true;
    wait for 20 ns;
    CtlToALU_port_sync <= false;
    assert ALUtoCtl_port.ALU_result = "00111111001111111111111111111111" report "unexpected value for result" severity warning;
    

    -------------- COPY R1 (= 42) ---------------
    wait for 20 ns;
    CtlToALU_port.alu_fun       <= ALU_COPY1;
    CtlToALU_port.imm           <= to_unsigned(0, 32);
    CtlToALU_port.op1_sel       <= OP_REG;
    CtlToALU_port.op2_sel       <= OP_X;
    CtlToALU_port.pc_reg        <= to_unsigned(0, 32);
    CtlToALU_port.reg1_contents <= to_unsigned(42, 32);
    CtlToALU_port.reg2_contents <= to_unsigned(0, 32);
    CtlToALU_port_sync <= true;
    wait for 20 ns;
    CtlToALU_port_sync <= false;
    assert ALUtoCtl_port.ALU_result = to_unsigned(42, 32) report "unexpected value for result" severity warning;
    




    wait;

    end process stimuli;


end architecture;





















































