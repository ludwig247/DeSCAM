--
-- Created by deutschmann on 05.02.18
--
-- Module: Decoder
--
-- Slave module for decoding Instructions.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use work.SCAM_Model_types.all;

entity Decoder is
port(    
    clk                  : in  std_logic;
    rst                  : in  std_logic;
    CtlToDec_port        : in  Unsigned (31 downto 0);
    CtlToDec_port_sync   : in  bool;
    DecToCtl_port        : out DecodedInstr
    );
end Decoder;


architecture Decoder_arch of Decoder is

begin
     process(clk)

     variable opcode        : Unsigned ( 6 downto 0);
     variable funct3        : Unsigned ( 2 downto 0);
     variable funct7        : Unsigned ( 6 downto 0);
     variable encType_var   : encType;
     variable instrType_var : instrType;
     variable shift_Instr   : bool;

     begin
     if(clk='1' and clk'event) then

         -- Reset Sequence
         if rst = '1' then

             DecToCtl_port.encType   <= ENC_B;
             DecToCtl_port.imm       <= (others => '0');
             DecToCtl_port.instrType <= INSTR_AND;
             DecToCtl_port.rd_addr   <= (others => '0');
             DecToCtl_port.rs1_addr  <= (others => '0');
             DecToCtl_port.rs2_addr  <= (others => '0');
             opcode := (others => '0');
             funct3 := (others => '0');
             funct7 := (others => '0');
             encType_var   := ENC_ERR;
             instrType_var := INSTR_UNKNOWN;
             shift_instr := false;

         else

                 -- Decoding Requested
                 if CtlToDec_port_sync = true then

                     -- Set Default
                     encType_var   := ENC_ERR;
                     instrType_var := INSTR_UNKNOWN;

                     -- Determine opcode, funct3 and funct7
                     opcode := CtlToDec_port( 6 downto  0);
                     funct3 := CtlToDec_port(14 downto 12);
                     funct7 := CtlToDec_port(31 downto 25);

                     -- Set rs1_addr, rs2_addr and rd_addr (For all Instructions)
                     DecToCtl_port.rs1_addr <= CtlToDec_port(19 downto 15);
                     DecToCtl_port.rs2_addr <= CtlToDec_port(24 downto 20);
                     DecToCtl_port.rd_addr  <= CtlToDec_port(11 downto  7);


                     -------------- Register-Immediate --------------
                     if    (opcode = "0010011") then

                         shift_instr := false;

                         -- I-Type encoding
                         encType_var := ENC_I_I;

                         -- Instruction-Type
                         if    (funct3 = "000") then
                             instrType_var := INSTR_ADDI;
                         elsif (funct3 = "111") then
                             instrType_var := INSTR_ANDI;
                         elsif (funct3 = "110") then
                             instrType_var := INSTR_ORI;
                         elsif (funct3 = "100") then
                             instrType_var := INSTR_XORI;
                         elsif (funct3 = "010") then
                             instrType_var := INSTR_SLTI;
                         elsif (funct3 = "011") then
                             instrType_var := INSTR_SLTUI;
                         elsif (funct3 = "001") then
                             instrType_var := INSTR_SLLI;
                             shift_instr := true;                             
                         elsif (funct3 = "101") then
                             if    (funct7 = "0000000")  then
                                 instrType_var := INSTR_SRLI;
                                 shift_instr := true;
                             elsif (funct7 = "0100000") then
                                 instrType_var := INSTR_SRAI;
                                 shift_instr := true;
                             end if;         
                         end if;

                         -- Set Immediate
                         if (shift_instr = false) then
                             -- Sign-extend
                             if (CtlToDec_port(31) = '1') then
                                 DecToCtl_port.imm <= X"FFFFF" & CtlToDec_port(31 downto 20);
                             else
                                 DecToCtl_port.imm <= X"00000" & CtlToDec_port(31 downto 20);
                             end if;
                         else
                             DecToCtl_port.imm <= to_unsigned(0, 27) & CtlToDec_port(24 downto 20);
                         end if;


                     --------------- Register-Register -------------
                     elsif (opcode = "0110011") then

                         -- R-Type encoding
                         encType_var := ENC_R;

                         -- Instruction-Type
                         if    (funct3 = "000") then
                             if    (funct7 = "0000000")  then
                                 instrType_var := INSTR_ADD;
                             elsif (funct7 = "0100000") then
                                 instrType_var := INSTR_SUB;
                             end if;
                         elsif (funct3 = "001") then
                             instrType_var := INSTR_SLL;
                         elsif (funct3 = "010") then
                             instrType_var := INSTR_SLT;
                         elsif (funct3 = "011") then
                             instrType_var := INSTR_SLTU;
                         elsif (funct3 = "100") then
                             instrType_var := INSTR_XOR;
                         elsif (funct3 = "101") then
                             if    (funct7 = "0000000")  then
                                 instrType_var := INSTR_SRL;
                             elsif (funct7 = "0100000") then
                                 instrType_var := INSTR_SRA;
                             end if;
                         elsif (funct3 = "110") then
                             instrType_var := INSTR_OR;
                         elsif (funct3 = "111") then
                             instrType_var := INSTR_AND;
                         end if;

                         -- Set Immediate
                         DecToCtl_port.imm <= (others => '0');


                     -------------- Conditional Branch --------------
                     elsif (opcode = "1100011") then

                         -- B-Type encoding
                         encType_var := ENC_B;

                         -- Instruction-Type
                         if    (funct3 = "000") then
                             instrType_var := INSTR_BEQ;
                         elsif (funct3 = "001") then
                             instrType_var := INSTR_BNE;
                         elsif (funct3 = "100") then
                             instrType_var := INSTR_BLT;
                         elsif (funct3 = "101") then
                             instrType_var := INSTR_BGE;
                         elsif (funct3 = "110") then
                             instrType_var := INSTR_BLTU;
                         elsif (funct3 = "111") then
                             instrType_var := INSTR_BGEU;
			 else
			     instrType_var := INSTR_UNKNOWN;
                         end if;

                         -- Set Immediate (sign-extended and multiple of 2)
                         if (CtlToDec_port(31) = '1') then
                             DecToCtl_port.imm <= X"FFFFF" & CtlToDec_port(7 downto 7) & CtlToDec_port(30 downto 25) & CtlToDec_port(11 downto 8) & "0";
                         else
                             DecToCtl_port.imm <= X"00000" & CtlToDec_port(7 downto 7) & CtlToDec_port(30 downto 25) & CtlToDec_port(11 downto 8) & "0";
                         end if;


                     --------------------- Load ---------------------
                     elsif (opcode = "0000011") then

                         -- I-Type encoding
                         encType_var := ENC_I_L;

                         -- Instruction-Type
                         if    (funct3 = "000") then
                             instrType_var := INSTR_LB;
                         elsif (funct3 = "001") then
                             instrType_var := INSTR_LH;
                         elsif (funct3 = "010") then
                             instrType_var := INSTR_LW;
                         elsif (funct3 = "100") then
                             instrType_var := INSTR_LBU;
                         elsif (funct3 = "101") then
                             instrType_var := INSTR_LHU;
                         end if;

                         -- Set Immediate (sign-extended)
                         if (CtlToDec_port(31) = '1') then
                             DecToCtl_port.imm <= X"FFFFF" & CtlToDec_port(31 downto 20);
                         else
                             DecToCtl_port.imm <= X"00000" & CtlToDec_port(31 downto 20);
                         end if;


                     ---------------------- lui ---------------------
                     elsif (opcode = "0110111") then

                         -- U-Type encoding
                         encType_var := ENC_U;

                         -- Instruction-Type
                         instrType_var := INSTR_LUI;

                         -- Set Immediate
                         DecToCtl_port.imm <= CtlToDec_port(31 downto 12) & X"000";


                     --------------------- auipc --------------------
                     elsif (opcode = "0010111") then

                         -- U-Type encoding
                         encType_var := ENC_U;

                         -- Instruction-Type
                         instrType_var := INSTR_AUIPC;

                         -- Set Immediate
                         DecToCtl_port.imm <= CtlToDec_port(31 downto 12) & X"000";


                     ---------------------- jal ---------------------
                     elsif (opcode = "1101111") then

                         -- J-Type encoding
                         encType_var := ENC_J;

                         -- Instruction-Type
                         instrType_var := INSTR_JAL;

                         -- Set Immediate (sign-extended and multiple of 2)
                         if (CtlToDec_port(31) = '1') then
                             DecToCtl_port.imm <= X"FFF" & CtlToDec_port(19 downto 12) & CtlToDec_port(20 downto 20) & CtlToDec_port(30 downto 21) & "0";
                         else
                             DecToCtl_port.imm <= X"000" & CtlToDec_port(19 downto 12) & CtlToDec_port(20 downto 20) & CtlToDec_port(30 downto 21) & "0";
                         end if;


                     --------------------- jalr ---------------------
                     elsif (opcode = "1100111") then

                         -- I-Type encoding
                         encType_var := ENC_I_J;

                         -- Instruction-Type
                         instrType_var := INSTR_JALR;

                         -- Set Immediate (sign-extended)
                         if (CtlToDec_port(31) = '1') then
                             DecToCtl_port.imm <= X"FFFFF" & CtlToDec_port(31 downto 20);
                         else
                             DecToCtl_port.imm <= X"00000" & CtlToDec_port(31 downto 20);
                         end if;


                     -------------------- Store ---------------------
                     elsif (opcode = "0100011") then

                         -- S-Type encoding
                         encType_var := ENC_S;

                         -- Instruction-Type
                         if    (funct3 = "000") then
                             instrType_var := INSTR_SB;
                         elsif (funct3 = "001") then
                             instrType_var := INSTR_SH;
                         elsif (funct3 = "010") then
                             instrType_var := INSTR_SW;
                         end if;

                         -- Set Immediate (sign-extended)
                         if (CtlToDec_port(31) = '1') then
                             DecToCtl_port.imm <= X"FFFFF" & CtlToDec_port(31 downto 25) & CtlToDec_port(11 downto 7);
                         else
                             DecToCtl_port.imm <= X"00000" & CtlToDec_port(31 downto 25) & CtlToDec_port(11 downto 7);
                         end if;


                     end if;

                     -- Set encType and instrType
                     DecToCtl_port.encType   <=   encType_var;
                     DecToCtl_port.instrtype <= instrType_var;

                 end if;

         end if;
     end if;
     end process;
end Decoder_arch;




























