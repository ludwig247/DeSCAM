--
-- CREATED BY: SALAHEDDIN HETALANI (salaheddinhetalani@gmail.com) ON 23 OCT, 2018
--

library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SCAM_Model_types.all;

entity ALU is
    port(
        DPtoAL_port : in  DPtoAL_IF;
        ALtoDP_port : out ALtoDP_IF
    );
end ALU;


architecture ALU_arch of ALU is

begin

    process(DPtoAL_port.aluFunc, DPtoAL_port.aluOp1, DPtoAL_port.aluOp2)

    begin

        if    (DPtoAL_port.aluFunc = ALU_ADD)  then
            ALtoDP_port.aluResult <= DPtoAL_port.aluOp1 + DPtoAL_port.aluOp2;

        elsif (DPtoAL_port.aluFunc = ALU_SUB)  then
            ALtoDP_port.aluResult <= DPtoAL_port.aluOp1 - DPtoAL_port.aluOp2;

        elsif (DPtoAL_port.aluFunc = ALU_AND)  then
            ALtoDP_port.aluResult <= DPtoAL_port.aluOp1 and DPtoAL_port.aluOp2;

        elsif (DPtoAL_port.aluFunc = ALU_OR)   then
            ALtoDP_port.aluResult <= DPtoAL_port.aluOp1 or DPtoAL_port.aluOp2;

        elsif (DPtoAL_port.aluFunc = ALU_XOR)  then
            ALtoDP_port.aluResult <= DPtoAL_port.aluOp1 xor DPtoAL_port.aluOp2;

        elsif (DPtoAL_port.aluFunc = ALU_SLT)  then

            if (signed(DPtoAL_port.aluOp1) < signed(DPtoAL_port.aluOp2)) then
                ALtoDP_port.aluResult <= to_unsigned(1, 32);
            else
                ALtoDP_port.aluResult <= (others => '0');
            end if;

        elsif (DPtoAL_port.aluFunc = ALU_SLTU)  then

            if (DPtoAL_port.aluOp1 < DPtoAL_port.aluOp2) then
                ALtoDP_port.aluResult <= to_unsigned(1, 32);
            else
                ALtoDP_port.aluResult <= (others => '0');
            end if;

        elsif (DPtoAL_port.aluFunc = ALU_SLL)   then
            ALtoDP_port.aluResult <= shift_left(DPtoAL_port.aluOp1, to_integer(DPtoAL_port.aluOp2 and to_unsigned(31, 32)));

        elsif (DPtoAL_port.aluFunc = ALU_SRA)   then
            ALtoDP_port.aluResult <= unsigned(shift_right(signed(DPtoAL_port.aluOp1), to_integer(DPtoAL_port.aluOp2 and to_unsigned(31, 32))));

        elsif (DPtoAL_port.aluFunc = ALU_SRL)   then
            ALtoDP_port.aluResult <= shift_right(DPtoAL_port.aluOp1, to_integer(DPtoAL_port.aluOp2 and to_unsigned(31, 32)));

        elsif (DPtoAL_port.aluFunc = ALU_COPY1) then
            ALtoDP_port.aluResult <= DPtoAL_port.aluOp1;

        else
            ALtoDP_port.aluResult <= (others => '0');
        end if;

    end process;

end ALU_arch;
