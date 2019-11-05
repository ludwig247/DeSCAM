library ieee;
use IEEE.numeric_std.all;
use ieee.std_logic_1164.all;

entity pipeline is
port(	
	clk:			in std_logic;
	rst:			in std_logic;
	b_in:			in signed(31 downto 0);
	b_in_sync:	 	in boolean;
	b_in_notify:	out boolean;
	b_out:			out signed(31 downto 0);
	b_out_sync:	 	in boolean;
	b_out_notify:	out boolean);
end pipeline;


architecture pipeline_arch of pipeline is
	type states is (Aw,A,Bw,B);
	signal b_in_state: states;
	signal b_out_state: states;
    
    signal b_in_ready: boolean;
    signal b_out_ready: boolean;
    
    signal b_out_store1: signed(31 downto 0);
    signal b_out_store2: signed(31 downto 0);

    signal b_out_store1_muxed: signed(31 downto 0);
    signal b_out_store2_muxed: signed(31 downto 0);

    signal b_out_store1_write: boolean; -- When true store1 has to be written, when false - store2.
    signal b_out_store1_read: boolean; -- When true store1 has to be read, when false - store2.
begin
    
	-- Reading stage (a)
    b_in_notify <= b_in_state = a;
    b_in_ready <= not(b_in_state = a) or (b_in_sync and b_in_state = a);
    b_out_store1_muxed <= (b_in + to_signed(1,32)) when (b_in_state = a and b_in_sync and b_out_store1_write) else b_out_store1;
    b_out_store2_muxed <= (b_in + to_signed(1,32)) when (b_in_state = a and b_in_sync and not(b_out_store1_write)) else b_out_store2;

	process(clk)
	begin
		if(clk='1' and clk'event) then
			if rst = '1' then
				b_in_state <= a;
				b_out_store1_write <= true;
			else
				if b_in_sync and b_in_state = a then
					if b_out_store1_write = true then
                        b_out_store1 <= b_in + to_signed(1,32);
					else
                        b_out_store2 <= b_in + to_signed(1,32);
					end if;
					b_out_store1_write <= not(b_out_store1_write);
                end if;

				if b_out_ready then --next stage ready?
				    --yes, continue pipelining
                    b_in_state <= a;
				elsif b_in_sync then --new data incoming?
			        --no, wait for b stage to perform writing
                    b_in_state <= bw;
				end if;
			end if;
		end if;
	end process;


	-- Writing stage (b)
    b_out_notify <= b_out_state = b;
    b_out_ready <= not(b_out_state = b) or (b_out_sync and b_out_state = b);
	b_out <= b_out_store1_muxed when b_out_store1_read else b_out_store2_muxed;
	
	process(clk)
	begin
		if(clk='1' and clk'event) then
			if rst = '1' then
				b_out_state <= aw;
				b_out_store1_read <= true;
			else
				if b_out_sync and b_out_state = b then
					b_out_store1_read <= not(b_out_store1_read);
				end if;

				if b_in_ready then --next stage ready?
					--yes, continue pipelining
				    b_out_state <= b;
				elsif b_out_sync then --new data incoming?
					--no, wait for a stage to perform reading
                    b_out_state <= aw;
				end if;
			end if;
		end if;
	end process;
	
end pipeline_arch;