library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SCAM_Model_types.all;

entity Example is
port(	
	b_in_sig: in msg_t;
	b_in_sync: in boolean;
	b_in_notify: out boolean;
	m_out_sig: out signed(31 downto 0);
	m_out_notify: out boolean;
	s_out_sig: out boolean;
	clk: in std_logic;
	rst: in std_logic
);
end Example;

architecture Example_arch of Example is
	-- Define internal data types
	type Example_assign_t is (assign_0, assign_1, assign_2, assign_3, assign_4, assign_5, assign_6, assign_7);
	type Example_state_t is (st_frame_data_0, st_frame_start_2, st_idle_3);

	-- Declare signals
	signal active_state: Example_state_t;
	signal active_assignment: Example_assign_t;
	signal cnt: signed(31 downto 0);
	signal statement: msg_t;

	-- Declare state signals that are used by ITL properties for OneSpin
	signal frame_data_0: boolean;
	signal frame_start_2: boolean;
	signal idle_3: boolean;


begin
	-- Combinational logic that selects current operation
	process (active_state, b_in_sync, b_in_sig.status, cnt)
	begin
		case active_state is
		when st_frame_data_0 =>
			if (b_in_sync and b_in_sync) then 
				-- Operation: op_frame_data_0_read_0;
				active_assignment <= assign_0;
			elsif (not(cnt = x"00000000") and not(b_in_sync)) then 
				-- Operation: op_frame_data_0_read_1;
				active_assignment <= assign_1;
			else--if((cnt = x"00000000") and not(b_in_sync)) then 
				-- Operation: op_frame_data_0_read_2;
				active_assignment <= assign_2;
			end if;
		when st_frame_start_2 =>
			if ((cnt = x"00000001")) then 
				-- Operation: op_frame_start_2_write_3;
				active_assignment <= assign_3;
			else--if(not(cnt = x"00000001")) then 
				-- Operation: op_frame_start_2_write_4;
				active_assignment <= assign_4;
			end if;
		when st_idle_3 =>
			if ((b_in_sig.status = in_frame) and b_in_sync) then 
				-- Operation: op_idle_3_read_5;
				active_assignment <= assign_5;
			elsif (not(b_in_sync)) then 
				-- Operation: op_wait_idle_3;
				active_assignment <= assign_6;
			else--if(not(b_in_sig.status = in_frame) and b_in_sync) then 
				-- Operation: op_idle_3_read_6;
				active_assignment <= assign_7;
			end if;
		end case;
	end process;

	-- Main process
	process (clk, rst)
	begin
		if (rst = '1') then
			s_out_sig <= false;
			statement.data <= x"00000000";
			m_out_notify <= false;
			b_in_notify <= true;
			cnt <= x"00000000";
			active_state <= st_idle_3;
		elsif (clk = '1' and clk'event) then
			case active_assignment is
			when assign_0 =>
				m_out_notify <= false;
				b_in_notify <= true;
				active_state <= st_frame_data_0;
				statement.data <= b_in_sig.data;
			when assign_1 =>
				cnt <= x"ffffffff" + cnt;
				m_out_notify <= true;
				m_out_sig <= statement.data;
				b_in_notify <= true;
				active_state <= st_frame_data_0;
			when assign_2 =>
				cnt <= x"ffffffff" + cnt;
				m_out_notify <= true;
				m_out_sig <= statement.data;
				s_out_sig <= false;
				b_in_notify <= true;
				active_state <= st_idle_3;
			when assign_3 =>
				cnt <= x"0000000f";
				m_out_notify <= false;
				b_in_notify <= true;
				active_state <= st_frame_data_0;
			when assign_4 =>
				cnt <= x"ffffffff" + cnt;
				m_out_notify <= true;
				b_in_notify <= false;
				active_state <= st_frame_start_2;
				m_out_sig <= x"ffffffff" + cnt;
			when assign_5 =>
				m_out_notify <= true;
				b_in_notify <= false;
				active_state <= st_frame_start_2;
				statement.data <= b_in_sig.data;
				cnt <= x"00000003";
				s_out_sig <= true;
				m_out_sig <= x"00000003";
			when assign_6 =>
				m_out_notify <= false;
				b_in_notify <= true;
				active_state <= st_idle_3;
			when assign_7 =>
				s_out_sig <= false;
				m_out_notify <= false;
				b_in_notify <= true;
				statement.data <= b_in_sig.data;
				active_state <= st_idle_3;
			end case;
		end if;
	end process;

	-- Assigning state signals that are used by ITL properties for OneSpin
	frame_data_0 <= active_state = st_frame_data_0;
	frame_start_2 <= active_state = st_frame_start_2;
	idle_3 <= active_state = st_idle_3;

end Example_arch;

