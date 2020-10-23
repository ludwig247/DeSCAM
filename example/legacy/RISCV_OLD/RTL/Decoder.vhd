--
-- Created by deutschmann on 05.02.18
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use work.SCAM_Model_types.all;

entity Decoder is
port(    
    clk                  : in  std_logic;
    rst                  : in  std_logic;
    MemToDec_port        : in  Unsigned (31 downto 0);
    MemToDec_port_sync   : in  bool;
    MemToDec_port_notify : out bool;
    DecToCtl_port        : out DecodedInstr;
    DecToCtl_port_sync   : in  bool;
    DecToCtl_port_notify : out bool);
end Decoder;


architecture Decoder_arch of Decoder is

             signal section              : Decoder_SECTIONS;
             signal decoded_instr_signal : DecodedInstr;
             signal encoded_instr_signal : Unsigned (31 downto 0);

begin
     process(clk)

     variable opcode        : Unsigned ( 6 downto 0);
     variable funct3        : Unsigned ( 2 downto 0);
     variable funct7        : Unsigned ( 6 downto 0);
     variable imm_var       : Unsigned (31 downto 0);
     variable encType_var   : encType;
     variable instrType_var : instrType;
     variable shift_Instr   : bool;

     begin
     if(clk='1' and clk'event) then
         if rst = '1' then
             section <= read;
             decoded_instr_signal.encType   <= B;
             decoded_instr_signal.imm       <= (others => '0');
             decoded_instr_signal.instrType <= And_Instr;
             decoded_instr_signal.rd_addr   <= (others => '0');
             decoded_instr_signal.rs1_addr  <= (others => '0');
             decoded_instr_signal.rs2_addr  <= (others => '0');
             encoded_instr_signal <= (others => '0');
             opcode := (others => '0');
             funct3 := (others => '0');
             funct7 := (others => '0');
             imm_var := (others => '0');
             encType_var   := Error_Type;
             instrType_var := Unknown;
             shift_instr := false;
             MemToDec_port_notify <= true;
             DecToCtl_port_notify <= false;
         else
             if section = read then

                 if MemToDec_port_sync = true then

                     -- Read Port
                     encoded_instr_signal <= MemToDec_port;
                     MemToDec_port_notify <= false;

                     -- Set Default
                     encType_var   := Error_Type;
                     instrType_var := Unknown;

                     -- Determine opcode, funct3 and funct7
                     opcode := MemToDec_port( 6 downto  0);
                     funct3 := MemToDec_port(14 downto 12);
                     funct7 := MemToDec_port(31 downto 25);

                     -- Set rs1_addr, rs2_addr and rd_addr (For all Instructions)
                     decoded_Instr_signal.rs1_addr <= to_unsigned(0, 27) & MemToDec_port(19 downto 15);
                     decoded_Instr_signal.rs2_addr <= to_unsigned(0, 27) & MemToDec_port(24 downto 20);
                     decoded_Instr_signal.rd_addr  <= to_unsigned(0, 27) & MemToDec_port(11 downto  7);

                     DecToCtl_port.rs1_addr <= to_unsigned(0, 27) & MemToDec_port(19 downto 15);
                     DecToCtl_port.rs2_addr <= to_unsigned(0, 27) & MemToDec_port(24 downto 20);
                     DecToCtl_port.rd_addr  <= to_unsigned(0, 27) & MemToDec_port(11 downto  7);


                     -------------- Register-Immediate --------------
                     if    (opcode = "0010011") then

                         shift_instr := false;

                         -- I-Type encoding
                         encType_var := I;

                         -- Instruction-Type
                         if    (funct3 = "000") then
                             instrType_var := addI;
                         elsif (funct3 = "111") then
                             instrType_var := andI;
                         elsif (funct3 = "110") then
                             instrType_var := orI;
                         elsif (funct3 = "100") then
                             instrType_var := xorI;
                         elsif (funct3 = "010") then
                             instrType_var := sltI;
                         elsif (funct3 = "011") then
                             instrType_var := sltIu;
                         elsif (funct3 = "001") then
                             instrType_var := sllI;
                             shift_instr := true;                             
                         elsif (funct3 = "101") then
                             if    (funct7 = "0000000")  then
                                 instrType_var := srlI;
                                 shift_instr := true;
                             elsif (funct7 = "0100000") then
                                 instrType_var := sraI;
                                 shift_instr := true;
                             end if;         
                         end if;

                         -- Set Immediate
                         if (shift_instr = false) then
                             -- Sign-extend
                             if (MemToDec_port(31) = '1') then
                                 imm_var := X"FFFFF" & MemToDec_port(31 downto 20);
                             else
                                 imm_var := X"00000" & MemToDec_port(31 downto 20);
                             end if;
                         else
                             imm_var := to_unsigned(0, 27) & MemToDec_port(24 downto 20);
                         end if;


                     --------------- Register-Register -------------
                     elsif (opcode = "0110011") then

                         -- R-Type encoding
                         encType_var := R;

                         -- Instruction-Type
                         if    (funct3 = "000") then
                             if    (funct7 = "0000000")  then
                                 instrType_var := add;
                             elsif (funct7 = "0100000") then
                                 instrType_var := sub;
                             end if;
                         elsif (funct3 = "001") then
                             instrType_var := sll_Instr;
                         elsif (funct3 = "010") then
                             instrType_var := slt;
                         elsif (funct3 = "011") then
                             instrType_var := sltu;
                         elsif (funct3 = "100") then
                             instrType_var := Xor_Instr;
                         elsif (funct3 = "101") then
                             if    (funct7 = "0000000")  then
                                 instrType_var := srl_Instr;
                             elsif (funct7 = "0100000") then
                                 instrType_var := sra_Instr;
                             end if;
                         elsif (funct3 = "110") then
                             instrType_var := Or_Instr;
                         elsif (funct3 = "111") then
                             instrType_var := And_Instr;
                         end if;

                         -- Set Immediate
                         imm_var := (others => '0');


                     -------------- Conditional Branch --------------
                     elsif (opcode = "1100011") then

                         -- B-Type encoding
                         encType_var := B;

                         -- Instruction-Type
                         if    (funct3 = "000") then
                             instrType_var := beq;
                         elsif (funct3 = "001") then
                             instrType_var := bne;
                         elsif (funct3 = "100") then
                             instrType_var := blt;
                         elsif (funct3 = "101") then
                             instrType_var := bge;
                         elsif (funct3 = "110") then
                             instrType_var := bltu;
                         elsif (funct3 = "111") then
                             instrType_var := bgeu;
                         end if;

                         -- Set Immediate (sign-extended and multiple of 2)
                         if (MemToDec_port(31) = '1') then
                             imm_var := X"FFFFF" & MemToDec_port(7 downto 7) & MemToDec_port(30 downto 25) & MemToDec_port(11 downto 8) & "0";
                         else
                             imm_var := X"00000" & MemToDec_port(7 downto 7) & MemToDec_port(30 downto 25) & MemToDec_port(11 downto 8) & "0";
                         end if;


                     --------------------- Load ---------------------
                     elsif (opcode = "0000011") then

                         -- I-Type encoding
                         encType_var := I;

                         -- Instruction-Type
                         if    (funct3 = "000") then
                             instrType_var := lb;
                         elsif (funct3 = "001") then
                             instrType_var := lh;
                         elsif (funct3 = "010") then
                             instrType_var := lw;
                         elsif (funct3 = "100") then
                             instrType_var := lbu;
                         elsif (funct3 = "101") then
                             instrType_var := lhu;
                         end if;

                         -- Set Immediate (sign-extended)
                         if (MemToDec_port(31) = '1') then
                             imm_var := X"FFFFF" & MemToDec_port(31 downto 20);
                         else
                             imm_var := X"00000" & MemToDec_port(31 downto 20);
                         end if;


                     ---------------------- lui ---------------------
                     elsif (opcode = "0110111") then

                         -- U-Type encoding
                         encType_var := U;

                         -- Instruction-Type
                         instrType_var := lui;

                         -- Set Immediate
                         imm_var := MemToDec_port(31 downto 12) & X"000";


                     --------------------- auipc --------------------
                     elsif (opcode = "0010111") then

                         -- U-Type encoding
                         encType_var := U;

                         -- Instruction-Type
                         instrType_var := auipc;

                         -- Set Immediate
                         imm_var := MemToDec_port(31 downto 12) & X"000";


                     ---------------------- jal ---------------------
                     elsif (opcode = "1101111") then

                         -- J-Type encoding
                         encType_var := J;

                         -- Instruction-Type
                         instrType_var := jal;

                         -- Set Immediate (sign-extended and multiple of 2)
                         if (MemToDec_port(31) = '1') then
                             imm_var := X"FFF" & MemToDec_port(19 downto 12) & MemToDec_port(20 downto 20) & MemToDec_port(30 downto 21) & "0";
                         else
                             imm_var := X"000" & MemToDec_port(19 downto 12) & MemToDec_port(20 downto 20) & MemToDec_port(30 downto 21) & "0";
                         end if;


                     --------------------- jalr ---------------------
                     elsif (opcode = "1100111") then

                         -- I-Type encoding
                         encType_var := I;

                         -- Instruction-Type
                         instrType_var := jalr;

                         -- Set Immediate (sign-extended)
                         if (MemToDec_port(31) = '1') then
                             imm_var := X"FFFFF" & MemToDec_port(31 downto 20);
                         else
                             imm_var := X"00000" & MemToDec_port(31 downto 20);
                         end if;


                     -------------------- Store ---------------------
                     elsif (opcode = "0100011") then

                         -- S-Type encoding
                         encType_var := S;

                         -- Instruction-Type
                         if    (funct3 = "000") then
                             instrType_var := sb;
                         elsif (funct3 = "001") then
                             instrType_var := sh;
                         elsif (funct3 = "010") then
                             instrType_var := sw;
                         end if;

                         -- Set Immediate (sign-extended)
                         if (MemToDec_port(31) = '1') then
                             imm_var := X"FFFFF" & MemToDec_port(31 downto 25) & MemToDec_port(11 downto 7);
                         else
                             imm_var := X"00000" & MemToDec_port(31 downto 25) & MemToDec_port(11 downto 7);
                         end if;


                     end if;

                     -- Set encType, instrType and immediate
                     decoded_Instr_signal.encType    <=   encType_var;
                     decoded_Instr_signal.instrType  <= instrType_var;
                     decoded_Instr_signal.imm        <=       imm_var;

                     DecToCtl_port.encType   <=   encType_var;
                     DecToCtl_port.instrtype <= instrType_var;
                     DecToCtl_port.imm       <=       imm_var;

                     DecToCtl_port_notify <= true;

                     section <= write;

                 end if;

             elsif section = write then

                 if DecToCtl_port_sync = true then

                     DecToCtl_port_notify <= false;

                     MemToDec_port_notify <= true;

                     section <= read;

                 end if;
       
             end if;
         end if;
     end if;
     end process;
end Decoder_arch;




























