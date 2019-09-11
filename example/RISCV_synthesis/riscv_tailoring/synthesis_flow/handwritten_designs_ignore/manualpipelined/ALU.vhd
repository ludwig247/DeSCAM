--
-- CREATED BY: SALAHEDDIN HETALANI (salaheddinhetalani@gmail.com) ON 23 OCT, 2018
--

library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SCAM_Model_types.all;

entity ALU is
    port(
        DPtoAL_port_sig : in  DPtoAL_IF;
        ALtoDP_port_sig : out ALtoDP_IF
    );
end ALU;


architecture ALU_arch of ALU is

begin

    process(DPtoAL_port_sig.aluFunc, DPtoAL_port_sig.aluOp1, DPtoAL_port_sig.aluOp2)

    begin

        if    (DPtoAL_port_sig.aluFunc = ALU_ADD)  then
            ALtoDP_port_sig.aluResult <= DPtoAL_port_sig.aluOp1 + DPtoAL_port_sig.aluOp2;

        elsif (DPtoAL_port_sig.aluFunc = ALU_SUB)  then
            ALtoDP_port_sig.aluResult <= DPtoAL_port_sig.aluOp1 - DPtoAL_port_sig.aluOp2;

        elsif (DPtoAL_port_sig.aluFunc = ALU_AND)  then
            ALtoDP_port_sig.aluResult <= DPtoAL_port_sig.aluOp1 and DPtoAL_port_sig.aluOp2;

        elsif (DPtoAL_port_sig.aluFunc = ALU_OR)   then
            ALtoDP_port_sig.aluResult <= DPtoAL_port_sig.aluOp1 or DPtoAL_port_sig.aluOp2;

        elsif (DPtoAL_port_sig.aluFunc = ALU_XOR)  then
            ALtoDP_port_sig.aluResult <= DPtoAL_port_sig.aluOp1 xor DPtoAL_port_sig.aluOp2;

        elsif (DPtoAL_port_sig.aluFunc = ALU_SLT)  then

            if (signed(DPtoAL_port_sig.aluOp1) < signed(DPtoAL_port_sig.aluOp2)) then
                ALtoDP_port_sig.aluResult <= to_unsigned(1, 32);
            else
                ALtoDP_port_sig.aluResult <= (others => '0');
            end if;

        elsif (DPtoAL_port_sig.aluFunc = ALU_SLTU)  then

            if (DPtoAL_port_sig.aluOp1 < DPtoAL_port_sig.aluOp2) then
                ALtoDP_port_sig.aluResult <= to_unsigned(1, 32);
            else
                ALtoDP_port_sig.aluResult <= (others => '0');
            end if;

        elsif (DPtoAL_port_sig.aluFunc = ALU_SLL)   then
            ALtoDP_port_sig.aluResult <= shift_left(DPtoAL_port_sig.aluOp1, to_integer(DPtoAL_port_sig.aluOp2 and to_unsigned(31, 32)));

        elsif (DPtoAL_port_sig.aluFunc = ALU_SRA)   then
            ALtoDP_port_sig.aluResult <= unsigned(shift_right(signed(DPtoAL_port_sig.aluOp1), to_integer(DPtoAL_port_sig.aluOp2 and to_unsigned(31, 32))));

        elsif (DPtoAL_port_sig.aluFunc = ALU_SRL)   then
            ALtoDP_port_sig.aluResult <= shift_right(DPtoAL_port_sig.aluOp1, to_integer(DPtoAL_port_sig.aluOp2 and to_unsigned(31, 32)));

        elsif (DPtoAL_port_sig.aluFunc = ALU_COPY1) then
            ALtoDP_port_sig.aluResult <= DPtoAL_port_sig.aluOp1;

        else
            ALtoDP_port_sig.aluResult <= (others => '0');
        end if;

    end process;

end ALU_arch;
