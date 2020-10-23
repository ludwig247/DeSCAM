--
-- CREATED BY: SALAHEDDIN HETALANI (salaheddinhetalani@gmail.com) ON 23 OCT, 2018
--

library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SCAM_Model_types.all;

entity Data_path is
    port(
        clk              : in  std_logic;
        rst              : in  std_logic;
        CUtoDP_port_sig      : in  CUtoDP_IF;
        CUtoDP_port_sync : in  bool;
        DPtoCU_port_sig      : out DPtoCU_IF
    );
end Data_path;


architecture Data_path_arch of Data_path is

    --------------- REGISTER FILE ---------------
    component Register_file is
        port(
            clk              : in  std_logic;
            rst              : in  std_logic;
            DPtoRF_port_sig      : in  DPtoRF_IF;
            DPtoRF_port_sync : in  bool;
            RFtoDP_port_sig      : out RFtoDP_IF
        );
    end component;

    -------------------- ALU --------------------
    component ALU is
        port(
            DPtoAL_port_sig      : in  DPtoAL_IF;
            ALtoDP_port_sig      : out ALtoDP_IF
        );
    end component;

    ------------------ SIGNALS ------------------
    signal DPtoRF_port_sig        : DPtoRF_IF;
    signal DPtoRF_port_notify : bool;
    signal RFtoDP_port_sig        : RFtoDP_IF;
    signal DPtoAL_port_sig : DPtoAL_IF;
    signal ALtoDP_port_sig : ALtoDP_IF;
    signal DP_S3_data : DP_S3;
    signal DP_S4_data : DP_S4;
    signal DP_S5_data : DP_S5;

begin

    --------------- INSTANTIATION ---------------
    RF: Register_file
        port map (
            clk              => clk,
            rst              => rst,
            DPtoRF_port_sig      => DPtoRF_port_sig,
            DPtoRF_port_sync => DPtoRF_port_notify,
            RFtoDP_port_sig      => RFtoDP_port_sig
        );

    AL: ALU
        port map (
            DPtoAL_port_sig      => DPtoAL_port_sig,
            ALtoDP_port_sig      => ALtoDP_port_sig
        );

    ------------------ ID_STAGE ------------------

    DPtoRF_port_sig.rdReq <= CUtoDP_port_sig.regFileReq_s2;
    DPtoRF_port_sig.src1  <= CUtoDP_port_sig.regRs1Addr_s2;
    DPtoRF_port_sig.src2  <= CUtoDP_port_sig.regRs2Addr_s2;

    ------------------ EX_STAGE ------------------

    EX_STAGE: process(CUtoDP_port_sig.aluOp1Sel_s3, DP_S3_data.regRs1Addr_s3, DP_S5_data.regRdAddr_s5, DP_S5_data.encType_s5, DP_S4_data.regRdAddr_s4, CUtoDP_port_sig.loadedData, DP_S4_data.aluResult_s4, DP_S3_data.reg1Content_s3, CUtoDP_port_sig.imm_s3, DP_S3_data.pc_s3, CUtoDP_port_sig.aluOp2Sel_s3, DP_S3_data.regRs2Addr_s3, DP_S3_data.reg2Content_s3, CUtoDP_port_sig.aluFunc_s3)

    begin

        DPtoAL_port_sig.aluFunc <= CUtoDP_port_sig.aluFunc_s3;

        -- EX STAGE FORWARDING: ALU_OP1
        if (CUtoDP_port_sig.aluOp1Sel_s3 = OP_REG) then

            if (DP_S3_data.regRs1Addr_s3 = DP_S5_data.regRdAddr_s5 and DP_S3_data.regRs1Addr_s3 /= 0 and DP_S5_data.encType_s5 = ENC_I_L and DP_S3_data.regRs1Addr_s3 /= DP_S4_data.regRdAddr_s4) then
                DPtoAL_port_sig.aluOp1 <= CUtoDP_port_sig.loadedData;
            elsif (DP_S3_data.regRs1Addr_s3 = DP_S4_data.regRdAddr_s4 and DP_S3_data.regRs1Addr_s3 /= 0) then
                DPtoAL_port_sig.aluOp1 <= DP_S4_data.aluResult_s4;
            else
                DPtoAL_port_sig.aluOp1 <= DP_S3_data.reg1Content_s3;
            end if;

        elsif (CUtoDP_port_sig.aluOp1Sel_s3 = OP_IMM) then
            DPtoAL_port_sig.aluOp1 <= CUtoDP_port_sig.imm_s3;

        elsif (CUtoDP_port_sig.aluOp1Sel_s3 = OP_PC) then
            DPtoAL_port_sig.aluOp1 <= DP_S3_data.pc_s3;

        else
            DPtoAL_port_sig.aluOp1 <= (others => '0');
        end if;

        -- EX STAGE FORWARDING: ALU_OP2
        if (CUtoDP_port_sig.aluOp2Sel_s3 = OP_REG) then

            if (DP_S3_data.regRs2Addr_s3 = DP_S5_data.regRdAddr_s5 and DP_S3_data.regRs2Addr_s3 /= 0 and DP_S5_data.encType_s5 = ENC_I_L and DP_S3_data.regRs2Addr_s3 /= DP_S4_data.regRdAddr_s4) then
                DPtoAL_port_sig.aluOp2 <= CUtoDP_port_sig.loadedData;
            elsif (DP_S3_data.regRs2Addr_s3 = DP_S4_data.regRdAddr_s4 and DP_S3_data.regRs2Addr_s3 /= 0) then
                DPtoAL_port_sig.aluOp2 <= DP_S4_data.aluResult_s4;
            else
                DPtoAL_port_sig.aluOp2 <= DP_S3_data.reg2Content_s3;
            end if;

        elsif (CUtoDP_port_sig.aluOp2Sel_s3 = OP_IMM) then
            DPtoAL_port_sig.aluOp2 <= CUtoDP_port_sig.imm_s3;

        elsif (CUtoDP_port_sig.aluOp2Sel_s3 = OP_PC) then
            DPtoAL_port_sig.aluOp2 <= DP_S3_data.pc_s3;

        else
            DPtoAL_port_sig.aluOp2 <= (others => '0');
        end if;

    end process;


    process(clk)

        variable reg1Content : Unsigned (31 downto 0);
        variable reg2Content : Unsigned (31 downto 0);
        variable wbData      : Unsigned (31 downto 0);
	 
    begin

        if (clk='1' and clk'event) then
            -- RESET SEQUENCE
            if rst = '1' then

                DPtoCU_port_sig.reg1Content      <= (others => '0');
                DPtoCU_port_sig.reg2Content      <= (others => '0');
                DPtoCU_port_sig.req              <= ME_X;
                DPtoCU_port_sig.mask             <= MT_X;
                DPtoCU_port_sig.addrIn           <= (others => '0');
                DPtoCU_port_sig.dataIn           <= (others => '0');

                DPtoRF_port_sig.wrReq            <= RF_WR_X;
                DPtoRF_port_sig.dst              <= (others => '0');
                DPtoRF_port_sig.dstData          <= (others => '0');
                DPtoRF_port_notify           <= false;

                DP_S3_data.pc_s3             <= (others => '0');
                DP_S3_data.encType_s3        <= ENC_I_I;
                DP_S3_data.regRs1Addr_s3     <= (others => '0');
                DP_S3_data.regRs2Addr_s3     <= (others => '0');
                DP_S3_data.regRdAddr_s3      <= (others => '0');
                DP_S3_data.reg1Content_s3    <= (others => '0');
                DP_S3_data.reg2Content_s3    <= (others => '0');

                DP_S4_data.fwdPrevLoadedData <= false;
                DP_S4_data.prevLoadedData    <= (others => '0');
                DP_S4_data.pc_s4             <= (others => '0');
                DP_S4_data.encType_s4        <= ENC_I_I;
                DP_S4_data.regRs2Addr_s4     <= (others => '0');
                DP_S4_data.regRdAddr_s4      <= (others => '0');
                DP_S4_data.reg2Content_s4    <= (others => '0');
                DP_S4_data.aluResult_s4      <= (others => '0');

                DP_S5_data.pc_s5             <= (others => '0');
                DP_S5_data.encType_s5        <= ENC_I_I;
                DP_S5_data.regRdAddr_s5      <= (others => '0');
                DP_S5_data.aluResult_s5      <= (others => '0');

                reg1Content                  := (others => '0');
                reg2Content                  := (others => '0');
                wbData                       := (others => '0');

            else

                if CUtoDP_port_sync = true then

                    reg1Content := (others => '0');
                    reg2Content := (others => '0');
                    wbData      := (others => '0');

                    ------------------ ID_STAGE ------------------

                    -- ID STAGE FORWARDING: REG_RS1_CONTENT
                    if (CUtoDP_port_sig.regRs1Addr_s2 = 0) then
                         reg1Content := (others => '0');

                    elsif (CUtoDP_port_sig.regRs1Addr_s2 = DP_S5_data.regRdAddr_s5 and DP_S5_data.encType_s5 = ENC_I_L and CUtoDP_port_sig.regRs1Addr_s2 /= DP_S4_data.regRdAddr_s4) then
                        reg1Content := CUtoDP_port_sig.loadedData;

                    elsif (CUtoDP_port_sig.regRs1Addr_s2 = DP_S5_data.regRdAddr_s5 and (DP_S5_data.encType_s5 = ENC_I_J or DP_S5_data.encType_s5 = ENC_J)) then
                        reg1Content := DP_S5_data.pc_s5 + 4;

                    elsif (CUtoDP_port_sig.regRs1Addr_s2 = DP_S4_data.regRdAddr_s4 and DP_S4_data.encType_s4 = ENC_J) then
                        reg1Content := DP_S4_data.pc_s4 + 4;

                    elsif (CUtoDP_port_sig.regRs1Addr_s2 = DP_S4_data.regRdAddr_s4) then
                        reg1Content := DP_S4_data.aluResult_s4;

                    elsif (CUtoDP_port_sig.regRs1Addr_s2 = DP_S5_data.regRdAddr_s5) then
                        reg1Content := DP_S5_data.aluResult_s5;

                    else
                        reg1Content := RFtoDP_port_sig.reg1Content;
                    end if;

                    -- ID STAGE FORWARDING: REG_RS2_CONTENT
                    if (CUtoDP_port_sig.regRs2Addr_s2 = 0) then
                        reg2Content := (others => '0');

                    elsif (CUtoDP_port_sig.regRs2Addr_s2 = DP_S5_data.regRdAddr_s5 and DP_S5_data.encType_s5 = ENC_I_L and CUtoDP_port_sig.regRs2Addr_s2 /= DP_S4_data.regRdAddr_s4) then
                        reg2Content := CUtoDP_port_sig.loadedData;

                    elsif (CUtoDP_port_sig.regRs2Addr_s2 = DP_S5_data.regRdAddr_s5 and (DP_S5_data.encType_s5 = ENC_I_J or DP_S5_data.encType_s5 = ENC_J)) then
                        reg2Content := DP_S5_data.pc_s5 + 4;

                    elsif (CUtoDP_port_sig.regRs2Addr_s2 = DP_S4_data.regRdAddr_s4 and DP_S4_data.encType_s4 = ENC_J) then
                        reg2Content := DP_S4_data.pc_s4 + 4;

                    elsif (CUtoDP_port_sig.regRs2Addr_s2 = DP_S4_data.regRdAddr_s4) then
                        reg2Content := DP_S4_data.aluResult_s4;

                    elsif (CUtoDP_port_sig.regRs2Addr_s2 = DP_S5_data.regRdAddr_s5) then
                        reg2Content := DP_S5_data.aluResult_s5;

                    else
                        reg2Content := RFtoDP_port_sig.reg2Content;
                    end if;

                    DPtoCU_port_sig.reg1Content <= reg1Content;
                    DPtoCU_port_sig.reg2Content <= reg2Content;

                    ------------------ ME_STAGE ------------------

                    if (CUtoDP_port_sig.dmemReq_s4 = ME_RD) then

                        DPtoCU_port_sig.req <= CUtoDP_port_sig.dmemReq_s4;
                        DPtoCU_port_sig.mask <= CUtoDP_port_sig.dmemMask_s4;
                        DPtoCU_port_sig.addrIn <= DP_S4_data.aluResult_s4;
                        DPtoCU_port_sig.dataIn <= (others => '0');

                    elsif (CUtoDP_port_sig.dmemReq_s4 = ME_WR) then

                        DPtoCU_port_sig.req <= CUtoDP_port_sig.dmemReq_s4;
                        DPtoCU_port_sig.mask <= CUtoDP_port_sig.dmemMask_s4;
                        DPtoCU_port_sig.addrIn <= DP_S4_data.aluResult_s4;

                        -- ME STAGE FORWARDING: MEM_DATA_IN
                        if (DP_S4_data.regRs2Addr_s4 = DP_S5_data.regRdAddr_s5 and DP_S4_data.regRs2Addr_s4 /= 0 and DP_S5_data.encType_s5 = ENC_I_L) then
                            DPtoCU_port_sig.dataIn <= CUtoDP_port_sig.loadedData;

                        elsif (DP_S4_data.regRs2Addr_s4 = DP_S5_data.regRdAddr_s5 and DP_S4_data.regRs2Addr_s4 /= 0) then
                            DPtoCU_port_sig.dataIn <= DP_S5_data.aluResult_s5;

                        elsif (DP_S4_data.fwdPrevLoadedData) then
                            DPtoCU_port_sig.dataIn <= DP_S4_data.prevLoadedData;

                        else
                            DPtoCU_port_sig.dataIn <= DP_S4_data.reg2Content_s4;
                        end if;

                    else

                        DPtoCU_port_sig.req <= ME_X;
                        DPtoCU_port_sig.mask <= MT_X;
                        DPtoCU_port_sig.addrIn <= (others => '0');
                        DPtoCU_port_sig.dataIn <= (others => '0');

                    end if;

                    if (CUtoDP_port_sig.prevDmemAccess and DP_S3_data.encType_s3 = ENC_S and DP_S5_data.encType_s5 = ENC_I_L and DP_S3_data.regRs2Addr_s3 = DP_S5_data.regRdAddr_s5 and DP_S5_data.regRdAddr_s5 /= 0) then
                        DP_S4_data.fwdPrevLoadedData <= true;
                        DP_S4_data.prevLoadedData <= CUtoDP_port_sig.loadedData;
                    elsif (DP_S4_data.fwdPrevLoadedData = true and CUtoDP_port_sig.stallDmemAccess = true) then
                        DP_S4_data.fwdPrevLoadedData <= true;
                    else
                        DP_S4_data.fwdPrevLoadedData <= false;
                    end if;

                    ------------------ WB_STAGE ------------------

                    if (CUtoDP_port_sig.regFileWriteDataSel_s5 = WB_ALU) then
                        wbData := DP_S5_data.aluResult_s5;
                    elsif (CUtoDP_port_sig.regFileWriteDataSel_s5 = WB_MEM) then
                        wbData := CUtoDP_port_sig.loadedData;
                    elsif (CUtoDP_port_sig.regFileWriteDataSel_s5 = WB_PC4) then
                        wbData := DP_S5_data.pc_s5 + 4;
                    else
                        wbData := (others => '0');
                    end if;

                    DPtoRF_port_sig.wrReq <= CUtoDP_port_sig.regFileReq_s5;
                    DPtoRF_port_sig.dst <= DP_S5_data.regRdAddr_s5;
                    DPtoRF_port_sig.dstData <= wbData; -- (31 downto 0)

                    ------------------ PIPLINE REGISTERS ------------------

                    if (not (CUtoDP_port_sig.stallDmemAccess)) then

                        DP_S3_data.pc_s3 <= CUtoDP_port_sig.pc_s2;
                        DP_S3_data.encType_s3 <= CUtoDP_port_sig.encType_s2;
                        DP_S3_data.regRs1Addr_s3 <= CUtoDP_port_sig.regRs1Addr_s2;
                        DP_S3_data.regRs2Addr_s3 <= CUtoDP_port_sig.regRs2Addr_s2;
                        DP_S3_data.regRdAddr_s3 <= CUtoDP_port_sig.regRdAddr_s2;
                        DP_S3_data.reg1Content_s3 <= reg1Content;
                        DP_S3_data.reg2Content_s3 <= reg2Content;

                        DP_S4_data.pc_s4 <= DP_S3_data.pc_s3;
                        DP_S4_data.encType_s4 <= DP_S3_data.encType_s3;
                        DP_S4_data.regRs2Addr_s4 <= DP_S3_data.regRs2Addr_s3;
                        DP_S4_data.regRdAddr_s4 <= DP_S3_data.regRdAddr_s3;
                        DP_S4_data.reg2Content_s4 <= DP_S3_data.reg2Content_s3;
                        DP_S4_data.aluResult_s4 <= ALtoDP_port_sig.aluResult;

                        DP_S5_data.pc_s5 <= DP_S4_data.pc_s4;
                        DP_S5_data.encType_s5 <= DP_S4_data.encType_s4;
                        DP_S5_data.regRdAddr_s5 <= DP_S4_data.regRdAddr_s4;
                        DP_S5_data.aluResult_s5 <= DP_S4_data.aluResult_s4;

                    end if;

                    DPtoRF_port_notify <= true;

                else

                    DPtoRF_port_notify <= false;

                end if;

            end if; -- RST

        end if; -- CLK

    end process;

end Data_path_arch;
