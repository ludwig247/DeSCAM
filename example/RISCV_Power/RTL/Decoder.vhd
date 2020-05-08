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
--use work.SCAM_Model_types.all;

entity Decoder is
port(    
    clk                  : in  std_logic;
    rst                  : in  std_logic;
    CtlToDec_port        : in  Unsigned (31 downto 0);
    CtlToDec_port_sync   : in  std_logic;
    DecToCtl_port_encType   : out Unsigned ( 2 downto 0);
    DecToCtl_port_imm       : out Unsigned (31 downto 0);
    DecToCtl_port_instrType : out Unsigned ( 5 downto 0);
    DecToCtl_port_rd_addr   : out Unsigned ( 4 downto 0);
    DecToCtl_port_rs1_addr  : out Unsigned ( 4 downto 0);
    DecToCtl_port_rs2_addr  : out Unsigned ( 4 downto 0)
    );
end Decoder;


architecture Decoder_arch of Decoder is

begin
     process(clk)

     variable opcode        : Unsigned ( 6 downto 0);
     variable funct3        : Unsigned ( 2 downto 0);
     variable funct7        : Unsigned ( 6 downto 0);
     variable encType_var   : Unsigned ( 2 downto 0);
     variable instrType_var : Unsigned ( 5 downto 0);
     variable shift_Instr   : std_logic;

     begin
     if(clk='1' and clk'event) then

         -- Reset Sequence
         if rst = '1' then

             DecToCtl_port_encType   <= "000";
             DecToCtl_port_imm       <= (others => '0');
             DecToCtl_port_instrType <= "000000";
             DecToCtl_port_rd_addr   <= (others => '0');
             DecToCtl_port_rs1_addr  <= (others => '0');
             DecToCtl_port_rs2_addr  <= (others => '0');
             opcode := (others => '0');
             funct3 := (others => '0');
             funct7 := (others => '0');
             encType_var   := "001";
             instrType_var := "000010";
             shift_instr := '0';

         else

                 -- Decoding Requested
                 if CtlToDec_port_sync = '1' then

                     -- Set Default
                     encType_var   := "001";
                     instrType_var := "000010";

                     -- Determine opcode, funct3 and funct7
                     opcode := CtlToDec_port( 6 downto  0);
                     funct3 := CtlToDec_port(14 downto 12);
                     funct7 := CtlToDec_port(31 downto 25);

                     -- Set rs1_addr, rs2_addr and rd_addr (For all Instructions)
                     DecToCtl_port_rs1_addr <= CtlToDec_port(19 downto 15);
                     DecToCtl_port_rs2_addr <= CtlToDec_port(24 downto 20);
                     DecToCtl_port_rd_addr  <= CtlToDec_port(11 downto  7);


                     -------------- Register-Immediate --------------
                     if    (opcode = "0010011") then

                         shift_instr := '0';

                         -- I-Type encoding
                         encType_var := "010";

                         -- Instruction-Type
                         if    (funct3 = "000") then
                             instrType_var := "000101";
                         elsif (funct3 = "111") then
                             instrType_var := "000110";
                         elsif (funct3 = "110") then
                             instrType_var := "010110";
                         elsif (funct3 = "100") then
                             instrType_var := "100101";
                         elsif (funct3 = "010") then
                             instrType_var := "011100";
                         elsif (funct3 = "011") then
                             instrType_var := "011101";
                         elsif (funct3 = "001") then
                             instrType_var := "011001";
                             shift_instr := '1';                             
                         elsif (funct3 = "101") then
                             if    (funct7 = "0000000")  then
                                 instrType_var := "100001";
                                 shift_instr := '1';
                             elsif (funct7 = "0100000") then
                                 instrType_var := "011111";
                                 shift_instr := '1';
                             end if;         
                         end if;

                         -- Set Immediate
                         if (shift_instr = '0') then
                             -- Sign-extend
                             if (CtlToDec_port(31) = '1') then
                                 DecToCtl_port_imm <= X"FFFFF" & CtlToDec_port(31 downto 20);
                             else
                                 DecToCtl_port_imm <= X"00000" & CtlToDec_port(31 downto 20);
                             end if;
                         else
                             DecToCtl_port_imm <= to_unsigned(0, 27) & CtlToDec_port(24 downto 20);
                         end if;


                     --------------- Register-Register -------------
                     elsif (opcode = "0110011") then

                         -- R-Type encoding
                         encType_var := "100";

                         -- Instruction-Type
                         if    (funct3 = "000") then
                             if    (funct7 = "0000000")  then
                                 instrType_var := "000100";
                             elsif (funct7 = "0100000") then
                                 instrType_var := "100011";
                             end if;
                         elsif (funct3 = "001") then
                             instrType_var := "011010";
                         elsif (funct3 = "010") then
                             instrType_var := "011011";
                         elsif (funct3 = "011") then
                             instrType_var := "011110";
                         elsif (funct3 = "100") then
                             instrType_var := "000011";
                         elsif (funct3 = "101") then
                             if    (funct7 = "0000000")  then
                                 instrType_var := "100010";
                             elsif (funct7 = "0100000") then
                                 instrType_var := "100000";
                             end if;
                         elsif (funct3 = "110") then
                             instrType_var := "000001";
                         elsif (funct3 = "111") then
                             instrType_var := "000000";
                         end if;

                         -- Set Immediate
                         DecToCtl_port_imm <= (others => '0');


                     -------------- Conditional Branch --------------
                     elsif (opcode = "1100011") then

                         -- B-Type encoding
                         encType_var := "000";

                         -- Instruction-Type
                         if    (funct3 = "000") then
                             instrType_var := "001000";
                         elsif (funct3 = "001") then
                             instrType_var := "001101";
                         elsif (funct3 = "100") then
                             instrType_var := "001011";
                         elsif (funct3 = "101") then
                             instrType_var := "001001";
                         elsif (funct3 = "110") then
                             instrType_var := "001100";
                         elsif (funct3 = "111") then
                             instrType_var := "001010";
                         end if;

                         -- Set Immediate (sign-extended and multiple of 2)
                         if (CtlToDec_port(31) = '1') then
                             DecToCtl_port_imm <= X"FFFFF" & CtlToDec_port(7 downto 7) & CtlToDec_port(30 downto 25) & CtlToDec_port(11 downto 8) & "0";
                         else
                             DecToCtl_port_imm <= X"00000" & CtlToDec_port(7 downto 7) & CtlToDec_port(30 downto 25) & CtlToDec_port(11 downto 8) & "0";
                         end if;


                     --------------------- Load ---------------------
                     elsif (opcode = "0000011") then

                         -- I-Type encoding
                         encType_var := "010";

                         -- Instruction-Type
                         if    (funct3 = "000") then
                             instrType_var := "010000";
                         elsif (funct3 = "001") then
                             instrType_var := "010010";
                         elsif (funct3 = "010") then
                             instrType_var := "010101";
                         elsif (funct3 = "100") then
                             instrType_var := "010001";
                         elsif (funct3 = "101") then
                             instrType_var := "010011";
                         end if;

                         -- Set Immediate (sign-extended)
                         if (CtlToDec_port(31) = '1') then
                             DecToCtl_port_imm <= X"FFFFF" & CtlToDec_port(31 downto 20);
                         else
                             DecToCtl_port_imm <= X"00000" & CtlToDec_port(31 downto 20);
                         end if;


                     ---------------------- lui ---------------------
                     elsif (opcode = "0110111") then

                         -- U-Type encoding
                         encType_var := "110";

                         -- Instruction-Type
                         instrType_var := "010100";

                         -- Set Immediate
                         DecToCtl_port_imm <= CtlToDec_port(31 downto 12) & X"000";


                     --------------------- auipc --------------------
                     elsif (opcode = "0010111") then

                         -- U-Type encoding
                         encType_var := "110";

                         -- Instruction-Type
                         instrType_var := "000111";

                         -- Set Immediate
                         DecToCtl_port_imm <= CtlToDec_port(31 downto 12) & X"000";


                     ---------------------- jal ---------------------
                     elsif (opcode = "1101111") then

                         -- J-Type encoding
                         encType_var := "011";

                         -- Instruction-Type
                         instrType_var := "001110";

                         -- Set Immediate (sign-extended and multiple of 2)
                         if (CtlToDec_port(31) = '1') then
                             DecToCtl_port_imm <= X"FFF" & CtlToDec_port(19 downto 12) & CtlToDec_port(20 downto 20) & CtlToDec_port(30 downto 21) & "0";
                         else
                             DecToCtl_port_imm <= X"000" & CtlToDec_port(19 downto 12) & CtlToDec_port(20 downto 20) & CtlToDec_port(30 downto 21) & "0";
                         end if;


                     --------------------- jalr ---------------------
                     elsif (opcode = "1100111") then

                         -- I-Type encoding
                         encType_var := "010";

                         -- Instruction-Type
                         instrType_var := "001111";

                         -- Set Immediate (sign-extended)
                         if (CtlToDec_port(31) = '1') then
                             DecToCtl_port_imm <= X"FFFFF" & CtlToDec_port(31 downto 20);
                         else
                             DecToCtl_port_imm <= X"00000" & CtlToDec_port(31 downto 20);
                         end if;


                     -------------------- Store ---------------------
                     elsif (opcode = "0100011") then

                         -- S-Type encoding
                         encType_var := "101";

                         -- Instruction-Type
                         if    (funct3 = "000") then
                             instrType_var := "010111";
                         elsif (funct3 = "001") then
                             instrType_var := "011000";
                         elsif (funct3 = "010") then
                             instrType_var := "100100";
                         end if;

                         -- Set Immediate (sign-extended)
                         if (CtlToDec_port(31) = '1') then
                             DecToCtl_port_imm <= X"FFFFF" & CtlToDec_port(31 downto 25) & CtlToDec_port(11 downto 7);
                         else
                             DecToCtl_port_imm <= X"00000" & CtlToDec_port(31 downto 25) & CtlToDec_port(11 downto 7);
                         end if;


                     end if;

                     -- Set encType and instrType
                     DecToCtl_port_encType   <=   encType_var;
                     DecToCtl_port_instrtype <= instrType_var;

                 end if;

         end if;
     end if;
     end process;
end Decoder_arch;




























