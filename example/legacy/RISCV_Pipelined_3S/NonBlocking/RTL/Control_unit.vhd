--
-- CREATED BY: SALAHEDDIN HETALANI (salaheddinhetalani@gmail.com) ON 29 Jan, 2019
--

library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SCAM_Model_types.all;

entity Control_unit is
    port(
        clk                : in  std_logic;
        rst                : in  std_logic;

        CUtoME_port        : out COtoME_IF;
        CUtoME_port_sync   : in  bool;
        CUtoME_port_notify : out bool;
        MEtoCU_port        : in  MEtoCO_IF;
        MEtoCU_port_sync   : in  bool;
        MEtoCU_port_notify : out bool;

        CUtoDE_port        : out CUtoDE_IF;
        DEtoCU_port        : in  DEtoCU_IF;

        CUtoRF_port        : out CUtoRF_IF;
        CUtoRF_port_notify : out bool;
        RFtoCU_port        : in  RFtoCU_IF;

        CUtoAL_port        : out CUtoAL_IF;
        ALtoCU_port        : in  ALtoCU_IF
    );
end Control_unit;


architecture Control_unit_arch of Control_unit is

    signal section : CU_SECTIONS;

    signal CS_2_s2 : ControlSignals_s2;
    signal CS_3_s2 : ControlSignals_s3;
    signal CS_3_s3 : ControlSignals_s3;
    signal DS_s2   : DataSignals_s2;
    signal DS_s3   : DataSignals_s3;

    signal loadedData     : Unsigned (31 downto 0);
    signal pc             : Unsigned (31 downto 0);

begin

    ------------------ ID_STAGE ------------------

    CUtoDE_port.encodedInstr <= MEtoCU_port.loadedData;

    CUtoRF_port.src1  <= DEtoCU_port.regRs1Addr_s1;
    CUtoRF_port.src2  <= DEtoCU_port.regRs2Addr_s1;

    ------------------ EX_STAGE ------------------

    CUtoAL_port.aluFunc <= CS_2_s2.aluFunc;

    with CS_2_s2.aluOp1Sel select CUtoAL_port.aluOp1 <=
        DS_s2.reg1content  when OP_REG,
        DS_s2.imm 	   when OP_IMM,
        DS_s2.pc 	   when OP_PC,
        (others => '0')    when OP_X;

    with CS_2_s2.aluOp2Sel select CUtoAL_port.aluOp2 <=
        DS_s2.reg2content  when OP_REG,
        DS_s2.imm 	   when OP_IMM,
        DS_s2.pc 	   when OP_PC,
        (others => '0')    when OP_X;


    process(clk)

        variable reg1Content : Unsigned (31 downto 0);
        variable reg2Content : Unsigned (31 downto 0);
        variable currPCvalue : Unsigned (31 downto 0);
        variable branchTaken : bool;

    begin

        if (clk='1' and clk'event) then

            if rst = '1' then

                section <= writeMem;

                CUtoME_port.req     <= ME_RD;
                CUtoME_port.mask    <= MT_W;
                CUtoME_port.addrIn  <= (others => '0');
                CUtoME_port.dataIn  <= (others => '0');
		CUtoRF_port.dst     <= (others => '0');
		CUtoRF_port.dstData <= (others => '0');

                CUtoME_port_notify  <= true;
                MEtoCU_port_notify  <= false;
                CUtoRF_port_notify  <= false;

                CS_2_s2.aluFunc      <= ALU_X;
                CS_2_s2.aluOp1Sel    <= OP_X;
                CS_2_s2.aluOp2Sel    <= OP_X;
                CS_3_s2.regfileWrite <= false;
                CS_3_s2.writeDataSel <= WB_X;
                CS_3_s3.regfileWrite <= false;
                CS_3_s3.writeDataSel <= WB_X;

		DS_s2.encType     <= ENC_I_I;
		DS_s2.regRdAddr   <= (others => '0');
		DS_s2.reg1Content <= (others => '0');
		DS_s2.reg2Content <= (others => '0');
		DS_s2.imm 	  <= (others => '0');
		DS_s2.pc 	  <= (others => '0');
		DS_s3.encType     <= ENC_I_I;
		DS_s3.regRdAddr   <= (others => '0');
		DS_s3.aluResult   <= (others => '0');
		DS_s3.pc 	  <= (others => '0');

                loadedData <= (others => '0');
                pc         <= (others => '0');

	        reg1content := (others => '0');
	        reg2content := (others => '0');
                currPCvalue := (others => '0');
		branchTaken := false;

            else

                if section = writeMem then

                    ------------------ WRITE MEM ------------------

                    if CUtoME_port_sync = true then

                        MEtoCU_port_notify <= true;
                        CUtoME_port_notify <= false;
                        section <= readMem;

                    else

                        MEtoCU_port_notify <= false;
                        CUtoME_port_notify <= true;

                    end if;

                        ------------------ WB STAGE ------------------

			if (CS_3_s3.regfileWrite) then

			    CUtoRF_port.dst <= DS_s3.regRdAddr;

			    if (CS_3_s3.writeDataSel = WB_ALU) then
			        CUtoRF_port.dstData <= DS_s3.aluResult;
			    elsif (CS_3_s3.writeDataSel = WB_MEM) then
			        CUtoRF_port.dstData <= loadedData;
			    elsif (CS_3_s3.writeDataSel = WB_PC4) then
			        CUtoRF_port.dstData <= DS_s3.pc + 4;
			    else 
			        CUtoRF_port.dstData <= (others => '0');
			    end if;

			end if;

			if (not(DS_s3.encType = ENC_I_L and DS_s2.encType = ENC_I_L)) then 

                        ------------------ SETTING CONTROL SIGNALS ------------------

			CS_3_s3.regfileWrite <= CS_3_s2.regfileWrite;
			CS_3_s3.writeDataSel <= CS_3_s2.writeDataSel;

                        ------------------ SETTING DATA SIGNALS ------------------

			DS_s3.encType <= DS_s2.encType;
			DS_s3.regRdAddr <= DS_s2.regRdAddr;
			DS_s3.aluResult <= ALtoCU_port.aluResult;
			DS_s3.pc <= DS_s2.pc;

			end if;

			if (CS_3_s3.regfileWrite = true) then
                            CUtoRF_port_notify <= true;
			else
                            CUtoRF_port_notify <= false;
			end if;

                elsif section = readMem then

                    ------------------ READ MEM ------------------

                    if MEtoCU_port_sync = true then

                        -- ID STAGE FORWARDING: REG_RS1_CONTENT

			if (DEtoCU_port.regRs1Addr_s1 = 0) then
		            reg1content := (others => '0');
			elsif (DEtoCU_port.regRs1Addr_s1 = DS_s3.regRdAddr and DS_s3.encType = ENC_I_L) then
			    reg1content := loadedData;
			elsif (DEtoCU_port.regRs1Addr_s1 = DS_s3.regRdAddr and not(DEtoCU_port.regRs1Addr_s1 = DS_s2.regRdAddr) and (DS_s3.encType = ENC_I_J or DS_s3.encType = ENC_J)) then
			    reg1content := DS_s3.pc + 4;
			elsif (DEtoCU_port.regRs1Addr_s1 = DS_s3.regRdAddr and not(DEtoCU_port.regRs1Addr_s1 = DS_s2.regRdAddr)) then
			    reg1content := DS_s3.aluResult;
			elsif (DEtoCU_port.regRs1Addr_s1 = DS_s2.regRdAddr and (DS_s2.encType = ENC_I_J or DS_s2.encType = ENC_J)) then
			    reg1content := DS_s2.pc + 4;
			elsif (DEtoCU_port.regRs1Addr_s1 = DS_s2.regRdAddr) then
			    reg1content := ALtoCU_port.aluResult;
			else
			    reg1content := RFtoCU_port.reg1Content;
			end if;

                       -- ID STAGE FORWARDING: REG_RS2_CONTENT

			if (DEtoCU_port.regRs2Addr_s1 = 0) then
		            reg2content := (others => '0');
			elsif (DEtoCU_port.regRs2Addr_s1 = DS_s3.regRdAddr and DS_s3.encType = ENC_I_L) then
			    reg2content := loadedData;
			elsif (DEtoCU_port.regRs2Addr_s1 = DS_s3.regRdAddr and not(DEtoCU_port.regRs2Addr_s1 = DS_s2.regRdAddr) and (DS_s3.encType = ENC_I_J or DS_s3.encType = ENC_J)) then
			    reg2content := DS_s3.pc + 4;
			elsif (DEtoCU_port.regRs2Addr_s1 = DS_s3.regRdAddr and not(DEtoCU_port.regRs2Addr_s1 = DS_s2.regRdAddr)) then
			    reg2content := DS_s3.aluResult;
			elsif (DEtoCU_port.regRs2Addr_s1 = DS_s2.regRdAddr and (DS_s2.encType = ENC_I_J or DS_s2.encType = ENC_J)) then
			    reg2content := DS_s2.pc + 4;
			elsif (DEtoCU_port.regRs2Addr_s1 = DS_s2.regRdAddr) then
			    reg2content := ALtoCU_port.aluResult;
			else
			    reg2content := RFtoCU_port.reg2Content;
			end if;

                        ------------------ WB STAGE ------------------

			if (CS_3_s3.regfileWrite) then

			    CUtoRF_port.dst <= DS_s3.regRdAddr;

			    if (CS_3_s3.writeDataSel = WB_ALU) then
			        CUtoRF_port.dstData <= DS_s3.aluResult;
			    elsif (CS_3_s3.writeDataSel = WB_MEM) then
			        CUtoRF_port.dstData <= loadedData;
			    elsif (CS_3_s3.writeDataSel = WB_PC4) then
			        CUtoRF_port.dstData <= DS_s3.pc + 4;
			    else 
			        CUtoRF_port.dstData <= (others => '0');
			    end if;

			end if;

                        ------------------ BRANCH EVALUATION ------------------

                        if    (DEtoCU_port.instrType_s1 = INSTR_BEQ and (reg1content - reg2content = 0)) then
                            branchTaken := true;
                        elsif (DEtoCU_port.instrType_s1 = INSTR_BNE and (not (reg1content - reg2content = 0))) then
                            branchTaken := true;
                        elsif (DEtoCU_port.instrType_s1 = INSTR_BLT and (signed(reg1content) < signed(reg2content))) then
                            branchTaken := true;
                        elsif (DEtoCU_port.instrType_s1 = INSTR_BGE and (signed(reg1content) >= signed(reg2content))) then
                            branchTaken := true;
                        elsif (DEtoCU_port.instrType_s1 = INSTR_BLTU and (reg1content < reg2content)) then
                            branchTaken := true;
                        elsif (DEtoCU_port.instrType_s1 = INSTR_BGEU and (reg1content >= reg2content)) then
                            branchTaken := true;
                        else
                            branchTaken := false;
                        end if;

                        ------------------ SETTING NEXT PC ------------------

			if (DEtoCU_port.pcSel_s1 = PC_BR) then
			    if (branchTaken) then
			        currPCvalue := pc + DEtoCU_port.imm_s1;
			    else 
			        currPCvalue := pc + 4;
			    end if;
			elsif (DEtoCU_port.pcSel_s1 = PC_J) then
			    currPCvalue := pc + DEtoCU_port.imm_s1;
			elsif (DEtoCU_port.pcSel_s1 = PC_JR) then
			    currPCvalue := reg1content + DEtoCU_port.imm_s1;
			else 
			    currPCvalue := pc + 4;
			end if;

                        pc <= currPCvalue;

                        ------------------ SETTING CONTROL SIGNALS ------------------

			CS_3_s3.regfileWrite <= CS_3_s2.regfileWrite;
			CS_3_s3.writeDataSel <= CS_3_s2.writeDataSel;
			CS_2_s2.aluFunc <= DEtoCU_port.aluFunc_s2;
			CS_2_s2.aluOp1Sel <= DEtoCU_port.aluOp1Sel_s2;
			CS_2_s2.aluOp2Sel <= DEtoCU_port.aluOp2Sel_s2;
			CS_3_s2.regfileWrite <= DEtoCU_port.regfileWrite_s3;
			CS_3_s2.writeDataSel <= DEtoCU_port.writeDataSel_s3;

                        ------------------ SETTING DATA SIGNALS ------------------

			DS_s3.encType <= DS_s2.encType;
			DS_s3.regRdAddr <= DS_s2.regRdAddr;
			DS_s3.aluResult <= ALtoCU_port.aluResult;
			DS_s3.pc <= DS_s2.pc;
			DS_s2.encType <= DEtoCU_port.encType_s1;
			DS_s2.regRdAddr <= DEtoCU_port.regRdAddr_s1;
			DS_s2.reg1content <= reg1content;
			DS_s2.reg2content <= reg2content;
			DS_s2.imm <= DEtoCU_port.imm_s1;
			DS_s2.pc <= pc;

			--aluResult <= ALtoCU_port.aluResult;

                        ------------------ SETTING NEXT MEM ACCESS ------------------

			if (DEtoCU_port.encType_s1 = ENC_S) then

			    CUtoME_port.req <= ME_WR;
			    CUtoME_port.mask <= DEtoCU_port.dmemMask;
                            CUtoME_port.addrIn <= reg1content + DEtoCU_port.imm_s1;
			    CUtoME_port.dataIn <= reg2content;

			elsif (DEtoCU_port.encType_s1 = ENC_I_L) then

			    CUtoME_port.req <= ME_RD;
			    CUtoME_port.mask <= DEtoCU_port.dmemMask;
                            CUtoME_port.addrIn <= reg1content + DEtoCU_port.imm_s1;
			    CUtoME_port.dataIn <= (others => '0');

                        else

                            CUtoME_port.req <= ME_RD;
                            CUtoME_port.mask <= MT_W;
                            CUtoME_port.addrIn <= currPCvalue;
                            CUtoME_port.dataIn <= (others => '0');

                        end if;

                        ------------------ SETTING SYNC AND NOTIFY ------------------

                        MEtoCU_port_notify <= false;
                        CUtoME_port_notify <= true;

			if (CS_3_s3.regfileWrite = true) then
                            CUtoRF_port_notify <= true;
			else
                            CUtoRF_port_notify <= false;
			end if;

			if (DEtoCU_port.encType_s1 = ENC_S or DEtoCU_port.encType_s1 = ENC_I_L) then
			    section <= writeDmem;
			else 
			    section <= writeMem;
			end if;

                    else

                        ------------------ WB STAGE ------------------

			if (CS_3_s3.regfileWrite) then

			    CUtoRF_port.dst <= DS_s3.regRdAddr;

			    if (CS_3_s3.writeDataSel = WB_ALU) then
			        CUtoRF_port.dstData <= DS_s3.aluResult;
			    elsif (CS_3_s3.writeDataSel = WB_MEM) then
			        CUtoRF_port.dstData <= loadedData;
			    elsif (CS_3_s3.writeDataSel = WB_PC4) then
			        CUtoRF_port.dstData <= DS_s3.pc + 4;
			    else 
			        CUtoRF_port.dstData <= (others => '0');
			    end if;

			end if;

                        ------------------ SETTING CONTROL SIGNALS ------------------

			CS_3_s3.regfileWrite <= CS_3_s2.regfileWrite;
			CS_3_s3.writeDataSel <= CS_3_s2.writeDataSel;

                        ------------------ SETTING DATA SIGNALS ------------------

			DS_s3.encType <= DS_s2.encType;
			DS_s3.regRdAddr <= DS_s2.regRdAddr;
			DS_s3.aluResult <= ALtoCU_port.aluResult;
			DS_s3.pc <= DS_s2.pc;

			if (CS_3_s3.regfileWrite = true) then
                            CUtoRF_port_notify <= true;
			else
                            CUtoRF_port_notify <= false;
			end if;

                        MEtoCU_port_notify <= true;
                        CUtoME_port_notify <= false;

                    end if;

                elsif section = writeDmem then

                    ------------------ WRITE DMEM ------------------

                    if CUtoME_port_sync = true then

                        MEtoCU_port_notify <= true;
                        CUtoME_port_notify <= false;
                        section <= readDmem;

                    else

                        MEtoCU_port_notify <= false;
                        CUtoME_port_notify <= true;

                    end if;

                        ------------------ WB STAGE ------------------

			if (CS_3_s3.regfileWrite) then

			    CUtoRF_port.dst <= DS_s3.regRdAddr;

			    if (CS_3_s3.writeDataSel = WB_ALU) then
			        CUtoRF_port.dstData <= DS_s3.aluResult;
			    elsif (CS_3_s3.writeDataSel = WB_MEM) then
			        CUtoRF_port.dstData <= loadedData;
			    elsif (CS_3_s3.writeDataSel = WB_PC4) then
			        CUtoRF_port.dstData <= DS_s3.pc + 4;
			    else 
			        CUtoRF_port.dstData <= (others => '0');
			    end if;

			end if;

			if (CS_3_s3.regfileWrite = true) then
                            CUtoRF_port_notify <= true;
			else
                            CUtoRF_port_notify <= false;
			end if;

                elsif section = readDmem then

                    ------------------ READ DMEM ------------------

		    if MEtoCU_port_sync = true then

			loadedData <= MEtoCU_port.loadedData;

                        ------------------ WB STAGE ------------------

			if (CS_3_s3.regfileWrite) then

			    CUtoRF_port.dst <= DS_s3.regRdAddr;

			    if (CS_3_s3.writeDataSel = WB_ALU) then
			        CUtoRF_port.dstData <= DS_s3.aluResult;
			    elsif (CS_3_s3.writeDataSel = WB_MEM) then
			        CUtoRF_port.dstData <= loadedData;
			    elsif (CS_3_s3.writeDataSel = WB_PC4) then
			        CUtoRF_port.dstData <= DS_s3.pc + 4;
			    else 
			        CUtoRF_port.dstData <= (others => '0');
			    end if;

			end if;

                        ------------------ SETTING CONTROL SIGNALS ------------------

			CS_3_s3.regfileWrite <= CS_3_s2.regfileWrite;
			CS_3_s3.writeDataSel <= CS_3_s2.writeDataSel;
			CS_3_s2.regfileWrite <= false;

                        ------------------ SETTING DATA SIGNALS ------------------

			DS_s3.encType <= DS_s2.encType;
			DS_s3.regRdAddr <= DS_s2.regRdAddr;
			DS_s3.pc <= DS_s2.pc;
			DS_s2.regRdAddr <= (others => '0');

                        ------------------ SETTING NEXT MEM ACCESS ------------------

                        CUtoME_port.req <= ME_RD;
                        CUtoME_port.mask <= MT_W;
                        CUtoME_port.addrIn <= pc;
                        CUtoME_port.dataIn <= (others => '0');

                        ------------------ SETTING SYNC AND NOTIFY ------------------

			if (CS_3_s3.regfileWrite = true) then
                            CUtoRF_port_notify <= true;
			else
                            CUtoRF_port_notify <= false;
			end if;

                        MEtoCU_port_notify <= false;
                        CUtoME_port_notify <= true;

                        section <= writeMem;

                    else

                        MEtoCU_port_notify <= true;
                        CUtoME_port_notify <= false;
                        CUtoRF_port_notify <= false;

                    end if;

                end if;

            end if; -- RST

        end if; -- CLK

    end process;

end Control_unit_arch;
