library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.SCAM_Model_types.all;
use work.GlobalLocal_types.all;

entity GlobalLocal is
port(	
	clk:		in std_logic;
	rst:		in std_logic;
	b_in:		in int;
	b_in_sync:		in bool;
	b_in_notify:		out bool;
	b_out:		out int;
	b_out_sync:		in bool;
	b_out_notify:		out bool
);
end GlobalLocal;

architecture GlobalLocal_arch of GlobalLocal is
	signal bool_var_signal: bool;
	signal gct_signal: global_compound_type;
	signal ge_signal: global_enum;
	signal gec_signal: global_enum_class;
	signal int_var_signal: int;
	signal lct_signal: local_compound_type;
	signal le_signal: local_enum;
	signal lec_signal: local_enum_class;
	signal local_array_signal: int_5;

begin
	process(clk)
	begin
	if(clk='1' and clk'event) then
		if rst = '1' then
			bool_var_signal <= false;
			gct_signal.b <= false;
			gct_signal.w <= to_unsigned(0, 32);
			ge_signal <= A;
			gec_signal <= M;
			int_var_signal <= to_signed(0, 32);
			lct_signal.fest <= A;
			lct_signal.x <= to_signed(0, 32);
			lct_signal.y <= false;
			le_signal <= X;
			lec_signal <= D;
			local_array_signal <= (others => to_signed(0, 32));
			b_in_notify <= true;
			b_out_notify <= false;
		else
			 -- FILL OUT HERE;
		end if;
	end if;
	end process;
end GlobalLocal_arch;