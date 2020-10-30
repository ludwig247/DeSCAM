--
-- Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 01.12.18
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SCAM_Model_types.all;

entity PLIC_Gateway is
	port(
		clk						: in  std_logic;
		rst						: in  std_logic;

		--  slave_in<bool> IntSig
		IntSig		: in bool;
		IntSig_sync	: in bool;


		--  slave_out<bool> IntReq
		IntReq			: out bool;
		IntReq_notify	: out bool;

		--  slave_in<bool> fromMemoryPending
		fromMemoryPending		: in bool;
		fromMemoryPending_sync	: in bool
	);
end PLIC_Gateway;

architecture PLIC_Gateway_arch of PLIC_Gateway is

	signal int_allowed		: bool;
	signal int_counter		: signed (31 downto 0);

begin

	process(clk)

		variable int_allowed_temp	: bool;
		variable int_counter_temp	: signed (31 downto 0);

		begin
			if(clk='1' and clk'event) then
				if rst = '1' then
					int_allowed <= true;
					int_counter <= (others => '0');
					--IntReq <= false;
					IntReq_notify <= false;

				else

					int_allowed_temp := int_allowed;
					int_counter_temp := int_counter;


					if (fromMemoryPending_sync = true)  and (fromMemoryPending = true) then
						int_allowed_temp := true;
						if (int_counter_temp > to_signed(0,32)) then
							int_counter_temp := int_counter_temp - 1;
						end if;
					end if;


					if (IntSig_sync = true) and (IntSig = true) then
						int_counter_temp := int_counter_temp + 1;
					end if;


					if (int_counter_temp > to_signed(0,32)) and (int_allowed_temp = true) then
						IntReq <= true;
						IntReq_notify <= true;
						int_allowed_temp := false;
					else
						-- IntReq <= false;
						IntReq_notify <= false;
					end if;

					int_allowed <= int_allowed_temp;
					int_counter <= int_counter_temp;

				end if; -- RST
			end if; -- CLK
	end process;
end PLIC_Gateway_arch;
