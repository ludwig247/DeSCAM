--
-- CREATED BY: SALAHEDDIN HETALANI (salaheddinhetalani@gmail.com) ON 21 Jan, 2019
--

library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SCAM_Model_types.all;

entity Register_file is
    port(
        clk              : in  std_logic;
        rst              : in  std_logic;
        CUtoRF_port      : in  CUtoRF_IF;
        CUtoRF_port_sync : in  bool;
        RFtoCU_port      : out RFtoCU_IF
    );
end Register_file;


architecture Register_file_arch of Register_file is

    type register_file is array (0 to 31) of Unsigned (31 downto 0);

    signal reg_file : register_file;

begin

    process(CUtoRF_port.src1, CUtoRF_port.src2, reg_file)

    begin
        -- READ REGISTER 1
        if (CUtoRF_port.src1 = 0) then
            RFtoCU_port.reg1Content <= (others => '0');
        else
            RFtoCU_port.reg1Content <= reg_file(to_integer(CUtoRF_port.src1));
        end if;

        -- READ REGISTER 2
        if (CUtoRF_port.src2 = 0) then
            RFtoCU_port.reg2Content <= (others => '0');
        else
            RFtoCU_port.reg2Content <= reg_file(to_integer(CUtoRF_port.src2));
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
                if CUtoRF_port_sync = true then

                    if (CUtoRF_port.dst /= 0)  then
                        -- PERFORM WRITE
                        reg_file(to_integer(CUtoRF_port.dst)) <= CUtoRF_port.dstData;

                    end if;

                end if;

            end if; -- RST

        end if; -- CLK

    end process;

end Register_file_arch;
