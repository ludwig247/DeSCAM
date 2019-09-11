--
-- Created by deutschmann on 22.01.18
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use work.SCAM_Model_types.all;

entity Cpath is
port(    
    clk                   : in  std_logic;
    rst                   : in  std_logic;
    ALUtoCtl_port         : in  ALUtoCtl_IF;
    ALUtoCtl_port_sync    : in  bool;
    ALUtoCtl_port_notify  : out bool;
    CtlToALU_port         : out CtlToALU_IF;
    CtlToALU_port_sync    : in  bool;
    CtlToALU_port_notify  : out bool;
    CtlToRegs_port        : out CtlToRegs_IF;
    CtlToRegs_port_sync   : in  bool;
    CtlToRegs_port_notify : out bool;
    RegsToCtl_port        : in  RegsToCtl_IF;
    RegsToCtl_port_sync   : in  bool;
    RegsToCtl_port_notify : out bool;
    DecToCtl_port         : in  DecodedInstr;
    DecToCtl_port_sync    : in  bool;
    DecToCtl_port_notify  : out bool;
    MemToCtl_port         : in  Unsigned (31 downto 0);
    MemToCtl_port_sync    : in  bool;
    MemToCtl_port_notify  : out bool;
    CtlToMem_port         : out MemoryAccess;
    CtlToMem_port_sync    : in  bool;
    CtlToMem_port_notify  : out bool);
end Cpath;


architecture Cpath_arch of Cpath is

    -- Signals
    signal section                : Cpath_SECTIONS;
    signal ALUtoCtl_data_signal   : ALUtoCtl_IF;
    signal CtlToALU_data_signal   : CtlToALU_IF;
    signal CtlToRegs_data_signal  : CtlToRegs_IF;
    signal RegsToCtl_data_signal  : RegsToCtl_IF;
    signal br_en_signal           : bool;
    signal decodedInstr_signal    : DecodedInstr;
    signal MemToCtl_data_signal : Unsigned (31 downto 0);
    signal mem_en_signal          : bool;
    signal memoryAccess_signal    : MemoryAccess;
    signal pc_next_signal         : Unsigned (31 downto 0);
    signal pc_reg_signal          : Unsigned (31 downto 0);
    signal pc_sel_signal          : PCselType;
    signal reg_rd_en_signal       : bool;
    signal wb_data_signal         : Unsigned (31 downto 0);
    signal wb_en_signal           : bool;
    signal wb_sel_signal          : WBselType;

begin
    process(clk)

    variable reg_rd_en_signal_temp : bool := false;
    variable CtlToALU_data_signal_op1_sel_temp : ALUopType;
    variable CtlToALU_data_signal_op2_sel_temp : ALUopType;
    variable CtlToALU_data_signal_alu_fun_temp : ALU_function;
    variable pc_sel_signal_temp                : PCselType;
    variable pc_next_signal_temp               : Unsigned (31 downto 0);

    begin
    if(clk='1' and clk'event) then

         if rst = '1' then

            section <= fetchAndDecode0;
            ALUtoCtl_data_signal.ALU_result <= (others => '0');
            CtlToALU_data_signal.alu_fun       <= ALU_ADD;
            CtlToALU_data_signal.imm           <= (others => '0');
            CtlToALU_data_signal.op1_sel       <= OP_IMM;
            CtlToALU_data_signal.op2_sel       <= OP_IMM;
            CtlToALU_data_signal.pc_reg        <= (others => '0');
            CtlToALU_data_signal.reg1_contents <= (others => '0');
            CtlToALU_data_signal.reg2_contents <= (others => '0');
            CtlToRegs_data_signal.dst      <= (others => '0');
            CtlToRegs_data_signal.dst_data <= (others => '0');
            CtlToRegs_data_signal.req      <= REG_RD;
            CtlToRegs_data_signal.src1     <= (others => '0');
            CtlToRegs_data_signal.src2     <= (others => '0');
            RegsToCtl_data_signal.contents1 <= (others => '0');
            RegsToCtl_data_signal.contents2 <= (others => '0');
            br_en_signal <= false;
            decodedInstr_signal.encType   <= B;
            decodedInstr_signal.imm       <= (others => '0');
            decodedInstr_signal.instrType <= And_Instr;
            decodedInstr_signal.rd_addr   <= (others => '0');
            decodedInstr_signal.rs1_addr  <= (others => '0');
            decodedInstr_signal.rs2_addr  <= (others => '0');
            MemToCtl_data_signal <= (others => '0');
            mem_en_signal <= false;
            memoryAccess_signal.addrIn <= (others => '0');
            memoryAccess_signal.dataIn <= (others => '0');
            memoryAccess_signal.mask   <= MT_W;
            memoryAccess_signal.req    <= MEM_RD_I;
            pc_next_signal <= (others => '0');
            pc_reg_signal <= (others => '0');
            pc_sel_signal <= PC_4;
            reg_rd_en_signal <= false;
            wb_data_signal <= (others => '0');
            wb_en_signal <= false;
            wb_sel_signal <= WB_ALU;
            ALUtoCtl_port_notify <= false;
            CtlToALU_port_notify <= false;
            CtlToRegs_port_notify <= false;
            RegsToCtl_port_notify <= false;
            DecToCtl_port_notify <= false;
            MemToCtl_port_notify <= false;
            CtlToMem_port.addrIn <= (others => '0');
            CtlToMem_port.dataIn <= (others => '0');
            CtlToMem_port.mask   <= MT_W;
            CtlToMem_port.req    <= MEM_RD_I;
            CtlToMem_port_notify <= true;

         else

             ---------------------------------------------------------------------------------------------------
             if section = fetchAndDecode0 then

                if CtlToMem_port_sync = true then

                    CtlToMem_port_notify <= false;

                    DecToCtl_port_notify <= true;

                    section <= fetchAndDecode1;   

                 else 

                    CtlToMem_port.addrIn <= MemoryAccess_signal.addrIn;
                    CtlToMem_port.dataIn <= MemoryAccess_signal.dataIn;
                    CtlToMem_port.mask   <= MemoryAccess_signal.mask;		
                    CtlToMem_port.req    <= MemoryAccess_signal.req;

                end if;


             ---------------------------------------------------------------------------------------------------
             elsif section = fetchAndDecode1 then
            
                if DecToCtl_port_sync = true then

                    reg_rd_en_signal_temp             := reg_rd_en_signal;
                    CtlToALU_data_signal_op1_sel_temp := CtlToALU_data_signal.op1_sel;
                    CtlToALU_data_signal_op2_sel_temp := CtlToALU_data_signal.op2_sel;
                    CtlToALU_data_signal_alu_fun_temp := CtlToALU_data_signal.alu_fun;

                    -- Read from Decoder
                    decodedInstr_signal <= DecToCtl_port;

                    DecToCtl_port_notify <= false;

                    -- I-Type Instruction
                    if DecToCtl_port.encType = I then

                        -- Arithmetics
                        if (DecToCtl_port.instrType = addI  or DecToCtl_port.instrType = sltI or
                            DecToCtl_port.instrType = sltIu or DecToCtl_port.instrType = xorI or
                            DecToCtl_port.instrType = orI   or DecToCtl_port.instrType = andI or
                            DecToCtl_port.instrType = sllI  or DecToCtl_port.instrType = srli or
                            DecToCtl_port.instrType = sraI) then

                            -- Common for Arithmetics
                            CtlToALU_data_signal.op1_sel <= OP_REG;
                            CtlToALU_data_signal.op2_sel <= OP_IMM;
                            wb_sel_signal <= WB_ALU;
                            wb_en_signal <= true;
                            reg_rd_en_signal <= true;
                            reg_rd_en_signal_temp := true;
                            mem_en_signal <= false;
                            br_en_signal <= false;

                            -- Set ALU-Function
                            if    DecToCtl_port.instrType = addI  then
                                CtlToALU_data_signal.alu_fun <= ALU_ADD;
                            elsif DecToCtl_port.instrType = sltI  then
                                CtlToALU_data_signal.alu_fun <= ALU_SLT;
                            elsif DecToCtl_port.instrType = sltIu then
                                CtlToALU_data_signal.alu_fun <= ALU_SLTU;
                            elsif DecToCtl_port.instrType = xorI  then
                                CtlToALU_data_signal.alu_fun <= ALU_XOR;
                            elsif DecToCtl_port.instrType = orI   then
                                CtlToALU_data_signal.alu_fun <= ALU_OR;
                            elsif DecToCtl_port.instrType = andI  then
                                CtlToALU_data_signal.alu_fun <= ALU_AND;
                            elsif DecToCtl_port.instrType = sllI  then
                                CtlToALU_data_signal.alu_fun <= ALU_SLL;
                            elsif DecToCtl_port.instrType = srlI  then
                                CtlToALU_data_signal.alu_fun <= ALU_SRL;
                            elsif DecToCtl_port.instrType = sraI  then
                                CtlToALU_data_signal.alu_fun <= ALU_SRA;
                            end if;

                        -- Loads
                        elsif (DecToCtl_port.instrType = lb or DecToCtl_port.instrType = lh  or
                               DecToCtl_port.instrType = lw or DecToCtl_port.instrType = lbu or
                               DecToCtl_port.instrType = lhu) then

                            -- Common for Loads
                            CtlToALU_data_signal.op1_sel <= OP_REG;
                            CtlToALU_data_signal.op2_sel <= OP_IMM;
                            CtlToALU_data_signal.alu_fun <= ALU_ADD;
                            wb_sel_signal <= WB_MEM;
                            wb_en_signal <= true;
                            reg_rd_en_signal <= true;
                            reg_rd_en_signal_temp := true;
                            mem_en_signal <= true;
                            br_en_signal <= false;

                            -- Set Memory Access
                            memoryAccess_signal.req <= MEM_LOAD;

                            -- Set Memory Mask
                            if    DecToCtl_port.instrType = lb  then
                                memoryAccess_signal.mask <= MT_B;
                            elsif DecToCtl_port.instrType = lh  then
                                memoryAccess_signal.mask <= MT_H;
                            elsif DecToCtl_port.instrType = lw  then
                                memoryAccess_signal.mask <= MT_W;
                            elsif DecToCtl_port.instrType = lbu then
                                memoryAccess_signal.mask <= MT_BU;
                            elsif DecToCtl_port.instrType = lhu then
                                memoryAccess_signal.mask <= MT_HU;
                            end if;

                        -- JALR
                        elsif DecToCtl_port.instrType = jalr then

                            CtlToALU_data_signal.op1_sel <= OP_X;  
                            CtlToALU_data_signal.op2_sel <= OP_X; 
                            CtlToALU_data_signal.alu_fun <= ALU_X;
                            wb_sel_signal <= WB_PC4;  
                            wb_en_signal <= true;
                            reg_rd_en_signal <= true;
                            reg_rd_en_signal_temp := true;
                            mem_en_signal <= false;
                            br_en_signal <= false;
                
                        end if;


                    -- R-Type Instruction
                    elsif DecToCtl_port.encType = R then

                        -- Common for all R-Types
                        CtlToALU_data_signal.op1_sel <= OP_REG;
                        CtlToALU_data_signal.op2_sel <= OP_REG;
                        wb_sel_signal <= WB_ALU;
                        wb_en_signal <= true;
                        reg_rd_en_signal <= true;
                        reg_rd_en_signal_temp := true;
                        mem_en_signal <= false;
                        br_en_signal <= false;

                        -- Set ALU-Function
                        if    DecToCtl_port.instrType = add       then
                            CtlToALU_data_signal.alu_fun <= ALU_ADD;
                        elsif DecToCtl_port.instrType = sub       then
                            CtlToALU_data_signal.alu_fun <= ALU_SUB;
                        elsif DecToCtl_port.instrType = sll_Instr then
                            CtlToALU_data_signal.alu_fun <= ALU_SLL;
                        elsif DecToCtl_port.instrType = slt       then
                            CtlToALU_data_signal.alu_fun <= ALU_SLT;
                        elsif DecToCtl_port.instrType = sltu      then
                            CtlToALU_data_signal.alu_fun <= ALU_SLTU;
                        elsif DecToCtl_port.instrType = Xor_Instr then
                            CtlToALU_data_signal.alu_fun <= ALU_XOR;
                        elsif DecToCtl_port.instrType = srl_Instr then
                            CtlToALU_data_signal.alu_fun <= ALU_SRL;
                        elsif DecToCtl_port.instrType = sra_Instr then
                            CtlToALU_data_signal.alu_fun <= ALU_SRA;
                        elsif DecToCtl_port.instrType = Or_Instr  then
                            CtlToALU_data_signal.alu_fun <= ALU_OR;
                        elsif DecToCtl_port.instrType = And_Instr then
                            CtlToALU_data_signal.alu_fun <= ALU_AND;
                        end if;


                    -- B-Type Instruction
                    elsif DecToCtl_port.encType = B then

                        -- Common for all B-Types
                        CtlToALU_data_signal.op1_sel <= OP_REG;
                        CtlToALU_data_signal.op2_sel <= OP_REG;
                        wb_sel_signal <= WB_X;
                        wb_en_signal <= false;
                        reg_rd_en_signal <= true;
                        reg_rd_en_signal_temp := true;
                        mem_en_signal <= false;
                        br_en_signal <= true;

                        -- Set ALU-Function
                        if    DecToCtl_port.instrType = beq  then
                            CtlToALU_data_signal.alu_fun <= ALU_SUB;
                        elsif DecToCtl_port.instrType = bne  then
                            CtlToALU_data_signal.alu_fun <= ALU_SUB;
                        elsif DecToCtl_port.instrType = blt  then
                            CtlToALU_data_signal.alu_fun <= ALU_SLT;
                        elsif DecToCtl_port.instrType = bge  then
                            CtlToALU_data_signal.alu_fun <= ALU_SLT;
                        elsif DecToCtl_port.instrType = bltu then
                            CtlToALU_data_signal.alu_fun <= ALU_SLTU;
                        elsif DecToCtl_port.instrType = bgeu then
                            CtlToALU_data_signal.alu_fun <= ALU_SLTU;
                        end if;


                    -- J-Type Instruction
                    elsif DecToCtl_port.encType = J then

                        -- JAL
                        if DecToCtl_port.instrType = jal then

                            CtlToALU_data_signal.op1_sel <= OP_X;
                            CtlToALU_data_signal_op1_sel_temp := OP_X;
                            CtlToALU_data_signal.op2_sel <= OP_X;
                            CtlToALU_data_signal_op2_sel_temp := OP_X;
                            CtlToALU_data_signal.alu_fun <= ALU_X;
                            CtlToALU_data_signal_alu_fun_temp := ALU_X;
                            wb_sel_signal <= WB_PC4;
                            wb_en_signal <= true;
                            reg_rd_en_signal <= false;
                            reg_rd_en_signal_temp := false;
                            mem_en_signal <= false;
                            br_en_signal <= false;

                        end if;


                    -- S-Type Instruction
                    elsif DecToCtl_port.encType = S then

                        -- Common for all S-Types
                        CtlToALU_data_signal.op1_sel <= OP_REG;
                        CtlToALU_data_signal.op2_sel <= OP_IMM;
                        CtlToALU_data_signal.alu_fun <= ALU_ADD;
                        wb_sel_signal <= WB_X;
                        wb_en_signal <= false;
                        reg_rd_en_signal <= true;
                        reg_rd_en_signal_temp := true;
                        mem_en_signal <= true;
                        br_en_signal <= false;

                        -- Set Memory Access
                        memoryAccess_signal.req <= MEM_STORE;

                        -- Set Memory Mask
                        if    DecToCtl_port.instrType = sb then
                            memoryAccess_signal.mask <= MT_B;
                        elsif DecToCtl_port.instrType = sh then
                            memoryAccess_signal.mask <= MT_H;
                        elsif DecToCtl_port.instrType = sw then
                            memoryAccess_signal.mask <= MT_W;
                        end if;


                    -- U-Type Instruction
                    elsif DecToCtl_port.encType = U then

                        -- Common for all U-Types

                        wb_sel_signal <= WB_ALU;
                        wb_en_signal <= true;
                        reg_rd_en_signal <= false;
                        reg_rd_en_signal_temp := false;
                        mem_en_signal <= false;
                        br_en_signal <= false;
                        
                        -- Set Operands and ALU-Function
                        if    DecToCtl_port.instrType = lui   then
                            CtlToALU_data_signal.op1_sel <= OP_IMM;
                            CtlToALU_data_signal_op1_sel_temp := OP_IMM;
                            CtlToALU_data_signal.op2_sel <= OP_X;
                            CtlToALU_data_signal_op2_sel_temp := OP_X;
                            CtlToALU_data_signal.alu_fun <= ALU_COPY1;
                            CtlToALU_data_signal_alu_fun_temp := ALU_COPY1;
                        elsif DecToCtl_port.instrType = auipc then
                            CtlToALU_data_signal.op1_sel <= OP_PC;
                            CtlToALU_data_signal_op1_sel_temp := OP_PC;
                            CtlToALU_data_signal.op2_sel <= OP_IMM;
                            CtlToALU_data_signal_op2_sel_temp := OP_IMM;
                            CtlToALU_data_signal.alu_fun <= ALU_ADD;
                            CtlToALU_data_signal_alu_fun_temp := ALU_ADD;
                        end if;

                    end if;
                
                    
                    -- Determine next State
                    if reg_rd_en_signal_temp = true then

                        -- Read Registers
                        CtlToRegs_data_signal.src1 <= DecToCtl_port.rs1_addr;
                        CtlToRegs_data_signal.src2 <= DecToCtl_port.rs2_addr;
                        CtlToRegs_data_signal.req  <= REG_RD;

                        CtlToRegs_port.dst      <= CtlToRegs_data_signal.dst;
                        CtlToRegs_port.dst_data <= CtlToRegs_data_signal.dst_data;
                        CtlToRegs_port.req      <= REG_RD;
                        CtlToRegs_port.src1     <= DecToCtl_port.rs1_addr;
                        CtlToRegs_port.src2     <= DecToCtl_port.rs2_addr;

                        CtlToRegs_port_notify <= true;

                        section <= readRegisterFile0; 

                    else

                        -- Write to ALU
                        CtlToALU_data_signal.imm    <= DecToCtl_port.imm;
                        CtlToALU_data_signal.pc_reg <= pc_reg_signal;
                        CtlToALU_data_signal.reg1_contents <= RegsToCtl_data_signal.contents1;
                        CtlToALU_data_signal.reg2_contents <= RegsToCtl_data_signal.contents2;

                        CtlToALU_port.alu_fun       <= CtlToALU_data_signal_alu_fun_temp;
                        CtlToALU_port.imm           <= DecToCtl_port.imm;
                        CtlToALU_port.op1_sel       <= CtlToALU_data_signal_op1_sel_temp;
                        CtlToALU_port.op2_sel       <= CtlToALU_data_signal_op2_sel_temp;
                        CtlToALU_port.pc_reg        <= pc_reg_signal;
                        CtlToALU_port.reg1_contents <= RegsToCtl_data_signal.contents1;
                        CtlToALU_port.reg2_contents <= RegsToCtl_data_signal.contents2;       

                        CtlToALU_port_notify <= true;

                        section <= executeALU0; 

                    end if;

                      
 
                end if;


             ---------------------------------------------------------------------------------------------------
             elsif section = readRegisterFile0 then
                 
                 if CtlToRegs_port_sync = true then
                     
                    CtlToRegs_port_notify <= false;

                    RegsToCtl_port_notify <= true;         

                    section <= readRegisterFile1; 

                 end if;


             ---------------------------------------------------------------------------------------------------
             elsif section = readRegisterFile1 then

                 if RegsToCtl_port_sync = true then

                    RegsToCtl_data_signal.contents1          <= RegsToCtl_port.contents1;
                    RegsToCtl_data_signal.contents2          <= RegsToCtl_port.contents2;


                    CtlToALU_data_signal.imm           <= decodedInstr_signal.imm;
                    CtlToALU_data_signal.reg1_contents <= RegsToCtl_port.contents1;
                    CtlToALU_data_signal.reg2_contents <= RegsToCtl_port.contents2;
                    CtlToALU_data_signal.pc_reg        <= pc_reg_signal;
                     
                    CtlToALU_port.alu_fun       <= CtlToALU_data_signal.alu_fun;
                    CtlToALU_port.imm           <= decodedInstr_signal.imm;
                    CtlToALU_port.op1_sel       <= CtlToALU_data_signal.op1_sel;
                    CtlToALU_port.op2_sel       <= CtlToALU_data_signal.op2_sel;
                    CtlToALU_port.reg1_contents <= RegsToCtl_port.contents1;
                    CtlToALU_port.reg2_contents <= RegsToCtl_port.contents2;
                    CtlToALU_port.pc_reg        <= pc_reg_signal;

                    RegsToCtl_port_notify <= false; 

                    CtlToALU_port_notify <= true;
                  
                    section <= executeALU0; 


                 end if;


             ---------------------------------------------------------------------------------------------------
             elsif section = executeALU0 then

                 if CtlToALU_port_sync = true then


                    CtlToALU_port_notify <= false;

                    ALUtoCtl_port_notify <= true; 
             
                    section <= executeALU1; 

                 else 
                    
                    CtlToALU_port.alu_fun       <= CtlToALU_data_signal.alu_fun;
                    CtlToALU_port.imm           <= CtlToALU_data_signal.imm;
                    CtlToALU_port.op1_sel       <= CtlToALU_data_signal.op1_sel;
                    CtlToALU_port.op2_sel       <= CtlToALU_data_signal.op2_sel;
                    CtlToALU_port.reg1_contents <= CtlToALU_data_signal.reg1_contents;
                    CtlToALU_port.reg2_contents <= CtlToALU_data_signal.reg2_contents;
                    CtlToALU_port.pc_reg        <= CtlToALU_data_signal.pc_reg;


                 end if;



             ---------------------------------------------------------------------------------------------------
             elsif section = executeALU1 then

                 if ALUtoCtl_port_sync = true then

                    -- Read ALU-Result
                    ALUtoCtl_data_signal.ALU_result          <= ALUtoCtl_port.ALU_result;                  

                    ALUtoCtl_port_notify <= false;

                    -- Default
                    pc_sel_signal_temp := PC_4;

                    -- Branches
                    if br_en_signal = true then
                        if    (decodedInstr_signal.instrType = beq  and ALUtoCtl_port.ALU_result  = 0) then
                            pc_sel_signal_temp := PC_BR;
                        elsif (decodedInstr_signal.instrType = bne  and not (ALUtoCtl_port.ALU_result = 0)) then
                            pc_sel_signal_temp := PC_BR;
                        elsif (decodedInstr_signal.instrType = blt  and ALUtoCtl_port.ALU_result  = 1) then
                            pc_sel_signal_temp := PC_BR;
                        elsif (decodedInstr_signal.instrType = bge  and ALUtoCtl_port.ALU_result  = 0) then
                            pc_sel_signal_temp := PC_BR;
                        elsif (decodedInstr_signal.instrType = bltu and ALUtoCtl_port.ALU_result  = 1) then
                            pc_sel_signal_temp := PC_BR;
                        elsif (decodedInstr_signal.instrType = bgeu and ALUtoCtl_port.ALU_result  = 0) then
                            pc_sel_signal_temp := PC_BR;
                        end if;
                    end if;

                    -- Jumps
                    if    decodedInstr_signal.instrType = jal  then
                        pc_sel_signal_temp := PC_J;
                    elsif decodedInstr_signal.instrType = jalr then
                        pc_sel_signal_temp := PC_JR;
                    end if;

                    -- Calculate new PC-Value
                    pc_sel_signal <= pc_sel_signal_temp;
                    if    pc_sel_signal_temp = PC_4   then
                        pc_next_signal_temp := pc_reg_signal + 4;
                    elsif pc_sel_signal_temp = PC_BR  then
                        pc_next_signal_temp := pc_reg_signal + decodedInstr_signal.imm;
                    elsif pc_sel_signal_temp = PC_J   then
                        pc_next_signal_temp := pc_reg_signal + decodedInstr_signal.imm;
                    elsif pc_sel_signal_temp = PC_JR  then
                        pc_next_signal_temp := RegsToCtl_data_signal.contents1 + decodedInstr_signal.imm;
                    end if;

                    pc_next_signal <= pc_next_signal_temp;
             
                    if mem_en_signal = true then
                        memoryAccess_signal.addrIn <= ALUtoCtl_port.ALU_result;
                        memoryAccess_signal.dataIn <= RegsToCtl_data_signal.contents2;

                        CtlToMem_port.addrIn <= ALUtoCtl_port.ALU_result;
                        CtlToMem_port.dataIn <= RegsToCtl_data_signal.contents2;
                        CtlToMem_port.mask   <= memoryAccess_signal.mask;
                        CtlToMem_port.req    <= memoryAccess_signal.req;

                        CtlToMem_port_notify <= true;

                        section <= memoryOperation0;

                    elsif (wb_en_signal = true and not (decodedInstr_signal.rd_addr = 0)) then

                        if    wb_sel_signal = WB_ALU then
                            CtlToRegs_data_signal.dst_data <= ALUtoCtl_port.ALU_result;
                            CtlToRegs_port.dst_data        <= ALUtoCtl_port.ALU_result;
                        elsif wb_sel_signal = WB_MEM then
                            CtlToRegs_data_signal.dst_data <= MemToCtl_data_signal;
                            CtlToRegs_port.dst_data        <= MemToCtl_data_signal;
                        elsif wb_sel_signal = WB_PC4 then
                            CtlToRegs_data_signal.dst_data <= pc_reg_signal + 4;
                            CtlToRegs_port.dst_data        <= pc_reg_signal + 4;
                        end if;


                        CtlToRegs_data_signal.dst <= decodedInstr_signal.rd_addr;
                        CtlToRegs_data_signal.req <= REG_WR;

                        -- Write to Registers
                        CtlToRegs_port.dst  <= decodedInstr_signal.rd_addr;
                        CtlToRegs_port.req  <= REG_WR;
                        CtlToRegs_port.src1 <= CtlToRegs_data_signal.src1;
                        CtlToRegs_port.src2 <= CtlToRegs_data_signal.src2;

                        CtlToRegs_port_notify <= true;
              
                        section <= writeBack;

                    else 

                        MemoryAccess_signal.addrIn <= pc_next_signal_temp;
                        MemoryAccess_signal.dataIn <= (others => '0');
                        MemoryAccess_signal.mask   <= MT_W;
                        MemoryAccess_signal.req    <= MEM_RD_I;

                        CtlToMem_port.addrIn <= pc_next_signal_temp;
                        CtlToMem_port.dataIn <= (others => '0');
                        CtlToMem_port.mask   <= MT_W;					-- Was missing
                        CtlToMem_port.req    <= MEM_RD_I;

                        CtlToMem_port_notify <= true;

                        pc_reg_signal <= pc_next_signal_temp;

                        section <= fetchAndDecode0;

                    end if; 


                 end if;





             ---------------------------------------------------------------------------------------------------
             elsif section = memoryOperation0 then

                 if CtlToMem_port_sync = true then


                    CtlToMem_port_notify <= false;

                    MemToCtl_port_notify <= true; 
             
                    section <= memoryOperation1; 

                 else 

                    CtlToMem_port.addrIn <= MemoryAccess_signal.addrIn;
                    CtlToMem_port.dataIn <= MemoryAccess_signal.dataIn;
                    CtlToMem_port.mask   <= MemoryAccess_signal.mask;		
                    CtlToMem_port.req    <= MemoryAccess_signal.req;

                 end if;











             ---------------------------------------------------------------------------------------------------
             elsif section = memoryOperation1 then

                 if MemToCtl_port_sync = true then
                 
                    MemToCtl_data_signal <= MemToCtl_port;                                                         -- Was missing

                    MemToCtl_port_notify <= false; 
             
                    if (wb_en_signal = true and not (decodedInstr_signal.rd_addr = 0)) then

                        if    wb_sel_signal = WB_ALU then
                            CtlToRegs_data_signal.dst_data <= ALUtoCtl_data_signal.ALU_result;
                            CtlToRegs_port.dst_data        <= ALUtoCtl_data_signal.ALU_result;
                        elsif wb_sel_signal = WB_MEM then
                            --CtlToRegs_data_signal.dst_data <= MemToCtl_data_signal;                            -- "MemToCtl" was never read (Load). Properties held nevertheless.
                            --CtlToRegs_port.dst_data        <= MemToCtl_data_signal;
                            CtlToRegs_data_signal.dst_data <= MemToCtl_port;
                            CtlToRegs_port.dst_data        <= MemToCtl_port;
                        elsif wb_sel_signal = WB_PC4 then
                            CtlToRegs_data_signal.dst_data <= pc_reg_signal + 4;
                            CtlToRegs_port.dst_data        <= pc_reg_signal + 4;
                        end if;


                        CtlToRegs_data_signal.dst <= decodedInstr_signal.rd_addr;
                        CtlToRegs_data_signal.req <= REG_WR;

                        CtlToRegs_port.dst  <= decodedInstr_signal.rd_addr;
                        CtlToRegs_port.req  <= REG_WR;
                        CtlToRegs_port.src1 <= CtlToRegs_data_signal.src1;
                        CtlToRegs_port.src2 <= CtlToRegs_data_signal.src2;

                        CtlToRegs_port_notify <= true;

                        section <= writeBack;

                    else

                        memoryAccess_signal.addrIn <= pc_next_signal;
                        memoryAccess_signal.dataIn <= (others => '0');
                        memoryAccess_signal.mask   <= MT_W;
                        memoryAccess_signal.req    <= MEM_RD_I;

                        CtlToMem_port.addrIn <= pc_next_signal;
                        CtlToMem_port.dataIn <= (others => '0');
                        CtlToMem_port.mask   <= MT_W;
                        CtlToMem_port.req    <= MEM_RD_I;

                        CtlToMem_port_notify <= true;

                        pc_reg_signal <= pc_next_signal;

                        section <= fetchAndDecode0; 

                    end if;


                 end if;

             ---------------------------------------------------------------------------------------------------
             elsif section = writeBack then

                if CtlToRegs_port_sync = true then

                    pc_reg_signal <= pc_next_signal;

                    memoryAccess_signal.addrIn <= pc_next_signal;
                    memoryAccess_signal.dataIn <= (others => '0');
                    memoryAccess_signal.mask   <= MT_W;
                    memoryAccess_signal.req    <= MEM_RD_I;

                    CtlToMem_port.addrIn <= pc_next_signal;
                    CtlToMem_port.dataIn <= (others => '0');
                    CtlToMem_port.mask   <= MT_W;
                    CtlToMem_port.req    <= MEM_RD_I;

                    CtlToRegs_port_notify <= false;

                    CtlToMem_port_notify <= true;

                    section <= fetchAndDecode0;    
                end if;

             end if;

         end if;

     end if;

     end process;

end Cpath_arch;






























