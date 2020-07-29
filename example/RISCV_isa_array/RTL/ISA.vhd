--
-- Created by deutschmann on 08.10.18
--

library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;

entity ISA is
port(    
    clk: in std_logic;
    rst: in std_logic;
    fromMemoryPort        : in  MEtoCU_IF;
    fromMemoryPort_sync   : in  bool;
    fromMemoryPort_notify : out bool;
    fromRegsPort          : in  RegfileType;
    toMemoryPort          : out CUtoME_IF;
    toMemoryPort_sync     : in  bool;
    toMemoryPort_notify   : out bool;
    toRegsPort            : out RegfileWriteType;
    toRegsPort_notify     : out bool);
end ISA;

architecture ISA_arch of ISA is
signal section: ISA_SECTIONS;
signal pcReg_signal: unsigned (31 downto 0);

function getImmediate (encodedInstr : in Unsigned (31 downto 0)) return Unsigned is
variable opcode : Unsigned ( 6 downto 0);
variable imm    : Unsigned (31 downto 0);
begin
    opcode := encodedInstr(6 downto 0);
    -- ENC_I_I
    if (opcode = "0010011") then
        if ((encodedInstr(14 downto 12) = "001") or (encodedInstr(14 downto 12) = "101")) then
            imm := to_unsigned(0, 27) & encodedInstr(24 downto 20);
        else
            if (encodedInstr(31) = '1') then
                imm := X"FFFFF" & encodedInstr(31 downto 20);
            else
                imm := X"00000" & encodedInstr(31 downto 20);
            end if;  
        end if;
    -- ENC_I_L and ENC_I_J
    elsif ((opcode = "0000011") or (opcode = "1100111")) then
        if (encodedInstr(31) = '1') then
            imm := X"FFFFF" & encodedInstr(31 downto 20);
        else
            imm := X"00000" & encodedInstr(31 downto 20);
        end if;
    -- ENC_B
    elsif (opcode = "1100011") then
        if (encodedInstr(31) = '1') then
            imm := X"FFFFF" & encodedInstr(7 downto 7) & encodedInstr(30 downto 25) & encodedInstr(11 downto 8) & "0";
        else
            imm := X"00000" & encodedInstr(7 downto 7) & encodedInstr(30 downto 25) & encodedInstr(11 downto 8) & "0";
        end if;
    -- ENC_S
    elsif (opcode = "0100011") then
        if (encodedInstr(31) = '1') then
            imm := X"FFFFF" & encodedInstr(31 downto 25) & encodedInstr(11 downto 7);
        else
            imm := X"00000" & encodedInstr(31 downto 25) & encodedInstr(11 downto 7);
        end if;
    -- ENC_U
    elsif ((opcode = "0110111") or (opcode = "0010111")) then
        imm := encodedInstr(31 downto 12) & X"000";
    -- ENC_J
    elsif (opcode = "1101111") then
        if (encodedInstr(31) = '1') then
            imm := X"FFF" & encodedInstr(19 downto 12) & encodedInstr(20 downto 20) & encodedInstr(30 downto 21) & "0";
        else
            imm := X"000" & encodedInstr(19 downto 12) & encodedInstr(20 downto 20) & encodedInstr(30 downto 21) & "0";
        end if;
    -- Default
    else
        imm := (others => '0');
    end if;
    return imm;
end function getImmediate;

function getInstrType (encodedInstr : in Unsigned (31 downto 0)) return InstrType is
variable opcode : Unsigned ( 6 downto 0);
variable funct3 : Unsigned ( 2 downto 0);
variable funct7 : Unsigned ( 6 downto 0);
begin
    opcode := encodedInstr( 6 downto  0);
    funct3 := encodedInstr(14 downto 12);
    funct7 := encodedInstr(31 downto 25);
    if (opcode = "0110011") then
        if (funct3 = "000") then
            if    (funct7 = "0000000") then
                return INSTR_ADD;
            elsif (funct7 = "0100000") then
                return INSTR_SUB;
            else 
                return INSTR_UNKNOWN;
            end if;
        elsif (funct3 = "001") then
            return INSTR_SLL;
        elsif (funct3 = "010") then
            return INSTR_SLT;
        elsif (funct3 = "011") then
            return INSTR_SLTU;
        elsif (funct3 = "100") then
            return INSTR_XOR;
        elsif (funct3 = "101") then
            if    (funct7 = "0000000") then
                return INSTR_SRL;
            elsif (funct7 = "0100000") then
                return INSTR_SRA;
            else 
                return INSTR_UNKNOWN;
            end if;
        elsif (funct3 = "110") then
            return INSTR_OR;
        elsif (funct3 = "111") then
            return INSTR_AND;
        else 
            return INSTR_UNKNOWN;
        end if;
    elsif (opcode = "0010011") then
        if    (funct3 = "000") then
            return INSTR_ADDI;
        elsif (funct3 = "001") then
            return INSTR_SLLI;
        elsif (funct3 = "010") then
            return INSTR_SLTI;
        elsif (funct3 = "011") then
            return INSTR_SLTUI;
        elsif (funct3 = "100") then
            return INSTR_XORI;
        elsif (funct3 = "101") then
            if    (funct7 = "0000000") then
                return INSTR_SRLI;
            elsif (funct7 = "0100000") then
                return INSTR_SRAI;
            else
                return INSTR_UNKNOWN;
            end if;
        elsif (funct3 = "110") then
            return INSTR_ORI;
        elsif (funct3 = "111") then
            return INSTR_ANDI;
        else 
            return INSTR_UNKNOWN;
        end if;
    elsif (opcode = "0000011") then
        if    (funct3 = "000") then
            return INSTR_LB;
        elsif (funct3 = "001") then
            return INSTR_LH;
        elsif (funct3 = "010") then
            return INSTR_LW;
        elsif (funct3 = "100") then
            return INSTR_LBU;
        elsif (funct3 = "101") then
            return INSTR_LHU;
        else
            return INSTR_UNKNOWN;
        end if;
    elsif (opcode = "1100111") then
        return INSTR_JALR;
    elsif (opcode = "0100011") then
        if    (funct3 = "000") then
            return INSTR_SB;
        elsif (funct3 = "001") then
            return INSTR_SH;
        elsif (funct3 = "010") then
            return INSTR_SW;
        else 
            return INSTR_UNKNOWN;
        end if;
    elsif (opcode = "1100011") then
        if    (funct3 = "000") then
            return INSTR_BEQ;
        elsif (funct3 = "001") then
            return INSTR_BNE;
        elsif (funct3 = "100") then
            return INSTR_BLT;
        elsif (funct3 = "101") then
            return INSTR_BGE;
        elsif (funct3 = "110") then
            return INSTR_BLTU;
        elsif (funct3 = "111") then
            return INSTR_BGEU;
        else 
            return INSTR_UNKNOWN;
        end if;
    elsif (opcode = "0110111") then
        return INSTR_LUI;
    elsif (opcode = "0010111") then
        return INSTR_AUIPC;
    elsif (opcode = "1101111") then
        return INSTR_JAL;
    else
        return INSTR_UNKNOWN;
    end if;
end function getInstrType;

function getALUfuncType (instr : in instrType) return ALUfuncType is
begin
    if (instr = INSTR_ADD or instr = INSTR_ADDI) then
        return ALU_ADD;
    elsif (instr = INSTR_SUB) then
        return ALU_SUB;
    elsif (instr = INSTR_SLL or instr = INSTR_SLLI) then
        return ALU_SLL;
    elsif (instr = INSTR_SLT or instr = INSTR_SLTI) then
        return ALU_SLT;
    elsif (instr = INSTR_SLTU or instr = INSTR_SLTUI) then
        return ALU_SLTU;
    elsif (instr = INSTR_XOR or instr = INSTR_XORI) then
        return ALU_XOR;
    elsif (instr = INSTR_SRL or instr = INSTR_SRLI) then
        return ALU_SRL;
    elsif (instr = INSTR_SRA or instr = INSTR_SRAI) then
        return ALU_SRA;
    elsif (instr = INSTR_OR or instr = INSTR_ORI) then
        return ALU_OR;
    elsif (instr = INSTR_AND or instr = INSTR_ANDI) then
        return ALU_AND;
    elsif (instr = INSTR_LB or instr = INSTR_LH or instr = INSTR_LW or instr = INSTR_LBU or instr = INSTR_LHU) then
        return ALU_ADD;
    elsif (instr = INSTR_JALR or instr = INSTR_JAL) then
        return ALU_X;
    elsif (instr = INSTR_BEQ or instr = INSTR_BNE) then
        return ALU_SUB;
    elsif (instr = INSTR_BLT or instr = INSTR_BGE) then
        return ALU_SLT;
    elsif (instr = INSTR_BLTU or instr = INSTR_BGEU) then
        return ALU_SLTU;
    elsif (instr = INSTR_SB or instr = INSTR_SH or instr = INSTR_SW) then
        return ALU_ADD;
    elsif (instr = INSTR_AUIPC) then
        return ALU_ADD;
    elsif (instr = INSTR_LUI) then
        return ALU_COPY1;
    else 
        return ALU_X;
    end if;
end function getALUfuncType;

function getALUresult (
    aluFunction : in ALUfuncType;
    operand1 : in Unsigned (31 downto 0);
    operand2 : in Unsigned (31 downto 0)) return Unsigned is
begin
    if (aluFunction = ALU_ADD) then
        return (operand1 + operand2);
    elsif (aluFunction = ALU_SUB) then
        return (operand1 - operand2);
    elsif (aluFunction = ALU_AND) then
        return (operand1 and operand2);
    elsif (aluFunction = ALU_OR) then
        return (operand1 or operand2);
    elsif (aluFunction = ALU_XOR) then
        return (operand1 xor operand2);
    elsif (aluFunction = ALU_SLT) then
        if (signed(operand1) < signed(operand2)) then
            return to_unsigned(1, 32);
        else
            return to_unsigned(0, 32);
        end if;
    elsif (aluFunction = ALU_SLTU) then
        if (operand1 < operand2) then
            return to_unsigned(1, 32);
        else 
            return to_unsigned(0, 32);
        end if;
    elsif (aluFunction = ALU_SLL) then
        return shift_left(operand1, to_integer(operand2 and to_unsigned(31, 32)));
    elsif (aluFunction = ALU_SRA) then
        return unsigned(shift_right(signed(operand1), to_integer(operand2 and to_unsigned(31, 32))));   
    elsif (aluFunction = ALU_SRL) then
        return shift_right(operand1, to_integer(operand2 and to_unsigned(31, 32)));
    elsif (aluFunction = ALU_COPY1) then
        return operand1;
    else 
        return to_unsigned(0, 32);
    end if;
end function getALUresult;

function readRegfile (
    src     : in Unsigned (4 downto 0);
    regfile : in RegfileType) return Unsigned is
begin
    if    (src = 0) then
        return to_unsigned(0, 32);
    elsif (src = 1) then
        return regfile.reg_file_01;
    elsif (src = 2) then
        return regfile.reg_file_02;
    elsif (src = 3) then
        return regfile.reg_file_03;
    elsif (src = 4) then
        return regfile.reg_file_04;
    elsif (src = 5) then
        return regfile.reg_file_05;
    elsif (src = 6) then
        return regfile.reg_file_06;
    elsif (src = 7) then
        return regfile.reg_file_07;
    elsif (src = 8) then
        return regfile.reg_file_08;
    elsif (src = 9) then
        return regfile.reg_file_09;
    elsif (src = 10) then
        return regfile.reg_file_10;
    elsif (src = 11) then
        return regfile.reg_file_11;
    elsif (src = 12) then
        return regfile.reg_file_12;
    elsif (src = 13) then
        return regfile.reg_file_13;
    elsif (src = 14) then
        return regfile.reg_file_14;
    elsif (src = 15) then
        return regfile.reg_file_15;
    elsif (src = 16) then
        return regfile.reg_file_16;
    elsif (src = 17) then
        return regfile.reg_file_17;
    elsif (src = 18) then
        return regfile.reg_file_18;
    elsif (src = 19) then
        return regfile.reg_file_19;
    elsif (src = 20) then
        return regfile.reg_file_20;
    elsif (src = 21) then
        return regfile.reg_file_21;
    elsif (src = 22) then
        return regfile.reg_file_22;
    elsif (src = 23) then
        return regfile.reg_file_23;
    elsif (src = 24) then
        return regfile.reg_file_24;
    elsif (src = 25) then
        return regfile.reg_file_25;
    elsif (src = 26) then
        return regfile.reg_file_26;
    elsif (src = 27) then
        return regfile.reg_file_27;
    elsif (src = 28) then
        return regfile.reg_file_28;
    elsif (src = 29) then
        return regfile.reg_file_29;
    elsif (src = 30) then
        return regfile.reg_file_30;
    else 
        return regfile.reg_file_31;
    end if;
end function readRegfile;

function getMemoryMask (instr : in instrType) return ME_MaskType is
begin
    if    (instr = INSTR_LW or instr = INSTR_SW) then
        return MT_W;
    elsif (instr = INSTR_LH or instr = INSTR_SH) then
        return MT_H;
    elsif (instr = INSTR_LB or instr = INSTR_SB) then
        return MT_B;
    elsif (instr = INSTR_LHU) then
        return MT_HU;
    elsif (instr = INSTR_LBU) then
        return MT_BU;
    else 
        return MT_X;
    end if;
end function getMemoryMask;

begin
     process(clk)

     variable encodedInstr : Unsigned (31 downto 0);
     variable opcode       : Unsigned ( 6 downto 0);
     variable funct3       : Unsigned ( 2 downto 0);
     variable funct7       : Unsigned ( 6 downto 0);
     variable rs1_addr     : Unsigned ( 4 downto 0);
     variable rs2_addr     : Unsigned ( 4 downto 0);
     variable rd_addr      : Unsigned ( 4 downto 0);
     variable imm          : Unsigned (31 downto 0);
     variable aluOp1       : Unsigned (31 downto 0);
     variable aluOp2       : Unsigned (31 downto 0);
     variable aluResult    : Unsigned (31 downto 0);
     variable instruction : instrType;
     variable aluFunction : ALUfuncType;

     begin
     if(clk='1' and clk'event) then
         if rst = '1' then
            section <=fetch;
            toMemoryPort.addrIn<=(others => '0');
            toMemoryPort.dataIn<=(others => '0');
            toMemoryPort.mask<=MT_W;
            toMemoryPort.req<=ME_RD;
            pcReg_signal<=(others => '0');
            toRegsPort.dst<=(others => '0');
            toRegsPort.dstData<=(others => '0');
            fromMemoryPort_notify <= false;
            toMemoryPort_notify <= true;
            toRegsPort_notify <= false;
            encodedInstr := (others => '0');
            opcode       := (others => '0');
            funct3       := (others => '0');
            funct7       := (others => '0');
            rs1_addr     := (others => '0');
            rs2_addr     := (others => '0');
            rd_addr      := (others => '0');
            imm          := (others => '0');
            aluOp1       := (others => '0');
            aluOp2       := (others => '0');
            aluResult    := (others => '0');
            instruction := INSTR_ADD;
            aluFunction := ALU_ADD;

         else

         -- Send fetch request to Memory
         if (section = fetch) then

             toRegsPort_notify <= false;

             if (toMemoryPort_sync = true) then
                 toMemoryPort_notify   <= false;
                 fromMemoryPort_notify <= true;
                 section <= execute;
             end if;

         end if;

         -- Receive, decode and execute instruction
         if (section = execute) then

             if (fromMemoryPort_sync = true) then

                 fromMemoryPort_notify <= false;

                 encodedInstr := fromMemoryPort.loadedData;
         
                 opcode := encodedInstr( 6 downto  0);
                 funct3 := encodedInstr(14 downto 12);
                 funct7 := encodedInstr(31 downto 25);

                 rs1_addr := encodedInstr(19 downto 15);
                 rs2_addr := encodedInstr(24 downto 20);
                 rd_addr  := encodedInstr(11 downto  7);

                 imm := getImmediate(encodedInstr);

                 instruction := getInstrType(encodedInstr);
                 aluFunction := getALUfuncType(instruction);

                 -- ENC_R
                 if (opcode = "0110011") then
             
                     aluOp1 := readRegfile(rs1_addr, fromRegsPort);
                     aluOp2 := readRegfile(rs2_addr, fromRegsPort);
                 
                     aluResult := getALUresult(aluFunction, aluOp1, aluOp2);

                     toRegsPort.dst     <= rd_addr;
                     toRegsPort.dstData <= aluResult;
                     toRegsPort_notify  <= true;

                     pcReg_signal <= pcReg_signal + 4;

                     toMemoryPort.addrIn <= pcReg_signal + 4;
                     toMemoryPort_notify <= true;

                     section <= fetch;

                 -- ENC_B
                 elsif (opcode = "1100011") then

                     aluOp1 := readRegfile(rs1_addr, fromRegsPort);
                     aluOp2 := readRegfile(rs2_addr, fromRegsPort);

                     aluResult := getALUresult(aluFunction, aluOp1, aluOp2);
              
                     if    (instruction = INSTR_BEQ  and      aluResult = 0) then
                         pcReg_signal        <= pcReg_signal + imm;
                         toMemoryPort.addrIn <= pcReg_signal + imm;
                     elsif (instruction = INSTR_BNE  and not (aluResult = 0)) then
                         pcReg_signal        <= pcReg_signal + imm;
                         toMemoryPort.addrIn <= pcReg_signal + imm;
                     elsif (instruction = INSTR_BLT  and      aluResult = 1) then
                         pcReg_signal        <= pcReg_signal + imm;
                         toMemoryPort.addrIn <= pcReg_signal + imm;
                     elsif (instruction = INSTR_BGE  and      aluResult = 0) then
                         pcReg_signal        <= pcReg_signal + imm;
                         toMemoryPort.addrIn <= pcReg_signal + imm;
                     elsif (instruction = INSTR_BLTU and      aluResult = 1) then
                         pcReg_signal        <= pcReg_signal + imm;
                         toMemoryPort.addrIn <= pcReg_signal + imm;
                     elsif (instruction = INSTR_BGEU and      aluResult = 0) then
                         pcReg_signal        <= pcReg_signal + imm;
                         toMemoryPort.addrIn <= pcReg_signal + imm;
                     else 
                         pcReg_signal        <= pcReg_signal + 4;
                         toMemoryPort.addrIn <= pcReg_signal + 4;
                     end if;

                     toMemoryPort_notify <= true;

                     section <= fetch;

                 -- ENC_S
                 elsif (opcode = "0100011") then

                     aluOp1 := readRegfile(rs1_addr, fromRegsPort);
                     aluOp2 := imm;

                     aluResult := getALUresult(ALU_ADD, aluOp1, aluOp2); 

                     toMemoryPort.addrIn <= aluResult;
                     toMemoryPort.dataIn <= readRegfile(rs2_addr, fromRegsPort); 
                     toMemoryPort.mask   <= getMemoryMask(instruction);
                     toMemoryPort.req    <= ME_WR;
                     toMemoryPort_notify <= true;

                     section <= store1;

                 -- ENC_U
                 elsif ((opcode = "0110111") or (opcode = "0010111")) then

                     -- INSTR_LUI
                     if (instruction = INSTR_LUI) then

                         aluOp1 := imm;
                         aluOp2 := to_unsigned(0, 32);

                         aluResult := getALUresult(aluFunction, aluOp1, aluOp2); 

                     -- INSTR_AUIPC
                     else 

                         aluOp1 := pcReg_signal;
                         aluOp2 := imm;

                         aluResult := getALUresult(aluFunction, aluOp1, aluOp2); 

                     end if;

                     toRegsPort.dst     <= rd_addr;
                     toRegsPort.dstData <= aluResult;
                     toRegsPort_notify  <= true;

                     pcReg_signal <= pcReg_signal + 4;

                     toMemoryPort.addrIn <= pcReg_signal + 4;
                     toMemoryPort_notify <= true;

                     section <= fetch;

                 -- ENC_J
                 elsif (opcode = "1101111") then
            
                     toRegsPort.dst     <= rd_addr;
                     toRegsPort.dstData <= pcReg_signal + 4;
                     toRegsPort_notify  <= true; 
              
                     pcReg_signal <= pcReg_signal + imm;

                     toMemoryPort.addrIn <= pcReg_signal + imm;
                     toMemoryPort_notify <= true;

                     section <= fetch;

                 -- ENC_I_I
                 elsif (opcode = "0010011") then

                     aluOp1 := readRegfile(rs1_addr, fromRegsPort);
                     aluOp2 := imm;
                 
                     aluResult := getALUresult(aluFunction, aluOp1, aluOp2);

                     toRegsPort.dst     <= rd_addr;
                     toRegsPort.dstData <= aluResult;
                     toRegsPort_notify  <= true;

                     pcReg_signal <= pcReg_signal + 4;

                     toMemoryPort.addrIn <= pcReg_signal + 4;
                     toMemoryPort_notify <= true;

                     section <= fetch;

                 -- ENC_I_L
                 elsif (opcode = "0000011") then

                     aluOp1 := readRegfile(rs1_addr, fromRegsPort);
                     aluOp2 := imm;

                     aluResult := getALUresult(ALU_ADD, aluOp1, aluOp2);

                     toMemoryPort.addrIn <= aluResult; 
                     toMemoryPort.dataIn <= to_unsigned(0, 32); 
                     toMemoryPort.mask   <= getMemoryMask(instruction);
                     toMemoryPort.req    <= ME_RD;
                     toMemoryPort_notify <= true;

                     toRegsPort.dst <= rd_addr;

                     section <= load1;

                 -- ENC_I_J
                 elsif (opcode = "1100111") then
              
                     toRegsPort.dst     <= rd_addr;
                     toRegsPort.dstData <= pcReg_signal + 4; 
                     toRegsPort_notify  <= true;

                     pcReg_signal <= readRegfile(rs1_addr, fromRegsPort) + imm;

                     toMemoryPort.addrIn <= readRegfile(rs1_addr, fromRegsPort) + imm;
                     toMemoryPort_notify <= true;

                     section <= fetch;

                 else 

                     toMemoryPort_notify <= true;
                     
                     section <= fetch;

                 end if;
             
             end if;
             
         end if;

         -- Write data to memory
         if (section = store1) then
         
             if (toMemoryPort_sync = true) then

                 toMemoryPort_notify <= false;

                 fromMemoryPort_notify <= true;

                 section <= store2;

             end if;

         end if;

         -- Wait for response, that store was successful
         if (section = store2) then

             if (fromMemoryPort_sync = true) then

                 fromMemoryPort_notify <= false;

                 pcReg_signal <= pcReg_signal + 4;

                 toMemoryPort.addrIn <= pcReg_signal + 4;
                 toMemoryPort.dataIn <= to_unsigned(0, 32);
                 toMemoryPort.mask   <= MT_W;
                 toMemoryPort.req    <= ME_RD;
                 toMemoryPort_notify <= true;

                 section <= fetch;

             end if;

         end if;
         -- Request data from memory
         if (section = load1) then

             if (toMemoryPort_sync = true) then

                 toMemoryPort_notify <= false;

                 fromMemoryPort_notify <= true;

                 section <= load2;

             end if;

         end if;

         -- Receive data and writeback to register-file
         if (section = load2) then

             if (fromMemoryPort_sync = true) then

                 fromMemoryPort_notify <= false;

                 toRegsPort.dstData <= fromMemoryPort.loadedData;
                 toRegsPort_notify  <= true;

                 pcReg_signal <= pcReg_signal + 4;

                 toMemoryPort.addrIn <= pcReg_signal + 4;
                 toMemoryPort.dataIn <= to_unsigned(0, 32);
                 toMemoryPort.mask   <= MT_W;
                 toMemoryPort.req    <= ME_RD;
                 toMemoryPort_notify <= true;

                 section <= fetch;

             end if;

         end if;

         end if;
     end if;
     end process;
end ISA_arch;





















