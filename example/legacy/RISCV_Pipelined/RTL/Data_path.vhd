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
        CUtoDP_port      : in  CUtoDP_IF;
        CUtoDP_port_sync : in  bool;
        DPtoCU_port      : out DPtoCU_IF
    );
end Data_path;


architecture Data_path_arch of Data_path is

    --------------- REGISTER FILE ---------------
    component Register_file is
        port(
            clk              : in  std_logic;
            rst              : in  std_logic;
            DPtoRF_port      : in  DPtoRF_IF;
            DPtoRF_port_sync : in  bool;
            RFtoDP_port      : out RFtoDP_IF
        );
    end component;

    -------------------- ALU --------------------
    component ALU is
        port(
            DPtoAL_port      : in  DPtoAL_IF;
            ALtoDP_port      : out ALtoDP_IF
        );
    end component;

    ------------------ SIGNALS ------------------
    signal DPtoRF_port        : DPtoRF_IF;
    signal DPtoRF_port_notify : bool;
    signal RFtoDP_port        : RFtoDP_IF;
    signal DPtoAL_port : DPtoAL_IF;
    signal ALtoDP_port : ALtoDP_IF;
    signal DP_S3_data : DP_S3;
    signal DP_S4_data : DP_S4;
    signal DP_S5_data : DP_S5;

begin

    --------------- INSTANTIATION ---------------
    RF: Register_file
        port map (
            clk              => clk,
            rst              => rst,
            DPtoRF_port      => DPtoRF_port,
            DPtoRF_port_sync => DPtoRF_port_notify,
            RFtoDP_port      => RFtoDP_port
        );

    AL: ALU
        port map (
            DPtoAL_port      => DPtoAL_port,
            ALtoDP_port      => ALtoDP_port
        );

    ------------------ ID_STAGE ------------------

    DPtoRF_port.rdReq <= CUtoDP_port.regFileReq_s2;
    DPtoRF_port.src1  <= CUtoDP_port.regRs1Addr_s2;
    DPtoRF_port.src2  <= CUtoDP_port.regRs2Addr_s2;

    ------------------ EX_STAGE ------------------

    EX_STAGE: process(CUtoDP_port.aluOp1Sel_s3, DP_S3_data.regRs1Addr_s3, DP_S5_data.regRdAddr_s5, DP_S5_data.encType_s5, DP_S4_data.regRdAddr_s4, CUtoDP_port.loadedData, DP_S4_data.aluResult_s4, DP_S3_data.reg1Content_s3, CUtoDP_port.imm_s3, DP_S3_data.pc_s3, CUtoDP_port.aluOp2Sel_s3, DP_S3_data.regRs2Addr_s3, DP_S3_data.reg2Content_s3, CUtoDP_port.aluFunc_s3)

    begin

        DPtoAL_port.aluFunc <= CUtoDP_port.aluFunc_s3;

        -- EX STAGE FORWARDING: ALU_OP1
        if (CUtoDP_port.aluOp1Sel_s3 = OP_REG) then

            if (DP_S3_data.regRs1Addr_s3 = DP_S5_data.regRdAddr_s5 and DP_S3_data.regRs1Addr_s3 /= 0 and DP_S5_data.encType_s5 = ENC_I_L and DP_S3_data.regRs1Addr_s3 /= DP_S4_data.regRdAddr_s4) then
                DPtoAL_port.aluOp1 <= CUtoDP_port.loadedData;
            elsif (DP_S3_data.regRs1Addr_s3 = DP_S4_data.regRdAddr_s4 and DP_S3_data.regRs1Addr_s3 /= 0) then
                DPtoAL_port.aluOp1 <= DP_S4_data.aluResult_s4;
            else
                DPtoAL_port.aluOp1 <= DP_S3_data.reg1Content_s3;
            end if;

        elsif (CUtoDP_port.aluOp1Sel_s3 = OP_IMM) then
            DPtoAL_port.aluOp1 <= CUtoDP_port.imm_s3;

        elsif (CUtoDP_port.aluOp1Sel_s3 = OP_PC) then
            DPtoAL_port.aluOp1 <= DP_S3_data.pc_s3;

        else
            DPtoAL_port.aluOp1 <= (others => '0');
        end if;

        -- EX STAGE FORWARDING: ALU_OP2
        if (CUtoDP_port.aluOp2Sel_s3 = OP_REG) then

            if (DP_S3_data.regRs2Addr_s3 = DP_S5_data.regRdAddr_s5 and DP_S3_data.regRs2Addr_s3 /= 0 and DP_S5_data.encType_s5 = ENC_I_L and DP_S3_data.regRs2Addr_s3 /= DP_S4_data.regRdAddr_s4) then
                DPtoAL_port.aluOp2 <= CUtoDP_port.loadedData;
            elsif (DP_S3_data.regRs2Addr_s3 = DP_S4_data.regRdAddr_s4 and DP_S3_data.regRs2Addr_s3 /= 0) then
                DPtoAL_port.aluOp2 <= DP_S4_data.aluResult_s4;
            else
                DPtoAL_port.aluOp2 <= DP_S3_data.reg2Content_s3;
            end if;

        elsif (CUtoDP_port.aluOp2Sel_s3 = OP_IMM) then
            DPtoAL_port.aluOp2 <= CUtoDP_port.imm_s3;

        elsif (CUtoDP_port.aluOp2Sel_s3 = OP_PC) then
            DPtoAL_port.aluOp2 <= DP_S3_data.pc_s3;

        else
            DPtoAL_port.aluOp2 <= (others => '0');
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

                DPtoCU_port.reg1Content      <= (others => '0');
                DPtoCU_port.reg2Content      <= (others => '0');
                DPtoCU_port.req              <= ME_X;
                DPtoCU_port.mask             <= MT_X;
                DPtoCU_port.addrIn           <= (others => '0');
                DPtoCU_port.dataIn           <= (others => '0');

                DPtoRF_port.wrReq            <= RF_WR_X;
                DPtoRF_port.dst              <= (others => '0');
                DPtoRF_port.dstData          <= (others => '0');
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
                    if (CUtoDP_port.regRs1Addr_s2 = 0) then
                         reg1Content := (others => '0');

                    elsif (CUtoDP_port.regRs1Addr_s2 = DP_S5_data.regRdAddr_s5 and DP_S5_data.encType_s5 = ENC_I_L and CUtoDP_port.regRs1Addr_s2 /= DP_S4_data.regRdAddr_s4) then
                        reg1Content := CUtoDP_port.loadedData;

                    elsif (CUtoDP_port.regRs1Addr_s2 = DP_S5_data.regRdAddr_s5 and (DP_S5_data.encType_s5 = ENC_I_J or DP_S5_data.encType_s5 = ENC_J)) then
                        reg1Content := DP_S5_data.pc_s5 + 4;

                    elsif (CUtoDP_port.regRs1Addr_s2 = DP_S4_data.regRdAddr_s4 and DP_S4_data.encType_s4 = ENC_J) then
                        reg1Content := DP_S4_data.pc_s4 + 4;

                    elsif (CUtoDP_port.regRs1Addr_s2 = DP_S4_data.regRdAddr_s4) then
                        reg1Content := DP_S4_data.aluResult_s4;

                    elsif (CUtoDP_port.regRs1Addr_s2 = DP_S5_data.regRdAddr_s5) then
                        reg1Content := DP_S5_data.aluResult_s5;

                    else
                        reg1Content := RFtoDP_port.reg1Content;
                    end if;

                    -- ID STAGE FORWARDING: REG_RS2_CONTENT
                    if (CUtoDP_port.regRs2Addr_s2 = 0) then
                        reg2Content := (others => '0');

                    elsif (CUtoDP_port.regRs2Addr_s2 = DP_S5_data.regRdAddr_s5 and DP_S5_data.encType_s5 = ENC_I_L and CUtoDP_port.regRs2Addr_s2 /= DP_S4_data.regRdAddr_s4) then
                        reg2Content := CUtoDP_port.loadedData;

                    elsif (CUtoDP_port.regRs2Addr_s2 = DP_S5_data.regRdAddr_s5 and (DP_S5_data.encType_s5 = ENC_I_J or DP_S5_data.encType_s5 = ENC_J)) then
                        reg2Content := DP_S5_data.pc_s5 + 4;

                    elsif (CUtoDP_port.regRs2Addr_s2 = DP_S4_data.regRdAddr_s4 and DP_S4_data.encType_s4 = ENC_J) then
                        reg2Content := DP_S4_data.pc_s4 + 4;

                    elsif (CUtoDP_port.regRs2Addr_s2 = DP_S4_data.regRdAddr_s4) then
                        reg2Content := DP_S4_data.aluResult_s4;

                    elsif (CUtoDP_port.regRs2Addr_s2 = DP_S5_data.regRdAddr_s5) then
                        reg2Content := DP_S5_data.aluResult_s5;

                    else
                        reg2Content := RFtoDP_port.reg2Content;
                    end if;

                    DPtoCU_port.reg1Content <= reg1Content;
                    DPtoCU_port.reg2Content <= reg2Content;

                    ------------------ ME_STAGE ------------------

                    if (CUtoDP_port.dmemReq_s4 = ME_RD) then

                        DPtoCU_port.req <= CUtoDP_port.dmemReq_s4;
                        DPtoCU_port.mask <= CUtoDP_port.dmemMask_s4;
                        DPtoCU_port.addrIn <= DP_S4_data.aluResult_s4;
                        DPtoCU_port.dataIn <= (others => '0');

                    elsif (CUtoDP_port.dmemReq_s4 = ME_WR) then

                        DPtoCU_port.req <= CUtoDP_port.dmemReq_s4;
                        DPtoCU_port.mask <= CUtoDP_port.dmemMask_s4;
                        DPtoCU_port.addrIn <= DP_S4_data.aluResult_s4;

                        -- ME STAGE FORWARDING: MEM_DATA_IN
                        if (DP_S4_data.regRs2Addr_s4 = DP_S5_data.regRdAddr_s5 and DP_S4_data.regRs2Addr_s4 /= 0 and DP_S5_data.encType_s5 = ENC_I_L) then
                            DPtoCU_port.dataIn <= CUtoDP_port.loadedData;

                        elsif (DP_S4_data.regRs2Addr_s4 = DP_S5_data.regRdAddr_s5 and DP_S4_data.regRs2Addr_s4 /= 0) then
                            DPtoCU_port.dataIn <= DP_S5_data.aluResult_s5;

                        elsif (DP_S4_data.fwdPrevLoadedData) then
                            DPtoCU_port.dataIn <= DP_S4_data.prevLoadedData;

                        else
                            DPtoCU_port.dataIn <= DP_S4_data.reg2Content_s4;
                        end if;

                    else

                        DPtoCU_port.req <= ME_X;
                        DPtoCU_port.mask <= MT_X;
                        DPtoCU_port.addrIn <= (others => '0');
                        DPtoCU_port.dataIn <= (others => '0');

                    end if;

                    if (CUtoDP_port.prevDmemAccess and DP_S3_data.encType_s3 = ENC_S and DP_S5_data.encType_s5 = ENC_I_L and DP_S3_data.regRs2Addr_s3 = DP_S5_data.regRdAddr_s5 and DP_S5_data.regRdAddr_s5 /= 0) then
                        DP_S4_data.fwdPrevLoadedData <= true;
                        DP_S4_data.prevLoadedData <= CUtoDP_port.loadedData;
                    elsif (DP_S4_data.fwdPrevLoadedData = true and CUtoDP_port.stallDmemAccess = true) then
                        DP_S4_data.fwdPrevLoadedData <= true;
                    else
                        DP_S4_data.fwdPrevLoadedData <= false;
                    end if;

                    ------------------ WB_STAGE ------------------

                    if (CUtoDP_port.regFileWriteDataSel_s5 = WB_ALU) then
                        wbData := DP_S5_data.aluResult_s5;
                    elsif (CUtoDP_port.regFileWriteDataSel_s5 = WB_MEM) then
                        wbData := CUtoDP_port.loadedData;
                    elsif (CUtoDP_port.regFileWriteDataSel_s5 = WB_PC4) then
                        wbData := DP_S5_data.pc_s5 + 4;
                    else
                        wbData := (others => '0');
                    end if;

                    DPtoRF_port.wrReq <= CUtoDP_port.regFileReq_s5;
                    DPtoRF_port.dst <= DP_S5_data.regRdAddr_s5;
                    DPtoRF_port.dstData <= wbData; -- (31 downto 0)

                    ------------------ PIPLINE REGISTERS ------------------

                    if (not (CUtoDP_port.stallDmemAccess)) then

                        DP_S3_data.pc_s3 <= CUtoDP_port.pc_s2;
                        DP_S3_data.encType_s3 <= CUtoDP_port.encType_s2;
                        DP_S3_data.regRs1Addr_s3 <= CUtoDP_port.regRs1Addr_s2;
                        DP_S3_data.regRs2Addr_s3 <= CUtoDP_port.regRs2Addr_s2;
                        DP_S3_data.regRdAddr_s3 <= CUtoDP_port.regRdAddr_s2;
                        DP_S3_data.reg1Content_s3 <= reg1Content;
                        DP_S3_data.reg2Content_s3 <= reg2Content;

                        DP_S4_data.pc_s4 <= DP_S3_data.pc_s3;
                        DP_S4_data.encType_s4 <= DP_S3_data.encType_s3;
                        DP_S4_data.regRs2Addr_s4 <= DP_S3_data.regRs2Addr_s3;
                        DP_S4_data.regRdAddr_s4 <= DP_S3_data.regRdAddr_s3;
                        DP_S4_data.reg2Content_s4 <= DP_S3_data.reg2Content_s3;
                        DP_S4_data.aluResult_s4 <= ALtoDP_port.aluResult;

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
