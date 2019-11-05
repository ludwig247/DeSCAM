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
	type Example_operation_t is (op_frame_data_0_read_0, op_frame_start_2_write_3, op_frame_start_2_write_4, op_idle_5_read_8, op_wait_idle_5, op_idle_5_read_9, op_frame_data_0_read_1, op_frame_data_0_read_2);
	type Example_state_t is (st_frame_data_0, st_frame_start_2, st_idle_5);

	-- Declare signals
	signal active_state: Example_state_t;
	signal active_operation: Example_operation_t;
	signal cnt: signed(31 downto 0);
	signal msg: msg_t;

	-- Declare state signals that are used by ITL properties for OneSpin
	signal frame_data_0: boolean;
	signal frame_start_2: boolean;
	signal frame_start_3: boolean;
	signal frame_start_4: boolean;
	signal idle_5: boolean;


begin
	-- Combinational logic that selects current operation
	process (active_state, b_in_sync, b_in_sig.status, cnt)
	begin
		case active_state is
		when st_frame_data_0 =>
			if (b_in_sync and b_in_sync) then 
				active_operation <= op_frame_data_0_read_0;
			elsif (not(cnt = x"00000000") and not(b_in_sync)) then 
				active_operation <= op_frame_data_0_read_1;
			else--if((cnt = x"00000000") and not(b_in_sync)) then 
				active_operation <= op_frame_data_0_read_2;
			end if;
		when st_frame_start_2 =>
			if ((cnt = x"00000001")) then 
				active_operation <= op_frame_start_2_write_3;
			else
				active_operation <= op_frame_start_2_write_4;
			end if;
		when st_idle_5 =>
			if ((b_in_sig.status = in_frame) and b_in_sync) then 
				active_operation <= op_idle_5_read_8;
			elsif (not(b_in_sync)) then 
				active_operation <= op_wait_idle_5;
			else--if(not(b_in_sig.status = in_frame) and b_in_sync) then 
				active_operation <= op_idle_5_read_9;
			end if;
		end case;
	end process;

	-- Main process
	process (clk, rst)
	begin
		if (rst = '1') then
			m_out_notify <= false;
			b_in_notify <= true;
			msg.data <= x"00000000";
			cnt <= x"00000000";
			active_state <= st_idle_5;
			s_out_sig <= false;
		elsif (clk = '1' and clk'event) then
			case active_operation is
			when op_frame_data_0_read_0 =>
				m_out_notify <= false;
				b_in_notify <= true;
				active_state <= st_frame_data_0;
				msg.data <= b_in_sig.data;
			when op_frame_start_2_write_3 =>
				m_out_notify <= false;
				b_in_notify <= true;
				active_state <= st_frame_data_0;
				cnt <= x"0000000f";
			when op_frame_start_2_write_4 =>
				m_out_sig <= x"ffffffff" + cnt;
				b_in_notify <= false;
				active_state <= st_frame_start_2;
				cnt <= x"ffffffff" + cnt;
				m_out_notify <= true;
			when op_idle_5_read_8 =>
				m_out_sig <= x"00000003";
				cnt <= x"00000003";
				s_out_sig <= true;
				msg.data <= b_in_sig.data;
				b_in_notify <= false;
				active_state <= st_frame_start_2;
				m_out_notify <= true;
			when op_wait_idle_5 =>
				m_out_notify <= false;
				b_in_notify <= true;
				active_state <= st_idle_5;
			when op_idle_5_read_9 =>
				m_out_notify <= false;
				b_in_notify <= true;
				msg.data <= b_in_sig.data;
				active_state <= st_idle_5;
				s_out_sig <= false;
			when op_frame_data_0_read_1 =>
				b_in_notify <= true;
				active_state <= st_frame_data_0;
				m_out_sig <= msg.data;
				cnt <= x"ffffffff" + cnt;
				m_out_notify <= true;
			when op_frame_data_0_read_2 =>
				b_in_notify <= true;
				m_out_sig <= msg.data;
				active_state <= st_idle_5;
				cnt <= x"ffffffff" + cnt;
				m_out_notify <= true;
				s_out_sig <= false;
			end case;
		end if;
	end process;

	-- Assigning state signals that are used by ITL properties for OneSpin
	frame_data_0 <= active_state = st_frame_data_0;
	frame_start_2 <= active_state = st_frame_start_2;
	frame_start_3 <= false;
	frame_start_4 <= false;
	idle_5 <= active_state = st_idle_5;

end Example_arch;

