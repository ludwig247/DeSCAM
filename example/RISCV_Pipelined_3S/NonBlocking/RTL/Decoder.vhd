--
-- CREATED BY: SALAHEDDIN HETALANI (salaheddinhetalani@gmail.com) ON 29 Jan, 2019
--

library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SCAM_Model_types.all;

entity Decoder is
    port(
        CUtoDE_port : in  CUtoDE_IF;
        DEtoCU_port : out DEtoCU_IF
    );
end Decoder;


architecture Decoder_arch of Decoder is

begin

    process(CUtoDE_port.encodedInstr)

        variable opcode       : Unsigned ( 6 downto  0);
        variable funct3       : Unsigned ( 2 downto  0);
        variable funct7       : Unsigned ( 6 downto  0);

    begin
    
        -- DETERMINE OPCODE, FUNC3 and FUNC7
        opcode := CUtoDE_port.encodedInstr( 6 downto  0);
        funct3 := CUtoDE_port.encodedInstr(14 downto 12);
        funct7 := CUtoDE_port.encodedInstr(31 downto 25);       

        -- |/////////////////////////////////////////////////////////////////////////////////////| --
        -- |         Encoding Type: R          |    Register-Register  |          Integer        | --
        -- |/////////////////////////////////////////////////////////////////////////////////////| --
        -- |31|30|29|28|27|26|25|24|23|22|21|20|19|18|17|16|15|14|13|12|11|10|9|8|7|6|5|4|3|2|1|0| --
        -- |       funct7       |      rs2     |      rs1     | funct3 |     rd    |    opcode   | --
        -- |/////////////////////////////////////////////////////////////////////////////////////| --
        if (opcode = "0110011") then

            DEtoCU_port.pcSel_s1 <= PC_4;
            DEtoCU_port.imm_s1 <= (others => '0');
            DEtoCU_port.encType_s1 <= ENC_R;
            DEtoCU_port.regRs1Addr_s1 <= CUtoDE_port.encodedInstr(19 downto 15);
            DEtoCU_port.regRs2Addr_s1 <= CUtoDE_port.encodedInstr(24 downto 20);
            DEtoCU_port.regRdAddr_s1 <= CUtoDE_port.encodedInstr(11 downto  7);

            DEtoCU_port.aluOp1Sel_s2 <= OP_REG;
            DEtoCU_port.aluOp2Sel_s2 <= OP_REG;

            DEtoCU_port.regfileWrite_s3 <= true;
            DEtoCU_port.writeDataSel_s3 <= WB_ALU;

            DEtoCU_port.dmemMask <= MT_X;

            if (funct3 = "000") then
                if    (funct7 = "0000000") then
                    DEtoCU_port.instrType_s1 <= INSTR_ADD;
                    DEtoCU_port.aluFunc_s2   <= ALU_ADD;
                elsif (funct7 = "0100000") then
                    DEtoCU_port.instrType_s1 <= INSTR_SUB;
                    DEtoCU_port.aluFunc_s2   <= ALU_SUB;
                else
                    DEtoCU_port.instrType_s1 <= INSTR_UNKNOWN;
                    DEtoCU_port.aluFunc_s2   <= ALU_X;
                end if;
            elsif (funct3 = "001") then
                DEtoCU_port.instrType_s1 <= INSTR_SLL;
                DEtoCU_port.aluFunc_s2   <= ALU_SLL;
            elsif (funct3 = "010") then
                DEtoCU_port.instrType_s1 <= INSTR_SLT;
                DEtoCU_port.aluFunc_s2   <= ALU_SLT;
            elsif (funct3 = "011") then
                DEtoCU_port.instrType_s1 <= INSTR_SLTU;
                DEtoCU_port.aluFunc_s2   <= ALU_SLTU;
            elsif (funct3 = "100") then
                DEtoCU_port.instrType_s1 <= INSTR_XOR;
                DEtoCU_port.aluFunc_s2   <= ALU_XOR;
            elsif (funct3 = "101") then
                if    (funct7 = "0000000") then
                    DEtoCU_port.instrType_s1 <= INSTR_SRL;
                    DEtoCU_port.aluFunc_s2   <= ALU_SRL;
                elsif (funct7 = "0100000") then
                    DEtoCU_port.instrType_s1 <= INSTR_SRA;
                    DEtoCU_port.aluFunc_s2   <= ALU_SRA;
                else
                    DEtoCU_port.instrType_s1 <= INSTR_UNKNOWN;
                    DEtoCU_port.aluFunc_s2   <= ALU_X;
                end if;
            elsif (funct3 = "110") then
                DEtoCU_port.instrType_s1 <= INSTR_OR;
                DEtoCU_port.aluFunc_s2   <= ALU_OR;
            elsif (funct3 = "111") then
                DEtoCU_port.instrType_s1 <= INSTR_AND;
                DEtoCU_port.aluFunc_s2   <= ALU_AND;
            else
                DEtoCU_port.instrType_s1 <= INSTR_UNKNOWN;
                DEtoCU_port.aluFunc_s2   <= ALU_X;
            end if;

        -- |//////////////////////////////////////////////////////////////////////////////////////| --
        -- |         Encoding Type: I          |   Register-Immediate  |         I: Integer       | --
        -- |//////////////////////////////////////////////////////////////////////////////////////| --
        -- |31|30|29|28|27|26|25|24|23|22|21|20|19|18|17|16|15|14|13|12|11|10|9|8|7|6|5|4|3|2|1|00| --
        -- |             imm[11:0]             |      rs1     | funct3 |     rd    |    opcode    | --
        -- |//////////////////////////////////////////////////////////////////////////////////////| --
        -- |                      ~sign~ inst[31]                         |   [30:25]  |[24:21]|20| --
        -- |//////////////////////////////////////////////////////////////////////////////////////| --
        elsif (opcode = "0010011") then

            DEtoCU_port.pcSel_s1 <= PC_4;
            DEtoCU_port.encType_s1 <= ENC_I_I;
            DEtoCU_port.regRs1Addr_s1 <= CUtoDE_port.encodedInstr(19 downto 15);
            DEtoCU_port.regRs2Addr_s1 <= (others => '0');
            DEtoCU_port.regRdAddr_s1 <= CUtoDE_port.encodedInstr(11 downto  7);

            DEtoCU_port.aluOp1Sel_s2 <= OP_REG;
            DEtoCU_port.aluOp2Sel_s2 <= OP_IMM;

            DEtoCU_port.regfileWrite_s3 <= true;
            DEtoCU_port.writeDataSel_s3 <= WB_ALU;

            DEtoCU_port.dmemMask <= MT_X;

            -- Instruction-Type
            if    (funct3 = "000") then
                DEtoCU_port.instrType_s1 <= INSTR_ADDI;
                DEtoCU_port.aluFunc_s2   <= ALU_ADD;
            elsif (funct3 = "001") then
                DEtoCU_port.instrType_s1 <= INSTR_SLLI;
                DEtoCU_port.aluFunc_s2   <= ALU_SLL;
            elsif (funct3 = "010") then
                DEtoCU_port.instrType_s1 <= INSTR_SLTI;
                DEtoCU_port.aluFunc_s2   <= ALU_SLT;
            elsif (funct3 = "011") then
                DEtoCU_port.instrType_s1 <= INSTR_SLTUI;
                DEtoCU_port.aluFunc_s2   <= ALU_SLTU;
            elsif (funct3 = "100") then
                DEtoCU_port.instrType_s1 <= INSTR_XORI;
                DEtoCU_port.aluFunc_s2   <= ALU_XOR;
            elsif (funct3 = "101") then
                if    (funct7 = "0000000")  then
                    DEtoCU_port.instrType_s1 <= INSTR_SRLI;
                    DEtoCU_port.aluFunc_s2   <= ALU_SRL;
                elsif (funct7 = "0100000") then
                    DEtoCU_port.instrType_s1 <= INSTR_SRAI;
                    DEtoCU_port.aluFunc_s2   <= ALU_SRA;
                else
                    DEtoCU_port.instrType_s1 <= INSTR_UNKNOWN;
                    DEtoCU_port.aluFunc_s2   <= ALU_X;
                end if;
            elsif (funct3 = "110") then
                DEtoCU_port.instrType_s1 <= INSTR_ORI;
                DEtoCU_port.aluFunc_s2   <= ALU_OR;
            elsif (funct3 = "111") then
                DEtoCU_port.instrType_s1 <= INSTR_ANDI;
                DEtoCU_port.aluFunc_s2   <= ALU_AND;
            else
                DEtoCU_port.instrType_s1 <= INSTR_UNKNOWN;
                DEtoCU_port.aluFunc_s2   <= ALU_X;
            end if;

             -- SET IMMEDIATE (SIGN-EXTENDED)
            if (CUtoDE_port.encodedInstr(31) = '1') then
                DEtoCU_port.imm_s1 <= X"FFFFF" & CUtoDE_port.encodedInstr(31 downto 20);
            else
                DEtoCU_port.imm_s1 <= X"00000" & CUtoDE_port.encodedInstr(31 downto 20);
            end if;

        -- |//////////////////////////////////////////////////////////////////////////////////////| --
        -- |         Encoding Type: I          |         Load          |             L            | --
        -- |//////////////////////////////////////////////////////////////////////////////////////| --
        -- |31|30|29|28|27|26|25|24|23|22|21|20|19|18|17|16|15|14|13|12|11|10|9|8|7|6|5|4|3|2|1|00| --
        -- |             imm[11:0]             |      rs1     | funct3 |     rd    |    opcode    | --
        -- |//////////////////////////////////////////////////////////////////////////////////////| --
        -- |                      ~sign~ inst[31]                         |   [30:25]  |[24:21]|20| --
        -- |//////////////////////////////////////////////////////////////////////////////////////| --
        elsif (opcode = "0000011") then

            DEtoCU_port.pcSel_s1 <= PC_4;
            DEtoCU_port.encType_s1 <= ENC_I_L;
            DEtoCU_port.regRs1Addr_s1 <= CUtoDE_port.encodedInstr(19 downto 15);
            DEtoCU_port.regRs2Addr_s1 <= (others => '0');
            DEtoCU_port.regRdAddr_s1 <= CUtoDE_port.encodedInstr(11 downto  7);

            DEtoCU_port.aluFunc_s2 <= ALU_X;
            DEtoCU_port.aluOp1Sel_s2 <= OP_X;
            DEtoCU_port.aluOp2Sel_s2 <= OP_X;

            DEtoCU_port.regfileWrite_s3 <= true;
            DEtoCU_port.writeDataSel_s3 <= WB_MEM;

            -- Instruction-Type
            if    (funct3 = "000") then
                DEtoCU_port.instrType_s1 <= INSTR_LB;
                DEtoCU_port.dmemMask  <= MT_B;
            elsif (funct3 = "001") then
                DEtoCU_port.instrType_s1 <= INSTR_LH;
                DEtoCU_port.dmemMask  <= MT_H;
            elsif (funct3 = "010") then
                DEtoCU_port.instrType_s1 <= INSTR_LW;
                DEtoCU_port.dmemMask  <= MT_W;
            elsif (funct3 = "100") then
                DEtoCU_port.instrType_s1 <= INSTR_LBU;
                DEtoCU_port.dmemMask  <= MT_BU;
            elsif (funct3 = "101") then
                DEtoCU_port.instrType_s1 <= INSTR_LHU;
                DEtoCU_port.dmemMask  <= MT_HU;
            else
                DEtoCU_port.instrType_s1 <= INSTR_UNKNOWN;
                DEtoCU_port.dmemMask  <= MT_X;
            end if;

            -- SET IMMEDIATE (SIGN-EXTENDED)
            if (CUtoDE_port.encodedInstr(31) = '1') then
                DEtoCU_port.imm_s1 <= X"FFFFF" & CUtoDE_port.encodedInstr(31 downto 20);
            else
                DEtoCU_port.imm_s1 <= X"00000" & CUtoDE_port.encodedInstr(31 downto 20);
            end if;

        -- |//////////////////////////////////////////////////////////////////////////////////////| --
        -- |         Encoding Type: I          |   Unconditional Jump  |          J: JALR         | --
        -- |//////////////////////////////////////////////////////////////////////////////////////| --
        -- |31|30|29|28|27|26|25|24|23|22|21|20|19|18|17|16|15|14|13|12|11|10|9|8|7|6|5|4|3|2|1|00| --
        -- |             imm[11:0]             |      rs1     | funct3 |     rd    |    opcode    | --
        -- |//////////////////////////////////////////////////////////////////////////////////////| --
        -- |                      ~sign~ inst[31]                         |   [30:25]  |[24:21]|20| --
        -- |//////////////////////////////////////////////////////////////////////////////////////| --
        elsif (opcode = "1100111") then

            DEtoCU_port.pcSel_s1 <= PC_JR;
            DEtoCU_port.encType_s1 <= ENC_I_J;
            DEtoCU_port.instrType_s1 <= INSTR_JALR;
            DEtoCU_port.regRs1Addr_s1 <= CUtoDE_port.encodedInstr(19 downto 15);
            DEtoCU_port.regRs2Addr_s1 <= (others => '0');
            DEtoCU_port.regRdAddr_s1 <= CUtoDE_port.encodedInstr(11 downto  7);

            DEtoCU_port.aluFunc_s2 <= ALU_X;
            DEtoCU_port.aluOp1Sel_s2 <= OP_X;
            DEtoCU_port.aluOp2Sel_s2 <= OP_X;

            DEtoCU_port.regfileWrite_s3 <= true;
            DEtoCU_port.writeDataSel_s3 <= WB_PC4;

            DEtoCU_port.dmemMask <= MT_X;

            -- SET IMMEDIATE (SIGN-EXTENDED)
            if (CUtoDE_port.encodedInstr(31) = '1') then
                DEtoCU_port.imm_s1 <= X"FFFFF" & CUtoDE_port.encodedInstr(31 downto 20);
            else
                DEtoCU_port.imm_s1 <= X"00000" & CUtoDE_port.encodedInstr(31 downto 20);
            end if;

        -- |/////////////////////////////////////////////////////////////////////////////////////| --
        -- |         Encoding Type: S          |          Store        |                         | --
        -- |/////////////////////////////////////////////////////////////////////////////////////| --
        -- |31|30|29|28|27|26|25|24|23|22|21|20|19|18|17|16|15|14|13|12|11|10|9|8|7|6|5|4|3|2|1|0| --
        -- |      imm[11:5]     |      rs2     |      rs1     | funct3 |  imm[4:0] |    opcode   | --
        -- |/////////////////////////////////////////////////////////////////////////////////////| --
        -- |                      ~sign~ inst[31]                         |   [30:25]  | [11:8]|7| --
        -- |/////////////////////////////////////////////////////////////////////////////////////| --
        elsif (opcode = "0100011") then

            DEtoCU_port.pcSel_s1 <= PC_4;
            DEtoCU_port.encType_s1 <= ENC_S;
            DEtoCU_port.regRs1Addr_s1 <= CUtoDE_port.encodedInstr(19 downto 15);
            DEtoCU_port.regRs2Addr_s1 <= CUtoDE_port.encodedInstr(24 downto 20);
            DEtoCU_port.regRdAddr_s1 <= (others => '0');

            DEtoCU_port.aluFunc_s2 <= ALU_X;
            DEtoCU_port.aluOp1Sel_s2 <= OP_X;
            DEtoCU_port.aluOp2Sel_s2 <= OP_X;

            DEtoCU_port.regfileWrite_s3 <= false;
            DEtoCU_port.writeDataSel_s3 <= WB_X;

            -- Instruction-Type
            if    (funct3 = "000") then
                DEtoCU_port.instrType_s1 <= INSTR_SB;
                DEtoCU_port.dmemMask <= MT_B;
            elsif (funct3 = "001") then
                DEtoCU_port.instrType_s1 <= INSTR_SH;
                DEtoCU_port.dmemMask <= MT_H;
            elsif (funct3 = "010") then
                DEtoCU_port.instrType_s1 <= INSTR_SW;
                DEtoCU_port.dmemMask <= MT_W;
            else
                DEtoCU_port.instrType_s1 <= INSTR_UNKNOWN;
                DEtoCU_port.dmemMask <= MT_X;
            end if;

            -- SET IMMEDIATE (SIGN-EXTENDED)
            if (CUtoDE_port.encodedInstr(31) = '1') then
                DEtoCU_port.imm_s1 <= X"FFFFF" & CUtoDE_port.encodedInstr(31 downto 25) & CUtoDE_port.encodedInstr(11 downto 7);
            else
                DEtoCU_port.imm_s1 <= X"00000" & CUtoDE_port.encodedInstr(31 downto 25) & CUtoDE_port.encodedInstr(11 downto 7);
            end if;

        -- |//////////////////////////////////////////////////////////////////////////////////////| --
        -- |         Encoding Type: B          |   Conditional Branch  |                          | --
        -- |//////////////////////////////////////////////////////////////////////////////////////| --
        -- |31|30|29|28|27|26|25|24|23|22|21|20|19|18|17|16|15|14|13|12|11|10|9|8|07|6|5|4|3|2|1|0| --
        -- |12|    imm[10:5]    |      rs2     |      rs1     | funct3 | imm[4:1]|11|    opcode   | --
        -- |//////////////////////////////////////////////////////////////////////////////////////| --
        -- |                      ~sign~ inst[31]                      | 7|   [30:25]   | [11:8]|Z| --
        -- |//////////////////////////////////////////////////////////////////////////////////////| --
        elsif (opcode = "1100011") then

            DEtoCU_port.pcSel_s1 <= PC_BR;
            DEtoCU_port.encType_s1 <= ENC_B;
            DEtoCU_port.regRs1Addr_s1 <= CUtoDE_port.encodedInstr(19 downto 15);
            DEtoCU_port.regRs2Addr_s1 <= CUtoDE_port.encodedInstr(24 downto 20);
            DEtoCU_port.regRdAddr_s1 <= (others => '0');

            DEtoCU_port.aluFunc_s2 <= ALU_X;
            DEtoCU_port.aluOp1Sel_s2 <= OP_X;
            DEtoCU_port.aluOp2Sel_s2 <= OP_X;

            DEtoCU_port.regfileWrite_s3 <= false;
            DEtoCU_port.writeDataSel_s3 <= WB_X;

            DEtoCU_port.dmemMask <= MT_X;

            -- Instruction-Type
            if    (funct3 = "000") then
                DEtoCU_port.instrType_s1 <= INSTR_BEQ;
            elsif (funct3 = "001") then
                DEtoCU_port.instrType_s1 <= INSTR_BNE;
            elsif (funct3 = "100") then
                DEtoCU_port.instrType_s1 <= INSTR_BLT;
            elsif (funct3 = "101") then
                DEtoCU_port.instrType_s1 <= INSTR_BGE;
            elsif (funct3 = "110") then
                DEtoCU_port.instrType_s1 <= INSTR_BLTU;
            elsif (funct3 = "111") then
                DEtoCU_port.instrType_s1 <= INSTR_BGEU;
            else
                DEtoCU_port.instrType_s1 <= INSTR_UNKNOWN;
            end if;

            -- SET IMMEDIATE (SIGN-EXTENDED AND MULTIPLE OF 2)
            if (CUtoDE_port.encodedInstr(31) = '1') then
                DEtoCU_port.imm_s1 <= X"FFFFF" & CUtoDE_port.encodedInstr(7 downto 7) & CUtoDE_port.encodedInstr(30 downto 25) & CUtoDE_port.encodedInstr(11 downto 8) & "0";
            else
                DEtoCU_port.imm_s1 <= X"00000" & CUtoDE_port.encodedInstr(7 downto 7) & CUtoDE_port.encodedInstr(30 downto 25) & CUtoDE_port.encodedInstr(11 downto 8) & "0";
            end if;

        -- |/////////////////////////////////////////////////////////////////////////////////////| --
        -- |         Encoding Type: U          |  Load Upper Immediate |           LUI           | --
        -- |/////////////////////////////////////////////////////////////////////////////////////| --
        -- |31|30|29|28|27|26|25|24|23|22|21|20|19|18|17|16|15|14|13|12|11|10|9|8|7|6|5|4|3|2|1|0| --
        -- |                         imm[31:12]                        |     rd    |    opcode   | --
        -- |/////////////////////////////////////////////////////////////////////////////////////| --
        -- |31|       inst[30:20]              |      inst[19:12]      |          ~zero~         | --
        -- |/////////////////////////////////////////////////////////////////////////////////////| --
        elsif (opcode = "0110111") then

            DEtoCU_port.pcSel_s1 <= PC_4;
            DEtoCU_port.imm_s1 <= CUtoDE_port.encodedInstr(31 downto 12) & X"000";
            DEtoCU_port.encType_s1 <= ENC_U;
            DEtoCU_port.instrType_s1 <= INSTR_LUI;
            DEtoCU_port.regRs1Addr_s1 <= (others => '0');
            DEtoCU_port.regRs2Addr_s1 <= (others => '0');
            DEtoCU_port.regRdAddr_s1 <= CUtoDE_port.encodedInstr(11 downto 7);

            DEtoCU_port.aluFunc_s2 <= ALU_COPY1;
            DEtoCU_port.aluOp1Sel_s2 <= OP_IMM;
            DEtoCU_port.aluOp2Sel_s2 <= OP_X;

            DEtoCU_port.regfileWrite_s3 <= true;
            DEtoCU_port.writeDataSel_s3 <= WB_ALU;

            DEtoCU_port.dmemMask <= MT_X;

        -- |/////////////////////////////////////////////////////////////////////////////////////| --
        -- |         Encoding Type: U          |Add Upper Immediate PC |          AUIPC          | --
        -- |/////////////////////////////////////////////////////////////////////////////////////| --
        -- |31|30|29|28|27|26|25|24|23|22|21|20|19|18|17|16|15|14|13|12|11|10|9|8|7|6|5|4|3|2|1|0| --
        -- |                         imm[31:12]                        |     rd    |    opcode   | --
        -- |/////////////////////////////////////////////////////////////////////////////////////| --
        -- |31|       inst[30:20]              |      inst[19:12]      |          ~zero~         | --
        -- |/////////////////////////////////////////////////////////////////////////////////////| --
        elsif (opcode = "0010111") then

            DEtoCU_port.pcSel_s1 <= PC_4;
            DEtoCU_port.imm_s1 <= CUtoDE_port.encodedInstr(31 downto 12) & X"000";
            DEtoCU_port.encType_s1 <= ENC_U;
            DEtoCU_port.instrType_s1 <= INSTR_AUIPC;
            DEtoCU_port.regRs1Addr_s1 <= (others => '0');
            DEtoCU_port.regRs2Addr_s1 <= (others => '0');
            DEtoCU_port.regRdAddr_s1 <= CUtoDE_port.encodedInstr(11 downto 7);

            DEtoCU_port.aluFunc_s2 <= ALU_ADD;
            DEtoCU_port.aluOp1Sel_s2 <= OP_PC;
            DEtoCU_port.aluOp2Sel_s2 <= OP_IMM;

            DEtoCU_port.regfileWrite_s3 <= true;
            DEtoCU_port.writeDataSel_s3 <= WB_ALU;

            DEtoCU_port.dmemMask <= MT_X;

        -- |/////////////////////////////////////////////////////////////////////////////////////| --
        -- |         Encoding Type: J          |   Unconditional Jump  |           JAL           | --
        -- |/////////////////////////////////////////////////////////////////////////////////////| --
        -- |31|30|29|28|27|26|25|24|23|22|21|20|19|18|17|16|15|14|13|12|11|10|9|8|7|6|5|4|3|2|1|0| --
        -- |20|          imm[10:1]          |11|       imm[19:12]      |     rd    |    opcode   | --
        -- |/////////////////////////////////////////////////////////////////////////////////////| --
        -- |         ~sign~ inst[31]           |      inst[19:12]      |20| inst[30:25]|[24:21]|Z| --
        -- |/////////////////////////////////////////////////////////////////////////////////////| --
        elsif (opcode = "1101111") then

            DEtoCU_port.pcSel_s1 <= PC_J;
            DEtoCU_port.encType_s1 <= ENC_J;
            DEtoCU_port.instrType_s1 <= INSTR_JAL;
            DEtoCU_port.regRs1Addr_s1 <= (others => '0');
            DEtoCU_port.regRs2Addr_s1 <= (others => '0');
            DEtoCU_port.regRdAddr_s1 <= CUtoDE_port.encodedInstr(11 downto 7);

            DEtoCU_port.aluFunc_s2 <= ALU_X;
            DEtoCU_port.aluOp1Sel_s2 <= OP_X;
            DEtoCU_port.aluOp2Sel_s2 <= OP_X;

            DEtoCU_port.regfileWrite_s3 <= true;
            DEtoCU_port.writeDataSel_s3 <= WB_PC4;

            DEtoCU_port.dmemMask <= MT_X;

            -- SET IMMEDIATE (SIGN-EXTENDED AND MULTIPLE OF 2)
            if (CUtoDE_port.encodedInstr(31) = '1') then
                DEtoCU_port.imm_s1 <= X"FFF" & CUtoDE_port.encodedInstr(19 downto 12) & CUtoDE_port.encodedInstr(20 downto 20) & CUtoDE_port.encodedInstr(30 downto 21) & "0";
            else
                DEtoCU_port.imm_s1 <= X"000" & CUtoDE_port.encodedInstr(19 downto 12) & CUtoDE_port.encodedInstr(20 downto 20) & CUtoDE_port.encodedInstr(30 downto 21) & "0";
            end if;

        else

            DEtoCU_port.pcSel_s1 <= PC_4;
            DEtoCU_port.imm_s1 <= (others => '0');
            DEtoCU_port.encType_s1 <= ENC_ERR;
            DEtoCU_port.instrType_s1 <= INSTR_UNKNOWN;
            DEtoCU_port.regRs1Addr_s1 <= (others => '0');
            DEtoCU_port.regRs2Addr_s1 <= (others => '0');
            DEtoCU_port.regRdAddr_s1 <= (others => '0');

            DEtoCU_port.aluFunc_s2 <= ALU_X;
            DEtoCU_port.aluOp1Sel_s2 <= OP_X;
            DEtoCU_port.aluOp2Sel_s2 <= OP_X;

            DEtoCU_port.regfileWrite_s3 <= false;
            DEtoCU_port.writeDataSel_s3 <= WB_X;

            DEtoCU_port.dmemMask <= MT_X;

        end if;

    end process;

end Decoder_arch;
