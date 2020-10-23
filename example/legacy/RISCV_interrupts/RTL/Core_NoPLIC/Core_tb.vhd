--
-- Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 13.10.18
--

library STD;
use STD.textio.all;
library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_textio.all;
use work.SCAM_Model_types.all;
use work.testBench_Signals_pkg.all;

entity Core_tb is
end Core_tb;


architecture sim of Core_tb is

	--====================================================
	--================ Channels ===================
	--====================================================
		signal clk : std_logic := '0';
		signal rst : std_logic;

	------------------ (Bus_Memory) ------------------
		signal BUS_MEM_Port				: CUtoME_IF;
		signal BUS_MEM_Port_sync		: bool;
		signal BUS_MEM_Port_notify		: bool;

	------------------ (Memory_Bus) ------------------
		signal MEM_BUS_Port				: MEtoCU_IF;
		signal MEM_BUS_Port_sync		: bool;
		signal MEM_BUS_Port_notify		: bool;

	--===================================================
	--======================= Core =======================
	--===================================================
	component Core is
	port(
		clk						: in  std_logic;
		rst						: in  std_logic;

		MEtoCO_port				: in  MEtoCU_IF;
		MEtoCO_port_sync		: in  bool;
		MEtoCO_port_notify		: out bool;

		COtoME_port				: out CUtoME_IF;
		COtoME_port_sync		: in  bool;
		COtoME_port_notify		: out bool
	);
	end component;


	--===================================================
	--======================= Memory =======================
	--===================================================
	component Memory is
	port(
		clk						: in  std_logic;
		rst						: in  std_logic;
		CPUtoMEM_port			: in  CUtoME_IF;
		CPUtoMEM_port_sync		: in  boolean;
		CPUtoMEM_port_notify	: out boolean;
		MEMtoCPU_port			: out MEtoCU_IF;
		MEMtoCPU_port_sync		: in  boolean;
		MEMtoCPU_port_notify	: out boolean
	);
	end component;

begin

    -- Clock
    clk <= not clk  after  10 ns;

    -- Reset
    rst <= '1', '0' after  20 ns;


	IF_Core : Core
	port map (
		clk => clk,
		rst => rst,

		MEtoCO_port => MEM_BUS_Port,
		MEtoCO_port_sync => MEM_BUS_Port_sync,
		MEtoCO_port_notify => MEM_BUS_Port_notify,

		COtoME_port => BUS_MEM_Port,
		COtoME_port_sync => BUS_MEM_Port_sync,
		COtoME_port_notify => BUS_MEM_Port_notify
	);


	IF_Memory : Memory
	port map (
		clk => clk,
		rst => rst,

		CPUtoMEM_port => BUS_MEM_Port,
		CPUtoMEM_port_sync => BUS_MEM_Port_notify,
		CPUtoMEM_port_notify => BUS_MEM_Port_sync,
		MEMtoCPU_port => MEM_BUS_Port,
		MEMtoCPU_port_sync => MEM_BUS_Port_notify,
		MEMtoCPU_port_notify => MEM_BUS_Port_sync
	);


	printer: process (printSync_sig)
		variable my_char : character := ' ';
		variable my_line : line;  -- type 'line' comes from textio
	begin
		if (printSync_sig = true ) then
			my_char := character'val(to_integer(printValue_sig(7 downto 0)));
			if(printValue_sig(7 downto 0) = X"0A") then -- end of line character
				writeline(output, my_line);              -- write to display
			else
				write(my_line, my_char);
			end if;
		end if;
	end process printer;


	stimuli: process
	begin
		wait for 40 ns;
		if (Breaking_sig = true ) then
			wait for 20 ns;
		else
			report "simulation finished successfully" severity FAILURE;
		end if;

	end process stimuli;

end architecture;