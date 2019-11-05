library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 


entity pipeline is
port(	
	m_in_sig: in signed(31 downto 0);
	m_out1_sig: out signed(31 downto 0);
	m_out2_sig: out signed(31 downto 0);
	m_out1_notify: out boolean;
	m_out2_notify: out boolean;
	clk: in std_logic;
	rst: in std_logic
);
end pipeline;




architecture pipeline_arch of pipeline is

    type states is (run, stall);

	signal m_out2_state: states;

    signal x: signed(31 downto 0);

begin
    
	process(clk)
	begin
		if(clk='1' and clk'event) then
			if rst = '1' then
				x <= (others => '0');
			else
				x <= m_in_sig;
			end if;
		end if;
	end process;

	process(clk)
	begin
		if(clk='1' and clk'event) then
			if rst = '1' then
				m_out1_notify <= false;
			else
				m_out1_sig <= m_in_sig;
				m_out1_notify <= true;
			end if;
		end if;
	end process;

	process(clk)
	begin
		if(clk='1' and clk'event) then
			if rst = '1' then
				m_out2_notify <= false;
				m_out2_state <= stall;
			else
				if m_out2_state = stall then 
					m_out2_state <= run;
				end if;

				if m_out2_state = run then 
					m_out2_notify <= true;
					if (x > 0) then
						m_out2_sig <= x;
					else
						m_out2_sig <= to_signed(1,32);
					end if;
				end if;
			end if;
		end if;
	end process;
	
end pipeline_arch;