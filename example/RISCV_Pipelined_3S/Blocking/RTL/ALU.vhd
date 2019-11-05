--
-- CREATED BY: SALAHEDDIN HETALANI (salaheddinhetalani@gmail.com) ON 21 Jan, 2019
--

library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SCAM_Model_types.all;

entity ALU is
    port(
        CUtoAL_port : in  CUtoAL_IF;
        ALtoCU_port : out ALtoCU_IF
    );
end ALU;


architecture ALU_arch of ALU is

begin

    process(CUtoAL_port.aluFunc, CUtoAL_port.aluOp1, CUtoAL_port.aluOp2)

    begin

        if    (CUtoAL_port.aluFunc = ALU_ADD)  then
            ALtoCU_port.aluResult <= CUtoAL_port.aluOp1 + CUtoAL_port.aluOp2;

        elsif (CUtoAL_port.aluFunc = ALU_SUB)  then
            ALtoCU_port.aluResult <= CUtoAL_port.aluOp1 - CUtoAL_port.aluOp2;

        elsif (CUtoAL_port.aluFunc = ALU_AND)  then
            ALtoCU_port.aluResult <= CUtoAL_port.aluOp1 and CUtoAL_port.aluOp2;

        elsif (CUtoAL_port.aluFunc = ALU_OR)   then
            ALtoCU_port.aluResult <= CUtoAL_port.aluOp1 or CUtoAL_port.aluOp2;

        elsif (CUtoAL_port.aluFunc = ALU_XOR)  then
            ALtoCU_port.aluResult <= CUtoAL_port.aluOp1 xor CUtoAL_port.aluOp2;

        elsif (CUtoAL_port.aluFunc = ALU_SLT)  then

            if (signed(CUtoAL_port.aluOp1) < signed(CUtoAL_port.aluOp2)) then
                ALtoCU_port.aluResult <= to_unsigned(1, 32);
            else
                ALtoCU_port.aluResult <= (others => '0');
            end if;

        elsif (CUtoAL_port.aluFunc = ALU_SLTU)  then

            if (CUtoAL_port.aluOp1 < CUtoAL_port.aluOp2) then
                ALtoCU_port.aluResult <= to_unsigned(1, 32);
            else
                ALtoCU_port.aluResult <= (others => '0');
            end if;

        elsif (CUtoAL_port.aluFunc = ALU_SLL)   then
            ALtoCU_port.aluResult <= shift_left(CUtoAL_port.aluOp1, to_integer(CUtoAL_port.aluOp2 and to_unsigned(31, 32)));

        elsif (CUtoAL_port.aluFunc = ALU_SRA)   then
            ALtoCU_port.aluResult <= unsigned(shift_right(signed(CUtoAL_port.aluOp1), to_integer(CUtoAL_port.aluOp2 and to_unsigned(31, 32))));

        elsif (CUtoAL_port.aluFunc = ALU_SRL)   then
            ALtoCU_port.aluResult <= shift_right(CUtoAL_port.aluOp1, to_integer(CUtoAL_port.aluOp2 and to_unsigned(31, 32)));

        elsif (CUtoAL_port.aluFunc = ALU_COPY1) then
            ALtoCU_port.aluResult <= CUtoAL_port.aluOp1;

        else
            ALtoCU_port.aluResult <= (others => '0');
        end if;

    end process;

end ALU_arch;
