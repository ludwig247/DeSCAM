--
-- Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 30.11.18
--

library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

package env_model_types is
-- constants for SyscallHandler
constant SYS_exit  							: unsigned (31 downto 0) := to_unsigned(93,32);
constant SYS_write  						: unsigned (31 downto 0) := to_unsigned(64,32);
-- constants for Memory Mapping
constant CLINT_START_ADDR					: unsigned (31 downto 0) := X"02000000";
constant CLINT_END_ADDR						: unsigned (31 downto 0) := X"0200FFFF";
constant CLINT_msip_ADDR					: unsigned (31 downto 0) := X"02000000";
constant CLINT_mtimecmp_ADDR				: unsigned (31 downto 0) := X"02004000";
constant CLINT_mtime_ADDR					: unsigned (31 downto 0) := X"0200BFF8";

constant PLIC_START_ADDR					: unsigned (31 downto 0) := X"0C000000";
constant PLIC_END_ADDR						: unsigned (31 downto 0) := X"0C200008";
constant PLIC_Priority_ADDR					: unsigned (31 downto 0) := X"0C000000";
constant PLIC_Pending_ADDR					: unsigned (31 downto 0) := X"0C001000";
constant PLIC_Interrupt_Enables_ADDR		: unsigned (31 downto 0) := X"0C002000";
constant PLIC_Threshold_ADDR				: unsigned (31 downto 0) := X"0C200000";
constant PLIC_Claim_Complete_ADDR			: unsigned (31 downto 0) := X"0C200004";

constant MEM_DEPTH							: integer := 1024*256;-- 256 KB ram -- 1024*1024*32;
constant MEM_START_ADDR						: unsigned (31 downto 0) := X"00000000";
constant MEM_END_ADDR						: unsigned (31 downto 0) := MEM_START_ADDR + to_unsigned(MEM_DEPTH, 32);

end package env_model_types;
