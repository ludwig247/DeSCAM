--
-- Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 30.11.18
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;

package testBench_Signals_pkg is

signal Breaking_sig : bool ; -- refers to ISA/sysRES

signal printSync_sig : bool ; -- refers to SYScallHandler/fromMemoryPort_sync
signal printValue_sig : unsigned (31 downto 0) := X"00000000"; -- refers to SYScallHandler/fromMemoryPort

end testBench_Signals_pkg;
