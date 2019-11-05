library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.SCAM_Model_types.all;

entity Example is
port(
	clk:		in std_logic;
	rst:		in std_logic;
	data_in:	in signed(0 downto 0);
	b_in_sync:	 in bool;
	b_in_notify:	 out bool;
	m_out:		out int;
	m_out_notify:	 out bool;
	s_out:		out bool
	 );
end Example;

architecture Example_arch of Example is
	function status(data : signed(3 downto 0))
		      return status_t is
	begin
	  if data = -1  then
	    return in_frame;
	  else
	    return oof_frame;
	  end if;
	end status;

	signal section: Example_SECTIONS;
	signal cnt_signal:int;
	signal msg_signal:msg_t;
	signal msg_data_buffer:signed(31 downto 0);
	signal buffer_cnt: int;

begin	
control: process(clk)
 begin
	 if(clk='1' and clk'event) then
		 if rst = '1' then
			section <=idle;
			cnt_signal<= 0;
			msg_signal.status<=in_frame;
			s_out <= false;
			b_in_notify <= true;
			m_out_notify <= false;
			buffer_cnt <= 0;
			msg_signal.data<= to_signed(0,32);
		 else	
		 --SECTION IDLE
		 	if section = idle then
			m_out_notify <= false;
			if(buffer_cnt = 0) then 
				--START OF BUFFERING
				b_in_notify <=true;
				if(b_in_sync) then
					 -- START OF FRAME?
					msg_signal.status <= status(msg_data_buffer(3 downto 0));
					b_in_notify <= false;
					buffer_cnt <=1;
				end if;
			elsif(buffer_cnt = 31) then
				--END OF BUFFERING
				buffer_cnt <= 0;
				msg_signal.data <= msg_data_buffer(30 downto 0) & data_in;
				if(msg_signal.status = in_frame) then
					section <= frame_start;
					m_out <= 3;
					s_out <= true;
					cnt_signal <= 3;
					m_out_notify <= true;
				else
					b_in_notify <= true;
				end if;
			else 
				--BUFFERING
				buffer_cnt <= buffer_cnt +1;
			end if;
		 end if;
		 -- SECTION FRAME START
		 if section = frame_start then
			 if(cnt_signal /= 1) then
				cnt_signal <= cnt_signal-1;
				m_out <= cnt_signal-1;
				m_out_notify <= true;
			 else
				cnt_signal <= 15;
				section <= frame_data;
				b_in_notify <= true;
				m_out_notify <= false;
			 end if;
		 end if;
		-- SECTION FRAME DATA
		 if section = frame_data then
			  if(buffer_cnt = 0) then
				if(b_in_sync) then 
					msg_signal.status <= status(msg_data_buffer(3 downto 0));
					m_out_notify <= false;
					b_in_notify <= false;
					buffer_cnt <= 1;
				else 
					m_out_notify <= true;
					b_in_notify <= true;
					m_out <= to_integer(msg_signal.data);
					cnt_signal <= cnt_signal -1;
					if(cnt_signal /= 0) then
						m_out <= to_integer(msg_signal.data);
					else
						section <= idle;
						s_out <= false;
					end if;
				end if;
			  elsif(buffer_cnt = 31) then
				b_in_notify <= true;
				msg_signal.data <= msg_data_buffer(30 downto 0) & data_in;
				buffer_cnt <= 0;
			 else 
				buffer_cnt <= buffer_cnt + 1;
			 end if;
		
		 end if;
		 end if;
	 end if;
	 end process;

data_buffer: process(clk)
 begin
	 if(clk='1' and clk'event) then
		 if rst = '1' then
			msg_data_buffer<= to_signed(0,32);
		 else 	
			 -- BUFFERING OF DATA
			 msg_data_buffer(0 downto 0) <= data_in;
			 msg_data_buffer(31 downto 1) <= msg_data_buffer(30 downto 0);
		end if;
	 end if;
 end process;
end Example_arch;
