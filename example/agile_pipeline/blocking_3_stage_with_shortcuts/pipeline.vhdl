library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all; 

entity pipeline is
port(	
	b_in1_sig: in signed(31 downto 0);
	b_in2_sig: in signed(31 downto 0);
	b_out_sig: out signed(31 downto 0);
	b_in1_sync: in boolean;
	b_in2_sync: in boolean;
	b_out_sync: in boolean;
	b_in1_notify: out boolean;
	b_in2_notify: out boolean;
	b_out_notify: out boolean;
	clk: in std_logic;
	rst: in std_logic
);
end pipeline;

architecture pipeline_arch of pipeline is

	-- Define internal data types
	type pipeline_state_t is (st_advance, st_stall, st_stall_init);

	signal b_in1_state: pipeline_state_t;
	signal b_in2_state: pipeline_state_t;
	signal b_out_state: pipeline_state_t;
    
    signal stall: boolean;
    signal b_in1_ready: boolean;
    signal b_in2_ready: boolean;
    signal b_out_ready: boolean;
    


begin


	stall <= not(b_in1_ready) or not(b_in2_ready) or not(b_out_ready);

	-- Reading stage (b_in1)
    b_in1_notify <= b_in1_state = st_advance;
    b_in1_ready <= not(b_in1_state = st_advance) or (b_in1_sync and b_in1_state = st_advance);


	process(clk)
	begin
		if(clk='1' and clk'event) then
			if rst = '1' then
				b_in1_state <= st_advance;
			else
				if not(stall) then --all stages ready?
				    --yes, continue pipelining
                    b_in1_state <= st_advance;
				elsif b_in1_sync then
			        --no, perform stall
                    b_in1_state <= st_stall;
				end if;
			end if;
		end if;
	end process;


	-- Reading stage (b_in2)
    b_in2_notify <= b_in2_state = st_advance;
    b_in2_ready <= not(b_in2_state = st_advance) or (b_in2_sync and b_in2_state = st_advance);

	process(clk)
	begin
		if(clk='1' and clk'event) then
			if rst = '1' then
				b_in2_state <= st_stall;
			else
				if not(stall) then --all stages ready?
				    --yes, continue pipelining
                    b_in2_state <= st_advance;
				elsif b_in2_sync then
			        --no, perform stall
                    b_in2_state <= st_stall;
				end if;
			end if;
		end if;
	end process;




	-- Writing stage (b_out)
    b_out_notify <= b_out_state = st_advance;
    b_out_ready <= not(b_out_state = st_advance) or (b_out_sync and b_out_state = st_advance);
	
	process(clk)
	begin
		if(clk='1' and clk'event) then
			if rst = '1' then
				b_out_state <= st_stall_init;
			else
				if not(stall) then --all stages ready?
					--yes, continue pipelining
				    if b_out_state = st_stall_init then
				    	b_out_state <= st_stall;
				    else
                    	b_out_state <= st_advance;
                    end if;
				elsif b_out_sync then
					--no, perform stall
			        if b_out_state = st_advance then
                    	b_out_state <= st_stall;
                    end if;
				end if;
			end if;
		end if;
	end process;
	
end pipeline_arch;