--
-- CREATED BY: SALAHEDDIN HETALANI (salaheddinhetalani@gmail.com) ON 23 OCT, 2018
--

library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SCAM_Model_types.all;

entity Control_unit is
    port(
        clk                 : in  std_logic;
        rst                 : in  std_logic;
        CUtoME_port         : out CUtoME_IF;
        CUtoME_port_sync    : in  bool;
        CUtoME_port_notify  : out bool;
        MEtoCU_port         : in  MEtoCU_IF;
        MEtoCU_port_sync    : in  bool;
        MEtoCU_port_notify  : out bool;
        CUtoDE_port         : out CUtoDE_IF;
        DEtoCU_port         : in  DEtoCU_IF;
        CUtoDP_port         : out CUtoDP_IF;
        CUtoDP_port_notify  : out bool;
        DPtoCU_port         : in  DPtoCU_IF
    );
end Control_unit;


architecture Control_unit_arch of Control_unit is

    signal section          : CU_SECTIONS;

    signal CUtoDP_3_s3      : CUtoDP_S3;
    signal CUtoDP_4_s3      : CUtoDP_S4;
    signal CUtoDP_5_s3      : CUtoDP_S5;
    signal CUtoDP_4_s4      : CUtoDP_S4;
    signal CUtoDP_5_s4      : CUtoDP_S5;
    signal CUtoDP_5_s5      : CUtoDP_S5;

    signal loadedInstr      : Unsigned (31 downto 0);
    signal prevLoadedInstr  : Unsigned (31 downto 0);
    signal prevInstrType    : InstrType;
    signal prevReg1Content  : Unsigned (31 downto 0);
    signal prevPCsel        : PC_SelType;
    signal prevPCimm        : Unsigned (31 downto 0);
    signal regRdAddr_prev1  : Unsigned ( 4 downto 0);
    signal regRdAddr_prev2  : Unsigned ( 4 downto 0);
    signal regRdAddr_prev3  : Unsigned ( 4 downto 0);
    signal encType_prev1    : EncType;
    signal encType_prev2    : EncType;
    signal encType_prev3    : EncType;
    signal pc               : Unsigned (31 downto 0);
    signal prevPC           : Unsigned (31 downto 0);

    signal stall            : bool;
    signal stallOnce        : bool;
    signal stallTwice       : bool;
    signal stallDmemAccess  : bool;
    signal dmemAccess       : bool;
    signal flush            : bool;
    signal flushDmemAccess  : bool;
    signal prevDmemAccess   : bool;
    signal prevJalrInstr    : bool;

begin

    with stall select CUtoDE_port.encodedInstr <=
        loadedInstr when false,
        prevLoadedInstr when true;

    process(clk)

        variable CUtoDP_3_s2     : CUtoDP_S3;
        variable CUtoDP_4_s2     : CUtoDP_S4;
        variable CUtoDP_5_s2     : CUtoDP_S5;

        variable currReg1content : Unsigned (31 downto 0);
        variable currPCsel       : PC_SelType;
        variable currPCimm       : Unsigned (31 downto 0);
        variable currEncType     : EncType;
        variable currPCvalue     : Unsigned (31 downto 0);

        variable currStall       : bool;
        variable currStallOnce   : bool;
        variable currStallTwice  : bool;
        variable currBranchTaken : bool;

    begin

        if (clk='1' and clk'event) then

            if rst = '1' then

                section                            <= writeMem;

                CUtoME_port.req                    <= ME_RD;
                CUtoME_port.mask                   <= MT_W;
                CUtoME_port.addrIn                 <= (others => '0');
                CUtoME_port.dataIn                 <= (others => '0');

                CUtoDP_port.stallDmemAccess        <= false;
                CUtoDP_port.prevDmemAccess         <= false;
                CUtoDP_port.loadedData             <= (others => '0');
                CUtoDP_port.pc_s2                  <= (others => '0');
                CUtoDP_port.encType_s2             <= ENC_I_I;
                CUtoDP_port.regFileReq_s2          <= RF_RD_X;
                CUtoDP_port.regRs1Addr_s2          <= (others => '0');
                CUtoDP_port.regRs2Addr_s2          <= (others => '0');
                CUtoDP_port.regRdAddr_s2           <= (others => '0');
                CUtoDP_port.aluFunc_s3             <= ALU_X;
                CUtoDP_port.aluOp1Sel_s3           <= OP_X;
                CUtoDP_port.aluOp2Sel_s3           <= OP_X;
                CUtoDP_port.imm_s3                 <= (others => '0');
                CUtoDP_port.dmemReq_s4             <= ME_X;
                CUtoDP_port.dmemMask_s4            <= MT_X;
                CUtoDP_port.regFileReq_s5          <= RF_WR_X;
                CUtoDP_port.regFileWriteDataSel_s5 <= WB_X;

                CUtoME_port_notify                 <= true;
                MEtoCU_port_notify                 <= false;
                CUtoDP_port_notify                 <= false;

                CUtoDP_3_s3.aluFunc_s3             <= ALU_X;
                CUtoDP_3_s3.aluOp1Sel_s3           <= OP_X;
                CUtoDP_3_s3.aluOp2Sel_s3           <= OP_X;
                CUtoDP_3_s3.imm_s3                 <= (others => '0');
                CUtoDP_4_s3.dmemMask_s4            <= MT_X;
                CUtoDP_4_s3.dmemReq_s4             <= ME_X;
                CUtoDP_5_s3.regFileReq_s5          <= RF_WR_X;
                CUtoDP_5_s3.regFileWriteDataSel_s5 <= WB_X;
                CUtoDP_4_s4.dmemMask_s4            <= MT_X;
                CUtoDP_4_s4.dmemReq_s4             <= ME_X;
                CUtoDP_5_s4.regFileReq_s5          <= RF_WR_X;
                CUtoDP_5_s4.regFileWriteDataSel_s5 <= WB_X;
                CUtoDP_5_s5.regFileReq_s5          <= RF_WR_X;
                CUtoDP_5_s5.regFileWriteDataSel_s5 <= WB_X;

                loadedInstr                        <= to_unsigned(19, 32);
                prevLoadedInstr                    <= (others => '0');
                prevInstrType                      <= INSTR_ADDI;
                prevReg1Content                    <= (others => '0');
                prevPCsel                          <= PC_4;
                prevPCimm                          <= (others => '0');
                regRdAddr_prev1                    <= (others => '0');
                regRdAddr_prev2                    <= (others => '0');
                regRdAddr_prev3                    <= (others => '0');
                encType_prev1                      <= ENC_I_I;
                encType_prev2                      <= ENC_I_I;
                encType_prev3                      <= ENC_I_I;
                pc                                 <= (others => '0');
                prevPC                             <= (others => '0');

                stall                              <= false;
                stallOnce                          <= false;
                stallTwice                         <= false;
                stallDmemAccess                    <= false;
                dmemAccess                         <= false;
                flush                              <= false;
                flushDmemAccess                    <= false;
                prevDmemAccess                     <= false;
                prevJalrInstr                      <= false;

                CUtoDP_3_s2.aluFunc_s3             := ALU_X;
                CUtoDP_3_s2.aluOp1Sel_s3           := OP_X;
                CUtoDP_3_s2.aluOp2Sel_s3           := OP_X;
                CUtoDP_3_s2.imm_s3                 := (others => '0');
                CUtoDP_4_s2.dmemReq_s4             := ME_X;
                CUtoDP_4_s2.dmemMask_s4            := MT_X;
                CUtoDP_5_s2.regFileReq_s5          := RF_WR_X;
                CUtoDP_5_s2.regFileWriteDataSel_s5 := WB_X;

                currReg1content                    := (others => '0');
                currPCsel                          := PC_4;
                currPCimm                          := (others => '0');
                currEncType                        := ENC_I_I;
                currPCvalue                        := (others => '0');

                currStall                          := false;
                currStallOnce                      := false;
                currStallTwice                     := false;
                currBranchTaken                    := false;

            else

                if section = writeMem then

                ------------------ WRITE MEM ------------------

                    if CUtoME_port_sync = true then

                        CUtoME_port_notify <= false;
                        MEtoCU_port_notify <= true;
                        CUtoDP_port_notify <= false;
                        section <= readMem;

                    else

                        CUtoME_port_notify <= true;
                        MEtoCU_port_notify <= false;
                        CUtoDP_port_notify <= false;

                    end if;

                elsif section = readMem then

                ------------------ READ MEM ------------------

                    if MEtoCU_port_sync = true then

                        CUtoDP_3_s2.aluFunc_s3             := ALU_X;
                        CUtoDP_3_s2.aluOp1Sel_s3           := OP_X;
                        CUtoDP_3_s2.aluOp2Sel_s3           := OP_X;
                        CUtoDP_3_s2.imm_s3                 := (others => '0');
                        CUtoDP_4_s2.dmemReq_s4             := ME_X;
                        CUtoDP_4_s2.dmemMask_s4            := MT_X;
                        CUtoDP_5_s2.regFileReq_s5          := RF_WR_X;
                        CUtoDP_5_s2.regFileWriteDataSel_s5 := WB_X;

                        currStall                          := false;
                        currStallOnce                      := false;
                        currStallTwice                     := false;
                        currBranchTaken                    := false;
                        currReg1content                    := (others => '0');
                        currPCsel                          := PC_4;
                        currPCimm                          := (others => '0');
                        currEncType                        := ENC_I_I;
                        currPCvalue                        := (others => '0');

                        ---------- SETTING NEXT INSTR TO BE DECODED ----------

                        if (not(stall = true)) then
                            prevLoadedInstr <= loadedInstr;
                            loadedInstr <= MEtoCU_port.loadedData;
                        end if;

                        ------------------ BRANCH EVALUATION ------------------

                        if    (prevInstrType = INSTR_BEQ and (DPtoCU_port.reg1Content - DPtoCU_port.reg2Content = 0)) then
                            currBranchTaken := true;
                        elsif (prevInstrType = INSTR_BNE and (not (DPtoCU_port.reg1Content - DPtoCU_port.reg2Content = 0))) then
                            currBranchTaken := true;
                        elsif (prevInstrType = INSTR_BLT and (signed(DPtoCU_port.reg1Content) < signed(DPtoCU_port.reg2Content))) then
                            currBranchTaken := true;
                        elsif (prevInstrType = INSTR_BGE and (signed(DPtoCU_port.reg1Content) >= signed(DPtoCU_port.reg2Content))) then
                            currBranchTaken := true;
                        elsif (prevInstrType = INSTR_BLTU and (DPtoCU_port.reg1Content < DPtoCU_port.reg2Content)) then
                            currBranchTaken := true;
                        elsif (prevInstrType = INSTR_BGEU and (DPtoCU_port.reg1Content >= DPtoCU_port.reg2Content)) then
                            currBranchTaken := true;
                        else
                            currBranchTaken := false;
                        end if;

                         if (flush = true and dmemAccess = true) then
                            currReg1content := prevReg1Content;
                            currBranchTaken := true;
                         else
                            currReg1content := DPtoCU_port.reg1Content;
                         end if;

                        ------------------ CHECKING DEPENDENCIES ------------------

                        if ((not(stall = true)) and (not(regRdAddr_prev1 = 0))) then

                            if    ((((DEtoCU_port.encType_s2 = ENC_B) and (encType_prev1 = ENC_R or encType_prev1 = ENC_I_I or encType_prev1 = ENC_U)) or
                                     (DEtoCU_port.encType_s2 = ENC_R and encType_prev1 = ENC_I_L)) and
                                    ((DEtoCU_port.regRs1Addr_s2 = regRdAddr_prev1) or (DEtoCU_port.regRs2Addr_s2 = regRdAddr_prev1))) then
                                currStallOnce  := true;

                            elsif ((DEtoCU_port.encType_s2 = ENC_B) and (encType_prev1 = ENC_I_L) and ((DEtoCU_port.regRs1Addr_s2 = regRdAddr_prev1) or
                                   (DEtoCU_port.regRs2Addr_s2 = regRdAddr_prev1))) then
                                currStallTwice := true;

                            elsif ((((DEtoCU_port.encType_s2 = ENC_I_I or DEtoCU_port.encType_s2 = ENC_I_L or DEtoCU_port.encType_s2 = ENC_S) and encType_prev1 = ENC_I_L) or
                                     (DEtoCU_port.encType_s2 = ENC_I_J and (encType_prev1 = ENC_R or encType_prev1 = ENC_I_I or encType_prev1 = ENC_U))) and
                                     (DEtoCU_port.regRs1Addr_s2 = regRdAddr_prev1)) then
                                currStallOnce  := true;

                            elsif ((DEtoCU_port.encType_s2 = ENC_I_J and encType_prev1 = ENC_I_L) and
                                   (DEtoCU_port.regRs1Addr_s2 = regRdAddr_prev1)) then
                                currStallTwice := true;

                            end if;

                        end if;

                        if (not(currStallOnce = true) and not(currStallTwice = true) and not(stallOnce = true) and not(stallTwice = true) and encType_prev1 /= ENC_J and encType_prev1 /= ENC_I_J and not(currBranchTaken = true)) then

                            if    ((DEtoCU_port.encType_s2 = ENC_I_J and encType_prev2 = ENC_I_L and DEtoCU_port.regRs1Addr_s2 = regRdAddr_prev2 and regRdAddr_prev2 /= 0) or
                                   (DEtoCU_port.encType_s2 = ENC_B and encType_prev2 = ENC_I_L and (DEtoCU_port.regRs1Addr_s2 = regRdAddr_prev2 or DEtoCU_port.regRs2Addr_s2 = regRdAddr_prev2) and regRdAddr_prev2 /= 0)) then
                                currStallOnce := true;

                            elsif (prevDmemAccess = true and ((DEtoCU_port.encType_s2 = ENC_I_J and encType_prev3 = ENC_I_L and DEtoCU_port.regRs1Addr_s2 = regRdAddr_prev3 and regRdAddr_prev3 /= 0) or
                                   (DEtoCU_port.encType_s2 = ENC_B and encType_prev3 = ENC_I_L and (DEtoCU_port.regRs1Addr_s2 = regRdAddr_prev3 or DEtoCU_port.regRs2Addr_s2 = regRdAddr_prev3) and regRdAddr_prev3 /= 0))) then
                                currStallOnce := true;

                            else
                                currStallOnce := false;
                            end if;

                        end if;

                        if (stallDmemAccess = true and currStallTwice = true) then
                            stallTwice <= true;
                            stallOnce  <= false;
                        elsif(stallDmemAccess = true and (currStallOnce = true or stallOnce = true)) then
                            stallTwice <= false;
                            stallOnce  <= true;
                        elsif(stallTwice = true or currStallTwice = true) then
                            stallTwice <= false;
                            stallOnce  <= true;
                        else
                            stallTwice <= false;
                            stallOnce  <= false;
                        end if;

                        if (stallDmemAccess = true or currStallOnce = true or currStallTwice = true or stallOnce = true or stallTwice = true) then
                            stall <= true;
                            currStall := true;
                        else
                            stall <= false;
                            currStall := false;
                        end if;

                        ------------------ SETTING DP SIGNALS ------------------

                        if (currBranchTaken or flushDmemAccess = true or flush = true or stallDmemAccess = true or currStallOnce = true or currStallTwice = true or stallOnce = true or stallTwice = true or encType_prev1 = ENC_J or encType_prev1 = ENC_I_J) then

                            currPCsel:= PC_4;
                            currPCimm := (others => '0');

                            prevInstrType <= INSTR_ADDI;
                            CUtoDP_port.encType_s2 <= ENC_I_I;
                            encType_prev1 <= ENC_I_I;
                            currEncType := ENC_I_I;

                            CUtoDP_port.regFileReq_s2 <= RF_RD_X;
                            CUtoDP_port.regRs1Addr_s2 <= (others => '0');
                            CUtoDP_port.regRs2Addr_s2 <= (others => '0');
                            CUtoDP_port.regRdAddr_s2 <= (others => '0');
                            regRdAddr_prev1 <= (others => '0');

                            CUtoDP_3_s2.aluFunc_s3 := ALU_X;
                            CUtoDP_3_s2.aluOp1Sel_s3 := OP_X;
                            CUtoDP_3_s2.aluOp2Sel_s3 := OP_X;
                            CUtoDP_3_s2.imm_s3 := (others => '0');
                            CUtoDP_4_s2.dmemReq_s4 := ME_X;
                            CUtoDP_4_s2.dmemMask_s4 := MT_X;
                            CUtoDP_5_s2.regFileReq_s5 := RF_WR_X;
                            CUtoDP_5_s2.regFileWriteDataSel_s5 := WB_X;

                        else

                            currPCsel:= DEtoCU_port.pcSel_s2;
                            currPCimm := DEtoCU_port.imm_s2;

                            prevInstrType <= DEtoCU_port.instrType_s2;
                            CUtoDP_port.encType_s2 <= DEtoCU_port.encType_s2;
                            encType_prev1 <= DEtoCU_port.encType_s2;
                            currEncType := DEtoCU_port.encType_s2;

                            CUtoDP_port.regFileReq_s2 <= DEtoCU_port.regFileReq_s2;
                            CUtoDP_port.regRs1Addr_s2 <= DEtoCU_port.regRs1Addr_s2;
                            CUtoDP_port.regRs2Addr_s2 <= DEtoCU_port.regRs2Addr_s2;
                            CUtoDP_port.regRdAddr_s2 <= DEtoCU_port.regRdAddr_s2;
                            regRdAddr_prev1 <= DEtoCU_port.regRdAddr_s2;

                            CUtoDP_3_s2.aluFunc_s3 := DEtoCU_port.aluFunc_s3;
                            CUtoDP_3_s2.aluOp1Sel_s3 := DEtoCU_port.aluOp1Sel_s3;
                            CUtoDP_3_s2.aluOp2Sel_s3 := DEtoCU_port.aluOp2Sel_s3;
                            CUtoDP_3_s2.imm_s3 := DEtoCU_port.imm_s3;
                            CUtoDP_4_s2.dmemReq_s4 := DEtoCU_port.dmemReq_s4;
                            CUtoDP_4_s2.dmemMask_s4 := DEtoCU_port.dmemMask_s4;
                            CUtoDP_5_s2.regFileReq_s5 := DEtoCU_port.regFileReq_s5;
                            CUtoDP_5_s2.regFileWriteDataSel_s5 := DEtoCU_port.regFileWriteDataSel_s5;

                        end if;

                        CUtoDP_port.aluFunc_s3 <= CUtoDP_3_s3.aluFunc_s3;
                        CUtoDP_port.aluOp1Sel_s3 <= CUtoDP_3_s3.aluOp1Sel_s3;
                        CUtoDP_port.aluOp2Sel_s3 <= CUtoDP_3_s3.aluOp2Sel_s3;
                        CUtoDP_port.imm_s3 <= CUtoDP_3_s3.imm_s3;

                        CUtoDP_port.dmemReq_s4 <= CUtoDP_4_s4.dmemReq_s4;
                        CUtoDP_port.dmemMask_s4 <= CUtoDP_4_s4.dmemMask_s4;

                        CUtoDP_port.regFileReq_s5 <= CUtoDP_5_s5.regFileReq_s5;
                        CUtoDP_port.regFileWriteDataSel_s5 <= CUtoDP_5_s5.regFileWriteDataSel_s5;

                        CUtoDP_port.stallDmemAccess <= stallDmemAccess;
                        CUtoDP_port.pc_s2 <= prevPC;

                        if (dmemAccess = true) then
                            CUtoDP_port.loadedData <= MEtoCU_port.loadedData;
                            CUtoDP_port.prevDmemAccess <= true;
                            prevDmemAccess <= true;
                        else
                            CUtoDP_port.loadedData <= (others => '0');
                            CUtoDP_port.prevDmemAccess <= false;
                            prevDmemAccess <= false;
                        end if;

                        ------------------ SETTING NEXT PC ------------------

                        if (prevJalrInstr = true or currBranchTaken = true) then
                            flush <= true;
                            prevReg1Content <= DPtoCU_port.reg1Content;
                            currPCsel:= prevPCsel;
                            currPCimm := prevPCimm;
                        else
                            flush <= false;
                            prevReg1Content <= (others => '0');
                        end if;

                        if (currEncType = ENC_I_J or currEncType = ENC_B) then

                            prevPCsel <= DEtoCU_port.pcSel_s2;
                            prevPCimm <= DEtoCU_port.imm_s2;
                            currPCsel:= PC_4;
                            currPCimm := (others => '0');

                            if (currEncType = ENC_I_J) then
                                prevJalrInstr <= true;
                            else
                                prevJalrInstr <= false;
                            end if;

                        else
                            prevJalrInstr <= false;
                        end if;

                        if (not(currStall = true)) then

                            if (currPCsel= PC_BR) then

                                if (currBranchTaken) then
                                    currPCvalue := pc - 8 + currPCimm;
                                else
                                    currPCvalue := pc + 4;
                                end if;

                            elsif(currPCsel= PC_J) then
                                currPCvalue := pc - 4 + currPCimm;
                            elsif(currPCsel= PC_JR) then
                                currPCvalue := currReg1content + currPCimm;
                            else
                                currPCvalue := pc + 4;
                            end if;

                            pc <= currPCvalue;
                            prevPC <= pc;

                        end if;

                        if (stallDmemAccess = true) then

                            dmemAccess <= true;

                        else

                            dmemAccess <= false;

                            ------------------ SETTING PIPELINE SIGNALS ------------------

                            CUtoDP_5_s5.regFileReq_s5 <= CUtoDP_5_s4.regFileReq_s5;
                            CUtoDP_5_s5.regFileWriteDataSel_s5 <= CUtoDP_5_s4.regFileWriteDataSel_s5;

                            CUtoDP_4_s4.dmemReq_s4 <= CUtoDP_4_s3.dmemReq_s4;
                            CUtoDP_4_s4.dmemMask_s4 <= CUtoDP_4_s3.dmemMask_s4;
                            CUtoDP_5_s4.regFileReq_s5 <= CUtoDP_5_s3.regFileReq_s5;
                            CUtoDP_5_s4.regFileWriteDataSel_s5 <= CUtoDP_5_s3.regFileWriteDataSel_s5;

                            CUtoDP_3_s3.aluFunc_s3 <= CUtoDP_3_s2.aluFunc_s3;
                            CUtoDP_3_s3.aluOp1Sel_s3 <= CUtoDP_3_s2.aluOp1Sel_s3;
                            CUtoDP_3_s3.aluOp2Sel_s3 <= CUtoDP_3_s2.aluOp2Sel_s3;
                            CUtoDP_3_s3.imm_s3 <= CUtoDP_3_s2.imm_s3;
                            CUtoDP_4_s3.dmemReq_s4 <= CUtoDP_4_s2.dmemReq_s4;
                            CUtoDP_4_s3.dmemMask_s4 <= CUtoDP_4_s2.dmemMask_s4;
                            CUtoDP_5_s3.regFileReq_s5 <= CUtoDP_5_s2.regFileReq_s5;
                            CUtoDP_5_s3.regFileWriteDataSel_s5 <= CUtoDP_5_s2.regFileWriteDataSel_s5;

                        end if;

                        if ((encType_prev1 = ENC_J and stallDmemAccess = true) or (flush = true and (stallDmemAccess = true or dmemAccess = true))) then
                            flushDmemAccess <= true;
                        else
                            flushDmemAccess <= false;
                        end if;

                        if ((CUtoDP_4_s4.dmemReq_s4 = ME_RD or CUtoDP_4_s4.dmemReq_s4 = ME_WR) and (not (stallDmemAccess = true))) then
                            stallDmemAccess <= true;
                        else
                            stallDmemAccess <= false;
                        end if;

                        encType_prev3   <= encType_prev2;
                        regRdAddr_prev3 <= regRdAddr_prev2;
                        encType_prev2   <= encType_prev1;
                        regRdAddr_prev2 <= regRdAddr_prev1;

                        ------------------ SETTING NEXT MEM ACCESS ------------------

                        if (stallDmemAccess = true) then

                            CUtoME_port.req <= DPtoCU_port.req;
                            CUtoME_port.mask <= DPtoCU_port.mask;
                            CUtoME_port.addrIn <= DPtoCU_port.addrIn;
                            CUtoME_port.dataIn <= DPtoCU_port.dataIn;

                        else

                            CUtoME_port.req <= ME_RD;
                            CUtoME_port.mask <= MT_W;

                            if (not (currStall = true)) then
                                CUtoME_port.addrIn <= currPCvalue;
                            else
                                CUtoME_port.addrIn <= pc;
                            end if;

                            CUtoME_port.dataIn <= (others => '0');

                        end if;

                        MEtoCU_port_notify <= false;
                        CUtoME_port_notify <= true;
                        CUtoDP_port_notify <= true;
                        section <= writeMem;

                    else

                        MEtoCU_port_notify <= true;
                        CUtoME_port_notify <= false;
                        CUtoDP_port_notify <= false;

                    end if;

                end if;

            end if; -- RST

        end if; -- CLK

    end process;

end Control_unit_arch;
