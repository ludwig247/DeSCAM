--
-- CREATED BY: SALAHEDDIN HETALANI (salaheddinhetalani@gmail.com) ON 23 OCT, 2018
--

library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SCAM_Model_types.all;

entity Register_file is
    port(
        clk              : in  std_logic;
        rst              : in  std_logic;
        DPtoRF_port      : in  DPtoRF_IF;
        DPtoRF_port_sync : in  bool;
        RFtoDP_port      : out RFtoDP_IF
    );
end Register_file;


architecture Register_file_arch of Register_file is

    type register_file is array (1 to 31) of Unsigned (31 downto 0);

    signal reg_file : register_file;

begin

    process(DPtoRF_port.rdReq, DPtoRF_port.src1, DPtoRF_port.src2, reg_file)

    begin

        if (DPtoRF_port.rdReq = RF_RD)  then

            -- READ REGISTER 1
            if (DPtoRF_port.src1 = 0) then
                RFtoDP_port.reg1Content <= (others => '0');
            else
                RFtoDP_port.reg1Content <= reg_file(to_integer(DPtoRF_port.src1));
            end if;

            -- READ REGISTER 2
            if (DPtoRF_port.src2 = 0) then
                RFtoDP_port.reg2Content <= (others => '0');
            else
                RFtoDP_port.reg2Content <= reg_file(to_integer(DPtoRF_port.src2));
            end if;

        else

            RFtoDP_port.reg1Content <= (others => '0');
            RFtoDP_port.reg2Content <= (others => '0');

        end if;

    end process;

    process(clk)

    begin

        if (clk='1' and clk'event) then
            -- RESET SEQUENCE
            if rst = '1' then

                reg_file <= (others => (others => '0'));

            else
                -- WRITE REQUESTED
                if DPtoRF_port_sync = true then

                    if (DPtoRF_port.wrReq = RF_WR and DPtoRF_port.dst /= 0)  then
                        -- PERFORM WRITE
                        reg_file(to_integer(DPtoRF_port.dst)) <= DPtoRF_port.dstData;

                    end if;

                end if;

            end if; -- RST

        end if; -- CLK

    end process;

end Register_file_arch;
