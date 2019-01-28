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
use work.SCAM_Model_types.all;

entity Cpath is
    port(    
        -- Clock
        clk                   : in  std_logic;

        -- Synchronous Reset
        rst                   : in  std_logic;

        -- Communication with ALU
        CtlToALU_port         : out CtlToALU_IF;
        CtlToALU_port_notify  : out bool;
        ALUtoCtl_port         : in  ALUtoCtl_IF;

        -- Communication with Register-File
        CtlToRegs_port        : out CtlToRegs_IF;
        CtlToRegs_port_notify : out bool;
        RegsToCtl_port        : in  RegsToCtl_IF;
         
        -- Communication with Decoder
        CtlToDec_port         : out Unsigned (31 downto 0);
        CtlToDec_port_notify  : out bool;
        DecToCtl_port         : in  DecodedInstr;

        -- Communication with Memory
        MemToCtl_port         : in  MEtoCU_IF;
        MemToCtl_port_sync    : in  bool;
        MemToCtl_port_notify  : out bool;
        CtlToMem_port         : out CUtoME_IF;
        CtlToMem_port_sync    : in  bool;
        CtlToMem_port_notify  : out bool
    );
end Cpath;


architecture Cpath_arch of Cpath is

    -- Signals
    signal section                        : Cpath_SECTIONS;
    signal ALUtoCtl_data_signal           : ALUtoCtl_IF;
    signal CtlToALU_data_signal_alu_fun   : ALUfuncType;
    signal CtlToALU_data_signal_op1_sel   : ALUopType;
    signal CtlToALU_data_signal_op2_sel   : ALUopType;
    signal CtlToRegs_data_signal_src1     : Unsigned (4 downto 0);
    signal CtlToRegs_data_signal_src2     : Unsigned (4 downto 0);
    signal RegsToCtl_data_signal          : RegsToCtl_IF;
    signal br_en_signal                   : bool;
    signal DecToCtl_data_signal_imm       : Unsigned (31 downto 0);
    signal DecToCtl_data_signal_instrType : InstrType;
    signal DecToCtl_data_signal_rd_addr   : Unsigned (4 downto 0);
    signal MemToCtl_data_signal           : Unsigned (31 downto 0);
    signal mem_en_signal                  : bool;
    signal memoryAccess_signal_mask       : ME_MaskType;
    signal memoryAccess_signal_req        : ME_AccessType;
    signal pc_next_signal                 : Unsigned (31 downto 0);
    signal pc_reg_signal                  : Unsigned (31 downto 0);
    signal reg_rd_en_signal               : bool;
    signal wb_en_signal                   : bool;
    signal wb_sel_signal                  : WBselType;

begin
    process(clk)

    variable reg_rd_en_signal_temp             : bool := false;
    variable CtlToALU_data_signal_op1_sel_temp : ALUopType;
    variable CtlToALU_data_signal_op2_sel_temp : ALUopType;
    variable CtlToALU_data_signal_alu_fun_temp : ALUfuncType;
    variable pc_sel_var                        : PCselType;
    variable pc_next_signal_temp               : Unsigned (31 downto 0);

    begin
    if(clk='1' and clk'event) then

         -- Reset Sequence
         if rst = '1' then

            section <= requestInstr;
            ALUtoCtl_data_signal.ALU_result <= (others => '0');
            CtlToALU_data_signal_alu_fun       <= ALU_ADD;
            CtlToALU_port.imm           <= (others => '0');
            CtlToALU_data_signal_op1_sel       <= OP_IMM;
            CtlToALU_data_signal_op2_sel       <= OP_IMM;
            CtlToALU_port.pc_reg        <= (others => '0');
            CtlToALU_port.reg1_contents <= (others => '0');
            CtlToALU_port.reg2_contents <= (others => '0');
	    CtlToDec_port <= (others => '0');
            CtlToRegs_port.dst <= (others => '0');
            CtlToRegs_port.dst_data <= (others => '0');
            CtlToRegs_port.req      <= REG_RD;
            CtlToRegs_data_signal_src1     <= (others => '0');
            CtlToRegs_data_signal_src2     <= (others => '0');
            RegsToCtl_data_signal.contents1 <= (others => '0');
            RegsToCtl_data_signal.contents2 <= (others => '0');
            br_en_signal <= false;
            DecToCtl_data_signal_imm       <= (others => '0');
            DecToCtl_data_signal_instrType <= INSTR_AND;
            DecToCtl_data_signal_rd_addr   <= (others => '0');
            MemToCtl_data_signal <= (others => '0');
            mem_en_signal <= false;
            memoryAccess_signal_mask   <= MT_W;
            memoryAccess_signal_req    <= ME_RD;
            pc_next_signal <= (others => '0');
            pc_reg_signal <= (others => '0');
            reg_rd_en_signal <= false;
            wb_en_signal <= false;
            wb_sel_signal <= WB_ALU;
            CtlToMem_port.addrIn <= (others => '0');
            CtlToMem_port.dataIn <= (others => '0');
            CtlToMem_port.mask   <= MT_W;
            CtlToMem_port.req    <= ME_RD;
            CtlToMem_port_notify <= true;
            MemToCtl_port_notify <= false;
            CtlToALU_port_notify <= false;
            CtlToRegs_port_notify <= false;
            CtlToDec_port_notify <= false;


         else

             ---------------------------------- Request Instruction from Memory ---------------------------------
             if section = requestInstr then

                if CtlToMem_port_sync = true then

                    CtlToMem_port_notify <= false;

                    MemToCtl_port_notify <= true;

                    section <= receiveInstr;   

                end if;

              ---------------------- Receive Instruction from Memory and pass it to Decoder ---------------------
             elsif section = receiveInstr then

                if MemToCtl_port_sync = true then

                    MemToCtl_port_notify <= false;
           
                    CtlToDec_port       <= MemToCtl_port.loadedData;

                    CtlToDec_port_notify <= true;

                    section <= decode;   

                end if;

              ---------------------------------------- Decode Instruction ---------------------------------------
             elsif section = decode then

                 CtlToDec_port_notify <= false;
         
                 section <= setControl;   



              --------------------------------------- Set Control Signals ---------------------------------------
             elsif section = setControl then
            

                 -- Set default values
                 reg_rd_en_signal_temp             := reg_rd_en_signal;
                 CtlToALU_data_signal_op1_sel_temp := CtlToALU_data_signal_op1_sel;
                 CtlToALU_data_signal_op2_sel_temp := CtlToALU_data_signal_op2_sel;
                 CtlToALU_data_signal_alu_fun_temp := CtlToALU_data_signal_alu_fun;

                 -- Read from Decoder
                 DecToCtl_data_signal_imm       <= DecToCtl_port.imm;
                 DecToCtl_data_signal_instrType <= DecToCtl_port.instrType;
                 DecToCtl_data_signal_rd_addr   <= DecToCtl_port.rd_addr;


                 -- I_I-Type Instruction
                 if DecToCtl_port.encType = ENC_I_I then

                     -- Common for Arithmetics
                     CtlToALU_data_signal_op1_sel <= OP_REG;
                     CtlToALU_data_signal_op2_sel <= OP_IMM;
                     wb_sel_signal <= WB_ALU;
                     wb_en_signal <= true;
                     reg_rd_en_signal <= true;
                     reg_rd_en_signal_temp := true;
                     mem_en_signal <= false;
                     br_en_signal <= false;

                     -- Set ALU-Function
                     if    DecToCtl_port.instrType = INSTR_ADDI  then
                         CtlToALU_data_signal_alu_fun <= ALU_ADD;
                     elsif DecToCtl_port.instrType = INSTR_SLTI  then
                         CtlToALU_data_signal_alu_fun <= ALU_SLT;
                     elsif DecToCtl_port.instrType = INSTR_SLTUI then
                         CtlToALU_data_signal_alu_fun <= ALU_SLTU;
                     elsif DecToCtl_port.instrType = INSTR_XORI  then
                         CtlToALU_data_signal_alu_fun <= ALU_XOR;
                     elsif DecToCtl_port.instrType = INSTR_ORI   then
                         CtlToALU_data_signal_alu_fun <= ALU_OR;
                     elsif DecToCtl_port.instrType = INSTR_ANDI  then
                         CtlToALU_data_signal_alu_fun <= ALU_AND;
                     elsif DecToCtl_port.instrType = INSTR_SLLI  then
                         CtlToALU_data_signal_alu_fun <= ALU_SLL;
                     elsif DecToCtl_port.instrType = INSTR_SRLI  then
                         CtlToALU_data_signal_alu_fun <= ALU_SRL;
                     elsif DecToCtl_port.instrType = INSTR_SRAI  then
                         CtlToALU_data_signal_alu_fun <= ALU_SRA;
                     end if;								

                 -- I_L-Type Instruction
                 elsif (DecToCtl_port.encType = ENC_I_L) then

                     -- Common for Loads
                     CtlToALU_data_signal_op1_sel <= OP_REG;
                     CtlToALU_data_signal_op2_sel <= OP_IMM;
                     CtlToALU_data_signal_alu_fun <= ALU_ADD;
                     wb_sel_signal <= WB_MEM;
                     wb_en_signal <= true;
                     reg_rd_en_signal <= true;
                     reg_rd_en_signal_temp := true;
                     mem_en_signal <= true;
                     br_en_signal <= false;
                     CtlToRegs_port.dst <= DecToCtl_port.rd_addr;

                     -- Set Memory Access
                     memoryAccess_signal_req <= ME_RD;

                     -- Set Memory Mask
                     if    DecToCtl_port.instrType = INSTR_LB  then
                         memoryAccess_signal_mask <= MT_B;
                     elsif DecToCtl_port.instrType = INSTR_LH  then
                         memoryAccess_signal_mask <= MT_H;
                     elsif DecToCtl_port.instrType = INSTR_LW  then
                         memoryAccess_signal_mask <= MT_W;
                     elsif DecToCtl_port.instrType = INSTR_LBU then
                         memoryAccess_signal_mask <= MT_BU;
                     elsif DecToCtl_port.instrType = INSTR_LHU then
                         memoryAccess_signal_mask <= MT_HU;
                     end if;

                 -- I_J-Type Instruction
                 elsif (DecToCtl_port.encType = ENC_I_J) then

                     CtlToALU_data_signal_op1_sel <= OP_X;  
                     CtlToALU_data_signal_op2_sel <= OP_X; 
                     CtlToALU_data_signal_alu_fun <= ALU_X;
                     wb_sel_signal <= WB_PC4;  
                     wb_en_signal <= true;
                     reg_rd_en_signal <= true;
                     reg_rd_en_signal_temp := true;
                     mem_en_signal <= false;
                     br_en_signal <= false;

                 -- R-Type Instruction
                 elsif DecToCtl_port.encType = ENC_R then

                     -- Common for all R-Types
                     CtlToALU_data_signal_op1_sel <= OP_REG;
                     CtlToALU_data_signal_op2_sel <= OP_REG;
                     wb_sel_signal <= WB_ALU;
                     wb_en_signal <= true;
                     reg_rd_en_signal <= true;
                     reg_rd_en_signal_temp := true;
                     mem_en_signal <= false;
                     br_en_signal <= false;

                     -- Set ALU-Function
                     if    DecToCtl_port.instrType = INSTR_ADD     then
                         CtlToALU_data_signal_alu_fun <= ALU_ADD;
                     elsif DecToCtl_port.instrType = INSTR_SUB     then
                         CtlToALU_data_signal_alu_fun <= ALU_SUB;
                     elsif DecToCtl_port.instrType = INSTR_SLL     then
                         CtlToALU_data_signal_alu_fun <= ALU_SLL;
                     elsif DecToCtl_port.instrType = INSTR_SLT     then
                         CtlToALU_data_signal_alu_fun <= ALU_SLT;
                     elsif DecToCtl_port.instrType = INSTR_SLTU    then
                         CtlToALU_data_signal_alu_fun <= ALU_SLTU;
                     elsif DecToCtl_port.instrType = INSTR_XOR     then
                         CtlToALU_data_signal_alu_fun <= ALU_XOR;
                     elsif DecToCtl_port.instrType = INSTR_SRL     then
                         CtlToALU_data_signal_alu_fun <= ALU_SRL;
                     elsif DecToCtl_port.instrType = INSTR_SRA     then
                         CtlToALU_data_signal_alu_fun <= ALU_SRA;
                     elsif DecToCtl_port.instrType = INSTR_OR      then
                         CtlToALU_data_signal_alu_fun <= ALU_OR;
                     elsif DecToCtl_port.instrType = INSTR_AND     then
                         CtlToALU_data_signal_alu_fun <= ALU_AND;
                     elsif DecToCtl_port.instrType = INSTR_UNKNOWN then				
                         CtlToALU_data_signal_alu_fun <= ALU_X;
                     end if;


                 -- B-Type Instruction
                 elsif DecToCtl_port.encType = ENC_B then

                     -- Common for all B-Types
                     CtlToALU_data_signal_op1_sel <= OP_REG;
                     CtlToALU_data_signal_op2_sel <= OP_REG;
                     wb_sel_signal <= WB_X;
                     wb_en_signal <= false;
                     reg_rd_en_signal <= true;
                     reg_rd_en_signal_temp := true;
                     mem_en_signal <= false;
                     br_en_signal <= true;

                     -- Set ALU-Function
                     if    DecToCtl_port.instrType = INSTR_BEQ  then
                         CtlToALU_data_signal_alu_fun <= ALU_SUB;
                     elsif DecToCtl_port.instrType = INSTR_BNE  then
                         CtlToALU_data_signal_alu_fun <= ALU_SUB;
                     elsif DecToCtl_port.instrType = INSTR_BLT  then
                         CtlToALU_data_signal_alu_fun <= ALU_SLT;
                     elsif DecToCtl_port.instrType = INSTR_BGE  then
                         CtlToALU_data_signal_alu_fun <= ALU_SLT;
                     elsif DecToCtl_port.instrType = INSTR_BLTU then
                         CtlToALU_data_signal_alu_fun <= ALU_SLTU;
                     elsif DecToCtl_port.instrType = INSTR_BGEU then
                         CtlToALU_data_signal_alu_fun <= ALU_SLTU;
		     else
			 CtlToALU_data_signal_alu_fun <= ALU_X;				
                     end if;


                 -- J-Type Instruction
                 elsif DecToCtl_port.encType = ENC_J then

                     -- JAL
                     if DecToCtl_port.instrType = INSTR_JAL then

                         CtlToALU_data_signal_op1_sel <= OP_X;
                         CtlToALU_data_signal_op1_sel_temp := OP_X;
                         CtlToALU_data_signal_op2_sel <= OP_X;
                         CtlToALU_data_signal_op2_sel_temp := OP_X;
                         CtlToALU_data_signal_alu_fun <= ALU_X;
                         CtlToALU_data_signal_alu_fun_temp := ALU_X;
                         wb_sel_signal <= WB_PC4;
                         wb_en_signal <= true;
                         reg_rd_en_signal <= false;
                         reg_rd_en_signal_temp := false;
                         mem_en_signal <= false;
                         br_en_signal <= false;

                     end if;


                 -- S-Type Instruction
                 elsif DecToCtl_port.encType = ENC_S then

                     -- Common for all S-Types
                     CtlToALU_data_signal_op1_sel <= OP_REG;
                     CtlToALU_data_signal_op2_sel <= OP_IMM;
                     CtlToALU_data_signal_alu_fun <= ALU_ADD;
                     wb_sel_signal <= WB_X;
                     wb_en_signal <= false;
                     reg_rd_en_signal <= true;
                     reg_rd_en_signal_temp := true;
                     mem_en_signal <= true;
                     br_en_signal <= false;

                     -- Set Memory Access
                     memoryAccess_signal_req <= ME_WR;

                     -- Set Memory Mask
                     if    DecToCtl_port.instrType = INSTR_SB then
                         memoryAccess_signal_mask <= MT_B;
                     elsif DecToCtl_port.instrType = INSTR_SH then
                         memoryAccess_signal_mask <= MT_H;
                     elsif DecToCtl_port.instrType = INSTR_SW then
                         memoryAccess_signal_mask <= MT_W;
		     else
			 memoryAccess_signal_mask <= MT_X;			
                     end if;


                 -- U-Type Instruction
                 elsif DecToCtl_port.encType = ENC_U then

                     -- Common for all U-Types
                     wb_sel_signal <= WB_ALU;
                     wb_en_signal <= true;
                     reg_rd_en_signal <= false;
                     reg_rd_en_signal_temp := false;
                     mem_en_signal <= false;
                     br_en_signal <= false;
                        
                     -- Set Operands and ALU-Function
                     if    DecToCtl_port.instrType = INSTR_LUI   then
                         CtlToALU_data_signal_op1_sel <= OP_IMM;
                         CtlToALU_data_signal_op1_sel_temp := OP_IMM;
                         CtlToALU_data_signal_op2_sel <= OP_X;
                         CtlToALU_data_signal_op2_sel_temp := OP_X;
                         CtlToALU_data_signal_alu_fun <= ALU_COPY1;
                         CtlToALU_data_signal_alu_fun_temp := ALU_COPY1;
                     elsif DecToCtl_port.instrType = INSTR_AUIPC then
                         CtlToALU_data_signal_op1_sel <= OP_PC;
                         CtlToALU_data_signal_op1_sel_temp := OP_PC;
                         CtlToALU_data_signal_op2_sel <= OP_IMM;
                         CtlToALU_data_signal_op2_sel_temp := OP_IMM;
                         CtlToALU_data_signal_alu_fun <= ALU_ADD;
                         CtlToALU_data_signal_alu_fun_temp := ALU_ADD;
                     end if;
                        
                 end if;
                
                    
                 -- Determine next State
		 -- ERROR-Type Instruction
                 if DecToCtl_port.encType = ENC_ERR then				

                    CtlToMem_port.addrIn <= pc_reg_signal;
                    CtlToMem_port.dataIn <= (others => '0');
                    CtlToMem_port.mask   <= MT_W;
                    CtlToMem_port.req    <= ME_RD;

                    CtlToMem_port_notify <= true;
		    section <= requestInstr; 

		 elsif DecToCtl_port.instrType = INSTR_JAL then					
									
		    section <= evaluateALUresult;


                 elsif reg_rd_en_signal_temp = true then

                     -- Read Registers
                     CtlToRegs_data_signal_src1 <= DecToCtl_port.rs1_addr;
                     CtlToRegs_data_signal_src2 <= DecToCtl_port.rs2_addr;

                     CtlToRegs_port.req      <= REG_RD;
                     CtlToRegs_port.src1     <= DecToCtl_port.rs1_addr;
                     CtlToRegs_port.src2     <= DecToCtl_port.rs2_addr;

                     CtlToRegs_port_notify <= true;

                     section <= readRegisterFile; 

                 else

                     CtlToALU_port.alu_fun       <= CtlToALU_data_signal_alu_fun_temp;
                     CtlToALU_port.imm           <= DecToCtl_port.imm;
                     CtlToALU_port.op1_sel       <= CtlToALU_data_signal_op1_sel_temp;
                     CtlToALU_port.op2_sel       <= CtlToALU_data_signal_op2_sel_temp;
                     CtlToALU_port.pc_reg        <= pc_reg_signal;
                     CtlToALU_port.reg1_contents <= RegsToCtl_data_signal.contents1;
                     CtlToALU_port.reg2_contents <= RegsToCtl_data_signal.contents2;       

                     CtlToALU_port_notify <= true;

                     section <= executeALU; 

                 end if;

                      
 
              --------------------------------------- Read Register-File  ---------------------------------------
             elsif section = readRegisterFile then
                                      
                    CtlToRegs_port_notify <= false;       

                    section <= requestALU; 



              --------------------- Receive Register-File contents and request ALU-Operation --------------------
             elsif section = requestALU then

                 -- Receive contents from Register-File
                 RegsToCtl_data_signal <= RegsToCtl_port;
                 
                 if DecToCtl_port.instrType = INSTR_JALR then				

		    section <= evaluateALUresult;

		 else

                    -- Write Data to ALU
                    CtlToALU_port.alu_fun       <= CtlToALU_data_signal_alu_fun;
                    CtlToALU_port.imm           <= DecToCtl_data_signal_imm;
                    CtlToALU_port.op1_sel       <= CtlToALU_data_signal_op1_sel;
                    CtlToALU_port.op2_sel       <= CtlToALU_data_signal_op2_sel;
                    CtlToALU_port.reg1_contents <= RegsToCtl_port.contents1;
                    CtlToALU_port.reg2_contents <= RegsToCtl_port.contents2;
                    CtlToALU_port.pc_reg        <= pc_reg_signal;

                    CtlToALU_port_notify <= true;

                    section <= executeALU;

		 end if; 

              -------------------------------------- Execute ALU-Operation --------------------------------------
             elsif section = executeALU then

                 CtlToALU_port_notify <= false;
          
                 section <= evaluateALUresult; 


              --------------------------------- Receive and evaluate ALU-Result ---------------------------------
             elsif section = evaluateALUresult then


                 -- Read ALU-Result
                 ALUtoCtl_data_signal <= ALUtoCtl_port;                  

                 -- Default
                 pc_sel_var := PC_4;

                 -- Branches
                 if br_en_signal = true then
                     if    (DecToCtl_data_signal_instrType = INSTR_BEQ  and ALUtoCtl_port.ALU_result  = 0) then
                         pc_sel_var := PC_BR;
                     elsif (DecToCtl_data_signal_instrType = INSTR_BNE  and not (ALUtoCtl_port.ALU_result = 0)) then
                         pc_sel_var := PC_BR;
                     elsif (DecToCtl_data_signal_instrType = INSTR_BLT  and ALUtoCtl_port.ALU_result  = 1) then
                         pc_sel_var := PC_BR;
                     elsif (DecToCtl_data_signal_instrType = INSTR_BGE  and ALUtoCtl_port.ALU_result  = 0) then
                         pc_sel_var := PC_BR;
                     elsif (DecToCtl_data_signal_instrType = INSTR_BLTU and ALUtoCtl_port.ALU_result  = 1) then
                         pc_sel_var := PC_BR;
                     elsif (DecToCtl_data_signal_instrType = INSTR_BGEU and ALUtoCtl_port.ALU_result  = 0) then
                         pc_sel_var := PC_BR;
                     end if;
                 end if;

                 -- Jumps
                 if    DecToCtl_data_signal_instrType = INSTR_JAL  then
                     pc_sel_var := PC_J;
                 elsif DecToCtl_data_signal_instrType = INSTR_JALR then
                     pc_sel_var := PC_JR;
                 end if;

                 -- Calculate new PC-Value
                 if    pc_sel_var = PC_4   then
                     pc_next_signal_temp := pc_reg_signal + 4;
                 elsif pc_sel_var = PC_BR  then
                     pc_next_signal_temp := pc_reg_signal + DecToCtl_data_signal_imm;
                 elsif pc_sel_var = PC_J   then
                     pc_next_signal_temp := pc_reg_signal + DecToCtl_data_signal_imm;
                 elsif pc_sel_var = PC_JR  then
                     pc_next_signal_temp := RegsToCtl_data_signal.contents1 + DecToCtl_data_signal_imm;
                 end if;

                 pc_next_signal <= pc_next_signal_temp;
             
                 -- Memory Access is required
                 if mem_en_signal = true then

                     CtlToMem_port.addrIn <= ALUtoCtl_port.ALU_result;
		     if memoryAccess_signal_req = ME_WR then
                        CtlToMem_port.dataIn <= RegsToCtl_data_signal.contents2;
		     elsif memoryAccess_signal_req = ME_RD then
                        CtlToMem_port.dataIn <= (others => '0');				
		     end if;
                     CtlToMem_port.mask   <= memoryAccess_signal_mask;
                     CtlToMem_port.req    <= memoryAccess_signal_req;

                     CtlToMem_port_notify <= true;

                     section <= writeMemory;

                 -- Writeback is required
                 elsif (wb_en_signal = true) then

                     if    wb_sel_signal = WB_ALU then
                         CtlToRegs_port.dst_data        <= ALUtoCtl_port.ALU_result;
                     elsif wb_sel_signal = WB_MEM then
                         CtlToRegs_port.dst_data        <= MemToCtl_data_signal;
                     elsif wb_sel_signal = WB_PC4 then
                         CtlToRegs_port.dst_data        <= pc_reg_signal + 4;
                     end if;


                     -- Write to Registers
                     CtlToRegs_port.dst  <= DecToCtl_data_signal_rd_addr;
                     CtlToRegs_port.req  <= REG_WR;
                     CtlToRegs_port.src1 <= CtlToRegs_data_signal_src1;
                     CtlToRegs_port.src2 <= CtlToRegs_data_signal_src2;

                     CtlToRegs_port_notify <= true;
           
                     section <= writeBack;

                 -- Instruction finished -> Send request to Memory for next instruction
                 else 

                     memoryAccess_signal_mask   <= MT_W;
                     memoryAccess_signal_req    <= ME_RD;

                     CtlToMem_port.addrIn <= pc_next_signal_temp;
                     CtlToMem_port.dataIn <= (others => '0');
                     CtlToMem_port.mask   <= MT_W;
                     CtlToMem_port.req    <= ME_RD;

                     CtlToMem_port_notify <= true;

                     pc_reg_signal <= pc_next_signal_temp;

                     section <= requestInstr;

                 end if; 



              ------------------------------ Write Data to Memory (STORE and LOAD) ------------------------------
             elsif section = writeMemory then

                 if CtlToMem_port_sync = true then

                    CtlToMem_port_notify <= false;

                    MemToCtl_port_notify <= true; 
             
                    section <= readMemory; 
 
                 end if;


              ------------------------------ Receive and evaluate Data from Memory ------------------------------
             elsif section = readMemory then

                 if MemToCtl_port_sync = true then
                 
                    MemToCtl_data_signal <= MemToCtl_port.loadedData;

                    MemToCtl_port_notify <= false; 
             
                    if (wb_en_signal = true) then

                        if    wb_sel_signal = WB_ALU then
                            CtlToRegs_port.dst_data        <= ALUtoCtl_data_signal.ALU_result;
                        elsif wb_sel_signal = WB_MEM then
                            CtlToRegs_port.dst_data        <= MemToCtl_port.loadedData;
                        elsif wb_sel_signal = WB_PC4 then
                            CtlToRegs_port.dst_data        <= pc_reg_signal + 4;
                        end if;


                        CtlToRegs_port.dst  <= DecToCtl_data_signal_rd_addr;
                        CtlToRegs_port.req  <= REG_WR;
                        CtlToRegs_port.src1 <= CtlToRegs_data_signal_src1;
                        CtlToRegs_port.src2 <= CtlToRegs_data_signal_src2;

                        CtlToRegs_port_notify <= true;

                        section <= writeBack;

                    else

                        memoryAccess_signal_mask   <= MT_W;
                        memoryAccess_signal_req    <= ME_RD;

                        CtlToMem_port.addrIn <= pc_next_signal;
                        CtlToMem_port.dataIn <= (others => '0');
                        CtlToMem_port.mask   <= MT_W;
                        CtlToMem_port.req    <= ME_RD;

                        CtlToMem_port_notify <= true;

                        pc_reg_signal <= pc_next_signal;

                        section <= requestInstr; 

                    end if;


                 end if;

              ------------------------------ Write Result back to Register-File ------------------------------
             elsif section = writeBack then


                 pc_reg_signal <= pc_next_signal;

                 memoryAccess_signal_mask   <= MT_W;
                 memoryAccess_signal_req    <= ME_RD;

                 CtlToMem_port.addrIn <= pc_next_signal;
                 CtlToMem_port.dataIn <= (others => '0');
                 CtlToMem_port.mask   <= MT_W;
                 CtlToMem_port.req    <= ME_RD;

                 CtlToRegs_port_notify <= false;

                 CtlToMem_port_notify <= true;

                 section <= requestInstr;

             end if; -- Section

         end if; -- Reset

     end if; -- Clock

     end process;

end Cpath_arch;






























