--
-- CREATED BY: SALAHEDDIN HETALANI (salaheddinhetalani@gmail.com) ON 23 OCT, 2018
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

        variable encodedInstr : Unsigned (31 downto  0);
        variable opcode       : Unsigned ( 6 downto  0);
        variable funct3       : Unsigned ( 2 downto  0);
        variable funct7       : Unsigned ( 6 downto  0);

    begin
    
        encodedInstr := CUtoDE_port.encodedInstr;

        -- DETERMINE OPCODE, FUNC3 and FUNC7
        opcode := encodedInstr( 6 downto  0);
        funct3 := encodedInstr(14 downto 12);
        funct7 := encodedInstr(31 downto 25);       

        -- |/////////////////////////////////////////////////////////////////////////////////////| --
        -- |         Encoding Type: ENC_R          |    Register-Register  |          Integer    | --
        -- |/////////////////////////////////////////////////////////////////////////////////////| --
        -- |31|30|29|28|27|26|25|24|23|22|21|20|19|18|17|16|15|14|13|12|11|10|9|8|7|6|5|4|3|2|1|0| --
        -- |        func7       |      rs2     |      rs1     | funct3 |     rd    |    opcode   | --
        -- |/////////////////////////////////////////////////////////////////////////////////////| --
        if (opcode = "0110011") then

            DEtoCU_port.pcSel_s2 <= PC_4;
            DEtoCU_port.imm_s2 <= (others => '0');
            DEtoCU_port.encType_s2 <= ENC_R;
            DEtoCU_port.regFileReq_s2 <= RF_RD;
            DEtoCU_port.regRs1Addr_s2 <= encodedInstr(19 downto 15);
            DEtoCU_port.regRs2Addr_s2 <= encodedInstr(24 downto 20);
            DEtoCU_port.regRdAddr_s2 <= encodedInstr(11 downto  7);

            DEtoCU_port.aluOp1Sel_s3 <= OP_REG;
            DEtoCU_port.aluOp2Sel_s3 <= OP_REG;
            DEtoCU_port.imm_s3 <= (others => '0');

            DEtoCU_port.dmemReq_s4 <= ME_X;
            DEtoCU_port.dmemMask_s4 <= MT_X;

            DEtoCU_port.regFileReq_s5 <= RF_WR;
            DEtoCU_port.regFileWriteDataSel_s5 <= WB_ALU;

            if (funct3 = "000") then
                if    (funct7 = "0000000") then
                    DEtoCU_port.instrType_s2 <= INSTR_ADD;
                    DEtoCU_port.aluFunc_s3   <= ALU_ADD;
                elsif (funct7 = "0100000") then
                    DEtoCU_port.instrType_s2 <= INSTR_SUB;
                    DEtoCU_port.aluFunc_s3   <= ALU_SUB;
                else
                    DEtoCU_port.instrType_s2 <= INSTR_UNKNOWN;
                    DEtoCU_port.aluFunc_s3   <= ALU_X;
                end if;
            elsif (funct3 = "001") then
                DEtoCU_port.instrType_s2 <= INSTR_SLL;
                DEtoCU_port.aluFunc_s3   <= ALU_SLL;
            elsif (funct3 = "010") then
                DEtoCU_port.instrType_s2 <= INSTR_SLT;
                DEtoCU_port.aluFunc_s3   <= ALU_SLT;
            elsif (funct3 = "011") then
                DEtoCU_port.instrType_s2 <= INSTR_SLTU;
                DEtoCU_port.aluFunc_s3   <= ALU_SLTU;
            elsif (funct3 = "100") then
                DEtoCU_port.instrType_s2 <= INSTR_XOR;
                DEtoCU_port.aluFunc_s3   <= ALU_XOR;
            elsif (funct3 = "101") then
                if    (funct7 = "0000000") then
                    DEtoCU_port.instrType_s2 <= INSTR_SRL;
                    DEtoCU_port.aluFunc_s3   <= ALU_SRL;
                elsif (funct7 = "0100000") then
                    DEtoCU_port.instrType_s2 <= INSTR_SRA;
                    DEtoCU_port.aluFunc_s3   <= ALU_SRA;
                else
                    DEtoCU_port.instrType_s2 <= INSTR_UNKNOWN;
                    DEtoCU_port.aluFunc_s3   <= ALU_X;
                end if;
            elsif (funct3 = "110") then
                DEtoCU_port.instrType_s2 <= INSTR_OR;
                DEtoCU_port.aluFunc_s3   <= ALU_OR;
            elsif (funct3 = "111") then
                DEtoCU_port.instrType_s2 <= INSTR_AND;
                DEtoCU_port.aluFunc_s3   <= ALU_AND;
            else
                DEtoCU_port.instrType_s2 <= INSTR_UNKNOWN;
                DEtoCU_port.aluFunc_s3   <= ALU_X;
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

            DEtoCU_port.pcSel_s2 <= PC_4;
            DEtoCU_port.imm_s2 <= (others => '0');
            DEtoCU_port.encType_s2 <= ENC_I_I;
            DEtoCU_port.regFileReq_s2 <= RF_RD;
            DEtoCU_port.regRs1Addr_s2 <= encodedInstr(19 downto 15);
            DEtoCU_port.regRs2Addr_s2 <= (others => '0');
            DEtoCU_port.regRdAddr_s2 <= encodedInstr(11 downto  7);

            DEtoCU_port.aluOp1Sel_s3 <= OP_REG;
            DEtoCU_port.aluOp2Sel_s3 <= OP_IMM;

            DEtoCU_port.dmemReq_s4 <= ME_X;
            DEtoCU_port.dmemMask_s4 <= MT_X;

            DEtoCU_port.regFileReq_s5 <= RF_WR;
            DEtoCU_port.regFileWriteDataSel_s5 <= WB_ALU;

            -- Instruction-Type
            if    (funct3 = "000") then
                DEtoCU_port.instrType_s2 <= INSTR_ADDI;
                DEtoCU_port.aluFunc_s3   <= ALU_ADD;
            elsif (funct3 = "001") then
                DEtoCU_port.instrType_s2 <= INSTR_SLLI;
                DEtoCU_port.aluFunc_s3   <= ALU_SLL;
            elsif (funct3 = "010") then
                DEtoCU_port.instrType_s2 <= INSTR_SLTI;
                DEtoCU_port.aluFunc_s3   <= ALU_SLT;
            elsif (funct3 = "011") then
                DEtoCU_port.instrType_s2 <= INSTR_SLTUI;
                DEtoCU_port.aluFunc_s3   <= ALU_SLTU;
            elsif (funct3 = "100") then
                DEtoCU_port.instrType_s2 <= INSTR_XORI;
                DEtoCU_port.aluFunc_s3   <= ALU_XOR;
            elsif (funct3 = "101") then
                if    (funct7 = "0000000")  then
                    DEtoCU_port.instrType_s2 <= INSTR_SRLI;
                    DEtoCU_port.aluFunc_s3   <= ALU_SRL;
                elsif (funct7 = "0100000") then
                    DEtoCU_port.instrType_s2 <= INSTR_SRAI;
                    DEtoCU_port.aluFunc_s3   <= ALU_SRA;
                else
                    DEtoCU_port.instrType_s2 <= INSTR_UNKNOWN;
                    DEtoCU_port.aluFunc_s3   <= ALU_X;
                end if;
            elsif (funct3 = "110") then
                DEtoCU_port.instrType_s2 <= INSTR_ORI;
                DEtoCU_port.aluFunc_s3   <= ALU_OR;
            elsif (funct3 = "111") then
                DEtoCU_port.instrType_s2 <= INSTR_ANDI;
                DEtoCU_port.aluFunc_s3   <= ALU_AND;
            else
                DEtoCU_port.instrType_s2 <= INSTR_UNKNOWN;
                DEtoCU_port.aluFunc_s3   <= ALU_X;
            end if;

             -- SET IMMEDIATE (SIGN-EXTENDED)
            if (encodedInstr(31) = '1') then
                DEtoCU_port.imm_s3 <= X"FFFFF" & encodedInstr(31 downto 20);
            else
                DEtoCU_port.imm_s3 <= X"00000" & encodedInstr(31 downto 20);
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

            DEtoCU_port.pcSel_s2 <= PC_4;
            DEtoCU_port.imm_s2 <= (others => '0');
            DEtoCU_port.encType_s2 <= ENC_I_L;
            DEtoCU_port.regFileReq_s2 <= RF_RD;
            DEtoCU_port.regRs1Addr_s2 <= encodedInstr(19 downto 15);
            DEtoCU_port.regRs2Addr_s2 <= (others => '0');
            DEtoCU_port.regRdAddr_s2 <= encodedInstr(11 downto  7);

            DEtoCU_port.aluFunc_s3 <= ALU_ADD;
            DEtoCU_port.aluOp1Sel_s3 <= OP_REG;
            DEtoCU_port.aluOp2Sel_s3 <= OP_IMM;

            DEtoCU_port.dmemReq_s4 <= ME_RD;

            DEtoCU_port.regFileReq_s5 <= RF_WR;
            DEtoCU_port.regFileWriteDataSel_s5 <= WB_MEM;

            -- Instruction-Type
            if    (funct3 = "000") then
                DEtoCU_port.instrType_s2 <= INSTR_LB;
                DEtoCU_port.dmemMask_s4  <= MT_B;
            elsif (funct3 = "001") then
                DEtoCU_port.instrType_s2 <= INSTR_LH;
                DEtoCU_port.dmemMask_s4  <= MT_H;
            elsif (funct3 = "010") then
                DEtoCU_port.instrType_s2 <= INSTR_LW;
                DEtoCU_port.dmemMask_s4  <= MT_W;
            elsif (funct3 = "100") then
                DEtoCU_port.instrType_s2 <= INSTR_LBU;
                DEtoCU_port.dmemMask_s4  <= MT_BU;
            elsif (funct3 = "101") then
                DEtoCU_port.instrType_s2 <= INSTR_LHU;
                DEtoCU_port.dmemMask_s4  <= MT_HU;
            else
                DEtoCU_port.instrType_s2 <= INSTR_UNKNOWN;
                DEtoCU_port.dmemMask_s4  <= MT_X;
            end if;

            -- SET IMMEDIATE (SIGN-EXTENDED)
            if (encodedInstr(31) = '1') then
                DEtoCU_port.imm_s3 <= X"FFFFF" & encodedInstr(31 downto 20);
            else
                DEtoCU_port.imm_s3 <= X"00000" & encodedInstr(31 downto 20);
            end if;

        -- |//////////////////////////////////////////////////////////////////////////////////////| --
        -- |         Encoding Type: I          |   Unconditional_Jump  |        ENC_J: JALR       | --
        -- |//////////////////////////////////////////////////////////////////////////////////////| --
        -- |31|30|29|28|27|26|25|24|23|22|21|20|19|18|17|16|15|14|13|12|11|10|9|8|7|6|5|4|3|2|1|00| --
        -- |             imm[11:0]             |      rs1     | funct3 |     rd    |    opcode    | --
        -- |//////////////////////////////////////////////////////////////////////////////////////| --
        -- |                      ~sign~ inst[31]                         |   [30:25]  |[24:21]|20| --
        -- |//////////////////////////////////////////////////////////////////////////////////////| --
        elsif (opcode = "1100111") then

            DEtoCU_port.pcSel_s2 <= PC_JR;
            DEtoCU_port.encType_s2 <= ENC_I_J;
            DEtoCU_port.instrType_s2 <= INSTR_JALR;
            DEtoCU_port.regFileReq_s2 <= RF_RD;
            DEtoCU_port.regRs1Addr_s2 <= encodedInstr(19 downto 15);
            DEtoCU_port.regRs2Addr_s2 <= (others => '0');
            DEtoCU_port.regRdAddr_s2 <= encodedInstr(11 downto  7);

            DEtoCU_port.aluFunc_s3 <= ALU_X;
            DEtoCU_port.aluOp1Sel_s3 <= OP_X;
            DEtoCU_port.aluOp2Sel_s3 <= OP_X;
            DEtoCU_port.imm_s3 <= (others => '0');

            DEtoCU_port.dmemReq_s4 <= ME_X;
            DEtoCU_port.dmemMask_s4 <= MT_X;

            DEtoCU_port.regFileReq_s5 <= RF_WR;
            DEtoCU_port.regFileWriteDataSel_s5 <= WB_PC4;

            -- SET IMMEDIATE (SIGN-EXTENDED)
            if (encodedInstr(31) = '1') then
                DEtoCU_port.imm_s2 <= X"FFFFF" & encodedInstr(31 downto 20);
            else
                DEtoCU_port.imm_s2 <= X"00000" & encodedInstr(31 downto 20);
            end if;

        -- |/////////////////////////////////////////////////////////////////////////////////////| --
        -- |         Encoding Type: ENC_S          |          Store        |                     | --
        -- |/////////////////////////////////////////////////////////////////////////////////////| --
        -- |31|30|29|28|27|26|25|24|23|22|21|20|19|18|17|16|15|14|13|12|11|10|9|8|7|6|5|4|3|2|1|0| --
        -- |      imm[11:5]     |      rs2     |      rs1     | funct3 |  imm[4:0] |    opcode   | --
        -- |/////////////////////////////////////////////////////////////////////////////////////| --
        -- |                      ~sign~ inst[31]                         |   [30:25]  | [11:8]|7| --
        -- |/////////////////////////////////////////////////////////////////////////////////////| --
        elsif (opcode = "0100011") then

            DEtoCU_port.pcSel_s2 <= PC_4;
            DEtoCU_port.imm_s2 <= (others => '0');
            DEtoCU_port.encType_s2 <= ENC_S;
            DEtoCU_port.regFileReq_s2 <= RF_RD;
            DEtoCU_port.regRs1Addr_s2 <= encodedInstr(19 downto 15);
            DEtoCU_port.regRs2Addr_s2 <= encodedInstr(24 downto 20);
            DEtoCU_port.regRdAddr_s2 <= (others => '0');

            DEtoCU_port.aluFunc_s3 <= ALU_ADD;
            DEtoCU_port.aluOp1Sel_s3 <= OP_REG;
            DEtoCU_port.aluOp2Sel_s3 <= OP_IMM;

            DEtoCU_port.dmemReq_s4 <= ME_WR;

            DEtoCU_port.regFileReq_s5 <= RF_WR_X;
            DEtoCU_port.regFileWriteDataSel_s5 <= WB_X;

            -- Instruction-Type
            if    (funct3 = "000") then
                DEtoCU_port.instrType_s2 <= INSTR_SB;
                DEtoCU_port.dmemMask_s4  <= MT_B;
            elsif (funct3 = "001") then
                DEtoCU_port.instrType_s2 <= INSTR_SH;
                DEtoCU_port.dmemMask_s4  <= MT_H;
            elsif (funct3 = "010") then
                DEtoCU_port.instrType_s2 <= INSTR_SW;
                DEtoCU_port.dmemMask_s4  <= MT_W;
            else
                DEtoCU_port.instrType_s2 <= INSTR_UNKNOWN;
                DEtoCU_port.dmemMask_s4  <= MT_X;
            end if;

            -- SET IMMEDIATE (SIGN-EXTENDED)
            if (encodedInstr(31) = '1') then
                DEtoCU_port.imm_s3 <= X"FFFFF" & encodedInstr(31 downto 25) & encodedInstr(11 downto 7);
            else
                DEtoCU_port.imm_s3 <= X"00000" & encodedInstr(31 downto 25) & encodedInstr(11 downto 7);
            end if;

        -- |//////////////////////////////////////////////////////////////////////////////////////| --
        -- |         Encoding Type: ENC_B          |   Conditional_Branch  |                      | --
        -- |//////////////////////////////////////////////////////////////////////////////////////| --
        -- |31|30|29|28|27|26|25|24|23|22|21|20|19|18|17|16|15|14|13|12|11|10|9|8|07|6|5|4|3|2|1|0| --
        -- |12|    imm[10:5]    |      rs2     |      rs1     | funct3 | imm[4:1]|11|    opcode   | --
        -- |//////////////////////////////////////////////////////////////////////////////////////| --
        -- |                      ~sign~ inst[31]                      | 7|   [30:25]   | [11:8]|Z| --
        -- |//////////////////////////////////////////////////////////////////////////////////////| --
        elsif (opcode = "1100011") then

            DEtoCU_port.pcSel_s2 <= PC_BR;
            DEtoCU_port.encType_s2 <= ENC_B;
            DEtoCU_port.regFileReq_s2 <= RF_RD;
            DEtoCU_port.regRs1Addr_s2 <= encodedInstr(19 downto 15);
            DEtoCU_port.regRs2Addr_s2 <= encodedInstr(24 downto 20);
            DEtoCU_port.regRdAddr_s2 <= (others => '0');

            DEtoCU_port.aluFunc_s3 <= ALU_X;
            DEtoCU_port.aluOp1Sel_s3 <= OP_X;
            DEtoCU_port.aluOp2Sel_s3 <= OP_X;
            DEtoCU_port.imm_s3 <= (others => '0');

            DEtoCU_port.dmemReq_s4 <= ME_X;
            DEtoCU_port.dmemMask_s4 <= MT_X;

            DEtoCU_port.regFileReq_s5 <= RF_WR_X;
            DEtoCU_port.regFileWriteDataSel_s5 <= WB_X;

            -- Instruction-Type
            if    (funct3 = "000") then
                DEtoCU_port.instrType_s2 <= INSTR_BEQ;
            elsif (funct3 = "001") then
                DEtoCU_port.instrType_s2 <= INSTR_BNE;
            elsif (funct3 = "100") then
                DEtoCU_port.instrType_s2 <= INSTR_BLT;
            elsif (funct3 = "101") then
                DEtoCU_port.instrType_s2 <= INSTR_BGE;
            elsif (funct3 = "110") then
                DEtoCU_port.instrType_s2 <= INSTR_BLTU;
            elsif (funct3 = "111") then
                DEtoCU_port.instrType_s2 <= INSTR_BGEU;
            else
                DEtoCU_port.instrType_s2 <= INSTR_UNKNOWN;
            end if;

            -- SET IMMEDIATE (SIGN-EXTENDED AND MULTIPLE OF 2)
            if (encodedInstr(31) = '1') then
                DEtoCU_port.imm_s2 <= X"FFFFF" & encodedInstr(7 downto 7) & encodedInstr(30 downto 25) & encodedInstr(11 downto 8) & "0";
            else
                DEtoCU_port.imm_s2 <= X"00000" & encodedInstr(7 downto 7) & encodedInstr(30 downto 25) & encodedInstr(11 downto 8) & "0";
            end if;

        -- |/////////////////////////////////////////////////////////////////////////////////////| --
        -- |         Encoding Type: ENC_U          |  Load_Upper_Immediate |         LUI         | --
        -- |/////////////////////////////////////////////////////////////////////////////////////| --
        -- |31|30|29|28|27|26|25|24|23|22|21|20|19|18|17|16|15|14|13|12|11|10|9|8|7|6|5|4|3|2|1|0| --
        -- |                         imm[31:12]                        |     rd    |    opcode   | --
        -- |/////////////////////////////////////////////////////////////////////////////////////| --
        -- |31|       inst[30:20]              |      inst[19:12]      |          ~zero~         | --
        -- |/////////////////////////////////////////////////////////////////////////////////////| --
        elsif (opcode = "0110111") then

            DEtoCU_port.pcSel_s2 <= PC_4;
            DEtoCU_port.imm_s2 <= (others => '0');
            DEtoCU_port.encType_s2 <= ENC_U;
            DEtoCU_port.instrType_s2 <= INSTR_LUI;
            DEtoCU_port.regFileReq_s2 <= RF_RD_X;
            DEtoCU_port.regRs1Addr_s2 <= (others => '0');
            DEtoCU_port.regRs2Addr_s2 <= (others => '0');
            DEtoCU_port.regRdAddr_s2 <= encodedInstr(11 downto 7);

            DEtoCU_port.aluFunc_s3 <= ALU_COPY1;
            DEtoCU_port.aluOp1Sel_s3 <= OP_IMM;
            DEtoCU_port.aluOp2Sel_s3 <= OP_X;
            DEtoCU_port.imm_s3 <= encodedInstr(31 downto 12) & X"000";

            DEtoCU_port.dmemReq_s4 <= ME_X;
            DEtoCU_port.dmemMask_s4 <= MT_X;

            DEtoCU_port.regFileReq_s5 <= RF_WR;
            DEtoCU_port.regFileWriteDataSel_s5 <= WB_ALU;

        -- |/////////////////////////////////////////////////////////////////////////////////////| --
        -- |         Encoding Type: ENC_U          |Add_Upper_Immediate_PC |        AUIPC        | --
        -- |/////////////////////////////////////////////////////////////////////////////////////| --
        -- |31|30|29|28|27|26|25|24|23|22|21|20|19|18|17|16|15|14|13|12|11|10|9|8|7|6|5|4|3|2|1|0| --
        -- |                         imm[31:12]                        |     rd    |    opcode   | --
        -- |/////////////////////////////////////////////////////////////////////////////////////| --
        -- |31|       inst[30:20]              |      inst[19:12]      |          ~zero~         | --
        -- |/////////////////////////////////////////////////////////////////////////////////////| --
        elsif (opcode = "0010111") then

            DEtoCU_port.pcSel_s2 <= PC_4;
            DEtoCU_port.imm_s2 <= (others => '0');
            DEtoCU_port.encType_s2 <= ENC_U;
            DEtoCU_port.instrType_s2 <= INSTR_AUIPC;
            DEtoCU_port.regFileReq_s2 <= RF_RD_X;
            DEtoCU_port.regRs1Addr_s2 <= (others => '0');
            DEtoCU_port.regRs2Addr_s2 <= (others => '0');
            DEtoCU_port.regRdAddr_s2 <= encodedInstr(11 downto 7);

            DEtoCU_port.aluFunc_s3 <= ALU_ADD;
            DEtoCU_port.aluOp1Sel_s3 <= OP_PC;
            DEtoCU_port.aluOp2Sel_s3 <= OP_IMM;
            DEtoCU_port.imm_s3 <= encodedInstr(31 downto 12) & X"000";

            DEtoCU_port.dmemReq_s4 <= ME_X;
            DEtoCU_port.dmemMask_s4 <= MT_X;

            DEtoCU_port.regFileReq_s5 <= RF_WR;
            DEtoCU_port.regFileWriteDataSel_s5 <= WB_ALU;

        -- |/////////////////////////////////////////////////////////////////////////////////////| --
        -- |         Encoding Type: ENC_J          |   Unconditional_Jump  |         JAL         | --
        -- |/////////////////////////////////////////////////////////////////////////////////////| --
        -- |31|30|29|28|27|26|25|24|23|22|21|20|19|18|17|16|15|14|13|12|11|10|9|8|7|6|5|4|3|2|1|0| --
        -- |20|          imm[10:1]          |11|       imm[19:12]      |     rd    |    opcode   | --
        -- |/////////////////////////////////////////////////////////////////////////////////////| --
        -- |         ~sign~ inst[31]           |      inst[19:12]      |20| inst[30:25]|[24:21]|Z| --
        -- |/////////////////////////////////////////////////////////////////////////////////////| --
        elsif (opcode = "1101111") then

            DEtoCU_port.pcSel_s2 <= PC_J;
            DEtoCU_port.encType_s2 <= ENC_J;
            DEtoCU_port.instrType_s2 <= INSTR_JAL;
            DEtoCU_port.regFileReq_s2 <= RF_RD_X;
            DEtoCU_port.regRs1Addr_s2 <= (others => '0');
            DEtoCU_port.regRs2Addr_s2 <= (others => '0');
            DEtoCU_port.regRdAddr_s2 <= encodedInstr(11 downto 7);

            DEtoCU_port.aluFunc_s3 <= ALU_X;
            DEtoCU_port.aluOp1Sel_s3 <= OP_X;
            DEtoCU_port.aluOp2Sel_s3 <= OP_X;
            DEtoCU_port.imm_s3 <= (others => '0');

            DEtoCU_port.dmemReq_s4 <= ME_X;
            DEtoCU_port.dmemMask_s4 <= MT_X;

            DEtoCU_port.regFileReq_s5 <= RF_WR;
            DEtoCU_port.regFileWriteDataSel_s5 <= WB_PC4;

            -- SET IMMEDIATE (SIGN-EXTENDED AND MULTIPLE OF 2)
            if (encodedInstr(31) = '1') then
                DEtoCU_port.imm_s2 <= X"FFF" & encodedInstr(19 downto 12) & encodedInstr(20 downto 20) & encodedInstr(30 downto 21) & "0";
            else
                DEtoCU_port.imm_s2 <= X"000" & encodedInstr(19 downto 12) & encodedInstr(20 downto 20) & encodedInstr(30 downto 21) & "0";
            end if;

        else

            DEtoCU_port.pcSel_s2 <= PC_4;
            DEtoCU_port.imm_s2 <= (others => '0');
            DEtoCU_port.encType_s2 <= ENC_ERR;
            DEtoCU_port.instrType_s2 <= INSTR_UNKNOWN;
            DEtoCU_port.regFileReq_s2 <= RF_RD_X;
            DEtoCU_port.regRs1Addr_s2 <= (others => '0');
            DEtoCU_port.regRs2Addr_s2 <= (others => '0');
            DEtoCU_port.regRdAddr_s2 <= (others => '0');

            DEtoCU_port.aluFunc_s3 <= ALU_X;
            DEtoCU_port.aluOp1Sel_s3 <= OP_X;
            DEtoCU_port.aluOp2Sel_s3 <= OP_X;
            DEtoCU_port.imm_s3 <= (others => '0');

            DEtoCU_port.dmemReq_s4 <= ME_X;
            DEtoCU_port.dmemMask_s4 <= MT_X;

            DEtoCU_port.regFileReq_s5 <= RF_WR_X;
            DEtoCU_port.regFileWriteDataSel_s5 <= WB_X;

        end if;

    end process;

end Decoder_arch;
