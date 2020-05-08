--
-- Created by deutschmann on 22.01.18
--
-- Module: Control-Path
--
-- Main module for interaction within CPU. Manages communication as Master. Sets control signals.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
--use work.SCAM_Model_types.all;

entity Cpath is
    port(    
        -- Clock
        clk                   : in  std_logic;

        -- Synchronous Reset
        rst                   : in  std_logic;

        -- Communication with ALU
        CtlToALU_port_alu_fun       : out Unsigned ( 3 downto 0);
        CtlToALU_port_imm           : out Unsigned (31 downto 0);
        CtlToALU_port_op1_sel       : out Unsigned ( 1 downto 0);
        CtlToALU_port_op2_sel       : out Unsigned ( 1 downto 0);
        CtlToALU_port_pc_reg        : out Unsigned (31 downto 0);
        CtlToALU_port_reg1_contents : out Unsigned (31 downto 0);
        CtlToALU_port_reg2_contents : out Unsigned (31 downto 0);
        CtlToALU_port_notify        : out std_logic;
        ALUtoCtl_port               : in  Unsigned (31 downto 0);

        -- Communication with Register-File
        CtlToRegs_port_dst       : out Unsigned ( 4 downto 0);
        CtlToRegs_port_dst_data  : out Unsigned (31 downto 0);
        CtlToRegs_port_req       : out std_logic;
        CtlToRegs_port_src1      : out Unsigned ( 4 downto 0);
        CtlToRegs_port_src2      : out Unsigned ( 4 downto 0);
        CtlToRegs_port_notify    : out std_logic;
        RegsToCtl_port_contents1 : in  Unsigned (31 downto 0);
        RegsToCtl_port_contents2 : in  Unsigned (31 downto 0);
         
        -- Communication with Decoder
        CtlToDec_port           : out Unsigned (31 downto 0);
        CtlToDec_port_notify    : out std_logic;
        DecToCtl_port_encType   : in  Unsigned ( 2 downto 0);
        DecToCtl_port_imm       : in  Unsigned (31 downto 0);
        DecToCtl_port_instrType : in  Unsigned ( 5 downto 0);
        DecToCtl_port_rd_addr   : in  Unsigned ( 4 downto 0);
        DecToCtl_port_rs1_addr  : in  Unsigned ( 4 downto 0);
        DecToCtl_port_rs2_addr  : in  Unsigned ( 4 downto 0);

        -- Communication with Memory
        MemToCtl_port        : in  Unsigned (31 downto 0);
        MemToCtl_port_sync   : in  std_logic;
        MemToCtl_port_notify : out std_logic;
        CtlToMem_port_addrIn : out Unsigned (31 downto 0);
        CtlToMem_port_dataIn : out Unsigned (31 downto 0);
        CtlToMem_port_mask   : out Unsigned ( 2 downto 0);
        CtlToMem_port_req    : out std_logic;
        CtlToMem_port_sync   : in  std_logic;
        CtlToMem_port_notify : out std_logic
    );
end Cpath;


architecture Cpath_arch of Cpath is

    -- Signals
    signal section                         : Unsigned ( 3 downto 0);
    signal ALUtoCtl_data_signal            : Unsigned (31 downto 0);
    signal CtlToALU_data_signal_alu_fun    : Unsigned ( 3 downto 0);
    signal CtlToALU_data_signal_op1_sel    : Unsigned ( 1 downto 0);
    signal CtlToALU_data_signal_op2_sel    : Unsigned ( 1 downto 0);
    signal CtlToRegs_data_signal_dst       : Unsigned ( 4 downto 0);
    signal CtlToRegs_data_signal_src1      : Unsigned ( 4 downto 0);
    signal CtlToRegs_data_signal_src2      : Unsigned ( 4 downto 0);
    signal RegsToCtl_data_signal_contents1 : Unsigned (31 downto 0);
    signal RegsToCtl_data_signal_contents2 : Unsigned (31 downto 0);
    signal br_en_signal                    : std_logic;
    signal DecToCtl_data_signal_imm        : Unsigned (31 downto 0);
    signal DecToCtl_data_signal_instrType  : Unsigned ( 5 downto 0);
    signal DecToCtl_data_signal_rd_addr    : Unsigned ( 4 downto 0);
    signal MemToCtl_data_signal            : Unsigned (31 downto 0);
    signal mem_en_signal                   : std_logic;
    signal memoryAccess_signal_mask        : Unsigned ( 2 downto 0);
    signal memoryAccess_signal_req         : std_logic;
    signal pc_next_signal                  : Unsigned (31 downto 0);
    signal pc_reg_signal                   : Unsigned (31 downto 0);
    signal reg_rd_en_signal                : std_logic;
    signal wb_en_signal                    : std_logic;
    signal wb_sel_signal                   : Unsigned ( 1 downto 0);

begin
    process(clk)

    variable reg_rd_en_signal_temp             : std_logic := '0';
    variable CtlToALU_data_signal_op1_sel_temp : Unsigned ( 1 downto 0);
    variable CtlToALU_data_signal_op2_sel_temp : Unsigned ( 1 downto 0);
    variable CtlToALU_data_signal_alu_fun_temp : Unsigned ( 3 downto 0);
    variable pc_sel_var                        : Unsigned ( 2 downto 0);
    variable pc_next_signal_temp               : Unsigned (31 downto 0);

    begin
    if(clk='1' and clk'event) then

         -- Reset Sequence
         if rst = '1' then

            section <= "0000";
            ALUtoCtl_data_signal <= (others => '0');
            CtlToALU_data_signal_alu_fun       <= "0000";
            CtlToALU_port_imm           <= (others => '0');
            CtlToALU_data_signal_op1_sel       <= "00";
            CtlToALU_data_signal_op2_sel       <= "00";
            CtlToALU_port_pc_reg        <= (others => '0');
            CtlToALU_port_reg1_contents <= (others => '0');
            CtlToALU_port_reg2_contents <= (others => '0');
            CtlToRegs_data_signal_dst      <= (others => '0');
            CtlToRegs_port_dst <= (others => '0');
            CtlToRegs_port_dst_data <= (others => '0');
            CtlToRegs_port_req      <= '0';
            CtlToRegs_data_signal_src1     <= (others => '0');
            CtlToRegs_data_signal_src2     <= (others => '0');
            RegsToCtl_data_signal_contents1 <= (others => '0');
            RegsToCtl_data_signal_contents2 <= (others => '0');
            br_en_signal <= '0';
            DecToCtl_data_signal_imm       <= (others => '0');
            DecToCtl_data_signal_instrType <= "000000";
            DecToCtl_data_signal_rd_addr   <= (others => '0');
            MemToCtl_data_signal <= (others => '0');
            mem_en_signal <= '0';
            memoryAccess_signal_mask   <= "100";
            memoryAccess_signal_req    <= '0';
            pc_next_signal <= (others => '0');
            pc_reg_signal <= (others => '0');
            reg_rd_en_signal <= '0';
            wb_en_signal <= '0';
            wb_sel_signal <= "00";
            CtlToMem_port_addrIn <= (others => '0');
            CtlToMem_port_dataIn <= (others => '0');
            CtlToMem_port_mask   <= "100";
            CtlToMem_port_req    <= '0';
            CtlToMem_port_notify <= '1';
            MemToCtl_port_notify <= '0';
            CtlToALU_port_notify <= '0';
            CtlToRegs_port_notify <= '0';
            CtlToDec_port_notify <= '0';


         else

             ---------------------------------- Request Instruction from Memory ---------------------------------
             if section = "0000" then

                if CtlToMem_port_sync = '1' then

                    CtlToMem_port_notify <= '0';

                    MemToCtl_port_notify <= '1';

                    section <= "0001";   

                end if;

              ---------------------- Receive Instruction from Memory and pass it to Decoder ---------------------
             elsif section = "0001" then

                if MemToCtl_port_sync = '1' then

                    MemToCtl_port_notify <= '0';
           
                    CtlToDec_port       <= MemToCtl_port;

                    CtlToDec_port_notify <= '1';

                    section <= "0010";   

                end if;

              ---------------------------------------- Decode Instruction ---------------------------------------
             elsif section = "0010" then

                 CtlToDec_port_notify <= '0';
         
                 section <= "0011";   



              --------------------------------------- Set Control Signals ---------------------------------------
             elsif section = "0011" then
            

                 -- Set default values
                 reg_rd_en_signal_temp             := reg_rd_en_signal;
                 CtlToALU_data_signal_op1_sel_temp := CtlToALU_data_signal_op1_sel;
                 CtlToALU_data_signal_op2_sel_temp := CtlToALU_data_signal_op2_sel;
                 CtlToALU_data_signal_alu_fun_temp := CtlToALU_data_signal_alu_fun;

                 -- Read from Decoder
                 DecToCtl_data_signal_imm       <= DecToCtl_port_imm;
                 DecToCtl_data_signal_instrType <= DecToCtl_port_instrType;
                 DecToCtl_data_signal_rd_addr   <= DecToCtl_port_rd_addr;


                 -- I-Type Instruction
                 if DecToCtl_port_encType = "010" then

                     -- Arithmetics
                     if (DecToCtl_port_instrType = "000101" or DecToCtl_port_instrType = "011100" or
                         DecToCtl_port_instrType = "011101" or DecToCtl_port_instrType = "100101" or
                         DecToCtl_port_instrType = "010110" or DecToCtl_port_instrType = "000110" or
                         DecToCtl_port_instrType = "011001" or DecToCtl_port_instrType = "100001" or
                         DecToCtl_port_instrType = "011111") then

                         -- Common for Arithmetics
                         CtlToALU_data_signal_op1_sel <= "10";
                         CtlToALU_data_signal_op2_sel <= "00";
                         wb_sel_signal <= "00";
                         wb_en_signal <= '1';
                         reg_rd_en_signal <= '1';
                         reg_rd_en_signal_temp := '1';
                         mem_en_signal <= '0';
                         br_en_signal <= '0';

                         -- Set ALU-Function
                         if    DecToCtl_port_instrType = "000101" then
                             CtlToALU_data_signal_alu_fun <= "0000";
                         elsif DecToCtl_port_instrType = "011100" then
                             CtlToALU_data_signal_alu_fun <= "0101";
                         elsif DecToCtl_port_instrType = "011101" then
                             CtlToALU_data_signal_alu_fun <= "0110";
                         elsif DecToCtl_port_instrType = "100101" then
                             CtlToALU_data_signal_alu_fun <= "1011";
                         elsif DecToCtl_port_instrType = "010110" then
                             CtlToALU_data_signal_alu_fun <= "0011";
                         elsif DecToCtl_port_instrType = "000110" then
                             CtlToALU_data_signal_alu_fun <= "0001";
                         elsif DecToCtl_port_instrType = "011001" then
                             CtlToALU_data_signal_alu_fun <= "0100";
                         elsif DecToCtl_port_instrType = "100001" then
                             CtlToALU_data_signal_alu_fun <= "1000";
                         elsif DecToCtl_port_instrType = "011111" then
                             CtlToALU_data_signal_alu_fun <= "0111";
                         end if;

                     -- Loads
                     elsif (DecToCtl_port_instrType = "010000" or DecToCtl_port_instrType = "010010" or
                            DecToCtl_port_instrType = "010101" or DecToCtl_port_instrType = "010001" or
                            DecToCtl_port_instrType = "010011") then

                         -- Common for Loads
                         CtlToALU_data_signal_op1_sel <= "10";
                         CtlToALU_data_signal_op2_sel <= "00";
                         CtlToALU_data_signal_alu_fun <= "0000";
                         wb_sel_signal <= "01";
                         wb_en_signal <= '1';
                         reg_rd_en_signal <= '1';
                         reg_rd_en_signal_temp := '1';
                         mem_en_signal <= '1';
                         br_en_signal <= '0';

                         -- Set Memory Access
                         memoryAccess_signal_req <= '0';

                         -- Set Memory Mask
                         if    DecToCtl_port_instrType = "010000" then
                             memoryAccess_signal_mask <= "000";
                         elsif DecToCtl_port_instrType = "010010" then
                             memoryAccess_signal_mask <= "010";
                         elsif DecToCtl_port_instrType = "010101" then
                             memoryAccess_signal_mask <= "100";
                         elsif DecToCtl_port_instrType = "010001" then
                             memoryAccess_signal_mask <= "001";
                         elsif DecToCtl_port_instrType = "010011" then
                             memoryAccess_signal_mask <= "011";
                         end if;

                     -- JALR
                     elsif DecToCtl_port_instrType = "001111" then

                         CtlToALU_data_signal_op1_sel <= "11";  
                         CtlToALU_data_signal_op2_sel <= "11"; 
                         CtlToALU_data_signal_alu_fun <= "1010";
                         wb_sel_signal <= "10";  
                         wb_en_signal <= '1';
                         reg_rd_en_signal <= '1';
                         reg_rd_en_signal_temp := '1';
                         mem_en_signal <= '0';
                         br_en_signal <= '0';
               
                     end if;


                 -- R-Type Instruction
                 elsif DecToCtl_port_encType = "100" then

                     -- Common for all R-Types
                     CtlToALU_data_signal_op1_sel <= "10";
                     CtlToALU_data_signal_op2_sel <= "10";
                     wb_sel_signal <= "00";
                     wb_en_signal <= '1';
                     reg_rd_en_signal <= '1';
                     reg_rd_en_signal_temp := '1';
                     mem_en_signal <= '0';
                     br_en_signal <= '0';

                     -- Set ALU-Function
                     if    DecToCtl_port_instrType = "000100" then
                         CtlToALU_data_signal_alu_fun <= "0000";
                     elsif DecToCtl_port_instrType = "100011" then
                         CtlToALU_data_signal_alu_fun <= "1001";
                     elsif DecToCtl_port_instrType = "011010" then
                         CtlToALU_data_signal_alu_fun <= "0100";
                     elsif DecToCtl_port_instrType = "011011" then
                         CtlToALU_data_signal_alu_fun <= "0101";
                     elsif DecToCtl_port_instrType = "011110" then
                         CtlToALU_data_signal_alu_fun <= "0110";
                     elsif DecToCtl_port_instrType = "000011" then
                         CtlToALU_data_signal_alu_fun <= "1011";
                     elsif DecToCtl_port_instrType = "100010" then
                         CtlToALU_data_signal_alu_fun <= "1000";
                     elsif DecToCtl_port_instrType = "100000" then
                         CtlToALU_data_signal_alu_fun <= "0111";
                     elsif DecToCtl_port_instrType = "000001" then
                         CtlToALU_data_signal_alu_fun <= "0011";
                     elsif DecToCtl_port_instrType = "000000" then
                         CtlToALU_data_signal_alu_fun <= "0001";
                     end if;


                 -- B-Type Instruction
                 elsif DecToCtl_port_encType = "000" then

                     -- Common for all B-Types
                     CtlToALU_data_signal_op1_sel <= "10";
                     CtlToALU_data_signal_op2_sel <= "10";
                     wb_sel_signal <= "11";
                     wb_en_signal <= '0';
                     reg_rd_en_signal <= '1';
                     reg_rd_en_signal_temp := '1';
                     mem_en_signal <= '0';
                     br_en_signal <= '1';

                     -- Set ALU-Function
                     if    DecToCtl_port_instrType = "001000" then
                         CtlToALU_data_signal_alu_fun <= "1001";
                     elsif DecToCtl_port_instrType = "001101" then
                         CtlToALU_data_signal_alu_fun <= "1001";
                     elsif DecToCtl_port_instrType = "001011" then
                         CtlToALU_data_signal_alu_fun <= "0101";
                     elsif DecToCtl_port_instrType = "001001" then
                         CtlToALU_data_signal_alu_fun <= "0101";
                     elsif DecToCtl_port_instrType = "001100" then
                         CtlToALU_data_signal_alu_fun <= "0110";
                     elsif DecToCtl_port_instrType = "001010" then
                         CtlToALU_data_signal_alu_fun <= "0110";
                     end if;


                 -- J-Type Instruction
                 elsif DecToCtl_port_encType = "011" then

                     -- JAL
                     if DecToCtl_port_instrType = "001110" then

                         CtlToALU_data_signal_op1_sel <= "11";
                         CtlToALU_data_signal_op1_sel_temp := "11";
                         CtlToALU_data_signal_op2_sel <= "11";
                         CtlToALU_data_signal_op2_sel_temp := "11";
                         CtlToALU_data_signal_alu_fun <= "1010";
                         CtlToALU_data_signal_alu_fun_temp := "1010";
                         wb_sel_signal <= "10";
                         wb_en_signal <= '1';
                         reg_rd_en_signal <= '0';
                         reg_rd_en_signal_temp := '0';
                         mem_en_signal <= '0';
                         br_en_signal <= '0';

                     end if;


                 -- S-Type Instruction
                 elsif DecToCtl_port_encType = "101" then

                     -- Common for all S-Types
                     CtlToALU_data_signal_op1_sel <= "10";
                     CtlToALU_data_signal_op2_sel <= "00";
                     CtlToALU_data_signal_alu_fun <= "0000";
                     wb_sel_signal <= "11";
                     wb_en_signal <= '0';
                     reg_rd_en_signal <= '1';
                     reg_rd_en_signal_temp := '1';
                     mem_en_signal <= '1';
                     br_en_signal <= '0';

                     -- Set Memory Access
                     memoryAccess_signal_req <= '1';

                     -- Set Memory Mask
                     if    DecToCtl_port_instrType = "010111" then
                         memoryAccess_signal_mask <= "000";
                     elsif DecToCtl_port_instrType = "011000" then
                         memoryAccess_signal_mask <= "010";
                     elsif DecToCtl_port_instrType = "100100" then
                         memoryAccess_signal_mask <= "100";
                     end if;


                 -- U-Type Instruction
                 elsif DecToCtl_port_encType = "110" then

                     -- Common for all U-Types
                     wb_sel_signal <= "00";
                     wb_en_signal <= '1';
                     reg_rd_en_signal <= '0';
                     reg_rd_en_signal_temp := '0';
                     mem_en_signal <= '0';
                     br_en_signal <= '0';
                        
                     -- Set Operands and ALU-Function
                     if    DecToCtl_port_instrType = "010100" then
                         CtlToALU_data_signal_op1_sel <= "00";
                         CtlToALU_data_signal_op1_sel_temp := "00";
                         CtlToALU_data_signal_op2_sel <= "11";
                         CtlToALU_data_signal_op2_sel_temp := "11";
                         CtlToALU_data_signal_alu_fun <= "0010";
                         CtlToALU_data_signal_alu_fun_temp := "0010";
                     elsif DecToCtl_port_instrType = "000111" then
                         CtlToALU_data_signal_op1_sel <= "01";
                         CtlToALU_data_signal_op1_sel_temp := "01";
                         CtlToALU_data_signal_op2_sel <= "00";
                         CtlToALU_data_signal_op2_sel_temp := "00";
                         CtlToALU_data_signal_alu_fun <= "0000";
                         CtlToALU_data_signal_alu_fun_temp := "0000";
                     end if;

                 end if;
                
                    
                 -- Determine next State
                 if reg_rd_en_signal_temp = '1' then

                     -- Read Registers
                     CtlToRegs_data_signal_src1 <= DecToCtl_port_rs1_addr;
                     CtlToRegs_data_signal_src2 <= DecToCtl_port_rs2_addr;

                     CtlToRegs_port_dst      <= CtlToRegs_data_signal_dst;
                     CtlToRegs_port_req      <= '0';
                     CtlToRegs_port_src1     <= DecToCtl_port_rs1_addr;
                     CtlToRegs_port_src2     <= DecToCtl_port_rs2_addr;

                     CtlToRegs_port_notify <= '1';

                     section <= "0100"; 

                 else

                     CtlToALU_port_alu_fun       <= CtlToALU_data_signal_alu_fun_temp;
                     CtlToALU_port_imm           <= DecToCtl_port_imm;
                     CtlToALU_port_op1_sel       <= CtlToALU_data_signal_op1_sel_temp;
                     CtlToALU_port_op2_sel       <= CtlToALU_data_signal_op2_sel_temp;
                     CtlToALU_port_pc_reg        <= pc_reg_signal;
                     CtlToALU_port_reg1_contents <= RegsToCtl_data_signal_contents1;
                     CtlToALU_port_reg2_contents <= RegsToCtl_data_signal_contents2;       

                     CtlToALU_port_notify <= '1';

                     section <= "0110"; 

                 end if;

                      
 
              --------------------------------------- Read Register-File  ---------------------------------------
             elsif section = "0100" then
                                      
                    CtlToRegs_port_notify <= '0';       

                    section <= "0101"; 



              --------------------- Receive Register-File contents and request ALU-Operation --------------------
             elsif section = "0101" then

                 -- Receive contents from Register-File
                 RegsToCtl_data_signal_contents1 <= RegsToCtl_port_contents1;
                 RegsToCtl_data_signal_contents2 <= RegsToCtl_port_contents2;
                 
                 -- Write Data to ALU
                 CtlToALU_port_alu_fun       <= CtlToALU_data_signal_alu_fun;
                 CtlToALU_port_imm           <= DecToCtl_data_signal_imm;
                 CtlToALU_port_op1_sel       <= CtlToALU_data_signal_op1_sel;
                 CtlToALU_port_op2_sel       <= CtlToALU_data_signal_op2_sel;
                 CtlToALU_port_reg1_contents <= RegsToCtl_port_contents1;
                 CtlToALU_port_reg2_contents <= RegsToCtl_port_contents2;
                 CtlToALU_port_pc_reg        <= pc_reg_signal;

                 CtlToALU_port_notify <= '1';
                
                 section <= "0110"; 




              -------------------------------------- Execute ALU-Operation --------------------------------------
             elsif section = "0110" then

                 CtlToALU_port_notify <= '0';
          
                 section <= "0111"; 




              --------------------------------- Receive and evaluate ALU-Result ---------------------------------
             elsif section = "0111" then


                 -- Read ALU-Result
                 ALUtoCtl_data_signal <= ALUtoCtl_port;                  

                 -- Default
                 pc_sel_var := "000";

                 -- Branches
                 if br_en_signal = '1' then
                     if    (DecToCtl_data_signal_instrType = "001000" and ALUtoCtl_port  = 0) then
                         pc_sel_var := "001";
                     elsif (DecToCtl_data_signal_instrType = "001101" and not (ALUtoCtl_port = 0)) then
                         pc_sel_var := "001";
                     elsif (DecToCtl_data_signal_instrType = "001011" and ALUtoCtl_port  = 1) then
                         pc_sel_var := "001";
                     elsif (DecToCtl_data_signal_instrType = "001001" and ALUtoCtl_port  = 0) then
                         pc_sel_var := "001";
                     elsif (DecToCtl_data_signal_instrType = "001100" and ALUtoCtl_port  = 1) then
                         pc_sel_var := "001";
                     elsif (DecToCtl_data_signal_instrType = "001010" and ALUtoCtl_port  = 0) then
                         pc_sel_var := "001";
                     end if;
                 end if;

                 -- Jumps
                 if    DecToCtl_data_signal_instrType = "001110" then
                     pc_sel_var := "011";
                 elsif DecToCtl_data_signal_instrType = "001111" then
                     pc_sel_var := "100";
                 end if;

                 -- Calculate new PC-Value
                 if    pc_sel_var = "000"   then
                     pc_next_signal_temp := pc_reg_signal + 4;
                 elsif pc_sel_var = "001"  then
                     pc_next_signal_temp := pc_reg_signal + DecToCtl_data_signal_imm;
                 elsif pc_sel_var = "011"   then
                     pc_next_signal_temp := pc_reg_signal + DecToCtl_data_signal_imm;
                 elsif pc_sel_var = "100"  then
                     pc_next_signal_temp := RegsToCtl_data_signal_contents1 + DecToCtl_data_signal_imm;
                 end if;

                 pc_next_signal <= pc_next_signal_temp;
             
                 -- Memory Access is required
                 if mem_en_signal = '1' then

                     CtlToMem_port_addrIn <= ALUtoCtl_port;
                     CtlToMem_port_dataIn <= RegsToCtl_data_signal_contents2;
                     CtlToMem_port_mask   <= memoryAccess_signal_mask;
                     CtlToMem_port_req    <= memoryAccess_signal_req;

                     CtlToMem_port_notify <= '1';

                     section <= "1000";

                 -- "1010" is required
                 elsif (wb_en_signal = '1' and not (DecToCtl_data_signal_rd_addr = 0)) then

                     if    wb_sel_signal = "00" then
                         CtlToRegs_port_dst_data        <= ALUtoCtl_port;
                     elsif wb_sel_signal = "01" then
                         CtlToRegs_port_dst_data        <= MemToCtl_data_signal;
                     elsif wb_sel_signal = "10" then
                         CtlToRegs_port_dst_data        <= pc_reg_signal + 4;
                     end if;


                     CtlToRegs_data_signal_dst <= DecToCtl_data_signal_rd_addr;

                     -- Write to Registers
                     CtlToRegs_port_dst  <= DecToCtl_data_signal_rd_addr;
                     CtlToRegs_port_req  <= '1';
                     CtlToRegs_port_src1 <= CtlToRegs_data_signal_src1;
                     CtlToRegs_port_src2 <= CtlToRegs_data_signal_src2;

                     CtlToRegs_port_notify <= '1';
           
                     section <= "1010";

                 -- Instruction finished -> Send request to Memory for next instruction
                 else 

                     memoryAccess_signal_mask   <= "100";
                     memoryAccess_signal_req    <= '0';

                     CtlToMem_port_addrIn <= pc_next_signal_temp;
                     CtlToMem_port_dataIn <= (others => '0');
                     CtlToMem_port_mask   <= "100";
                     CtlToMem_port_req    <= '0';

                     CtlToMem_port_notify <= '1';

                     pc_reg_signal <= pc_next_signal_temp;

                     section <= "0000";

                 end if; 



              ------------------------------ Write Data to Memory (STORE and LOAD) ------------------------------
             elsif section = "1000" then

                 if CtlToMem_port_sync = '1' then

                    CtlToMem_port_notify <= '0';

                    MemToCtl_port_notify <= '1'; 

     --               if DecToCtl_port_encType = "101" then
                    	section <= "1001";

	--	    else 
	--		section <= "0000";
	--	    end if;


                 end if;




              ------------------------------ Receive and evaluate Data from Memory ------------------------------
             elsif section = "1001" then

                 if MemToCtl_port_sync = '1' then
                 
                    MemToCtl_data_signal <= MemToCtl_port;

                    MemToCtl_port_notify <= '0'; 
             
                    if (wb_en_signal = '1' and not (DecToCtl_data_signal_rd_addr = 0)) then

                        if    wb_sel_signal = "00" then
                            CtlToRegs_port_dst_data        <= ALUtoCtl_data_signal;
                        elsif wb_sel_signal = "01" then
                            CtlToRegs_port_dst_data        <= MemToCtl_port;
                        elsif wb_sel_signal = "10" then
                            CtlToRegs_port_dst_data        <= pc_reg_signal + 4;
                        end if;


                        CtlToRegs_data_signal_dst <= DecToCtl_data_signal_rd_addr;

                        CtlToRegs_port_dst  <= DecToCtl_data_signal_rd_addr;
                        CtlToRegs_port_req  <= '1';
                        CtlToRegs_port_src1 <= CtlToRegs_data_signal_src1;
                        CtlToRegs_port_src2 <= CtlToRegs_data_signal_src2;

                        CtlToRegs_port_notify <= '1';

                        section <= "1010";

                    else

                        memoryAccess_signal_mask   <= "100";
                        memoryAccess_signal_req    <= '0';

                        CtlToMem_port_addrIn <= pc_next_signal;
                        CtlToMem_port_dataIn <= (others => '0');
                        CtlToMem_port_mask   <= "100";
                        CtlToMem_port_req    <= '0';

                        CtlToMem_port_notify <= '1';

                        pc_reg_signal <= pc_next_signal;

                        section <= "0000"; 

                    end if;


                 end if;

              ------------------------------ Write Result back to Register-File ------------------------------
             elsif section = "1010" then


                 pc_reg_signal <= pc_next_signal;

                 memoryAccess_signal_mask   <= "100";
                 memoryAccess_signal_req    <= '0';

                 CtlToMem_port_addrIn <= pc_next_signal;
                 CtlToMem_port_dataIn <= (others => '0');
                 CtlToMem_port_mask   <= "100";
                 CtlToMem_port_req    <= '0';

                 CtlToRegs_port_notify <= '0';

                 CtlToMem_port_notify <= '1';

                 section <= "0000";

             end if; -- Section

         end if; -- Reset

     end if; -- Clock

     end process;

end Cpath_arch;






























