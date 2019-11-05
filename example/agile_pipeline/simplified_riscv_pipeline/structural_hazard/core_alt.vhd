library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.SCAM_Model_types.all;

entity core_alt is
port(
    clk                : in  std_logic;
    rst                : in  std_logic;
    COtoME_port_sig    : out CUtoME_IF;
    COtoME_port_sync   : in  boolean;
    COtoME_port_notify : out boolean;
    MEtoCO_port_sig    : in  MEtoCU_IF;
    MEtoCO_port_sync   : in  boolean;
    MEtoCO_port_notify : out boolean
);
end core_alt;


architecture core_alt_arch of core_alt is

    -- Functions -----------------------------------------------------------------------
    function is_store_instr(instr : MEtoCU_IF) return boolean is
    begin
        return (instr.loadedData and x"0000007f") = x"00000023";
    end is_store_instr;
    
    function is_load_instr(instr : MEtoCU_IF) return boolean is
    begin
        return (instr.loadedData and x"0000007f") = x"00000003";
    end is_load_instr;

    -- IF stage signals -----------------------------------------------------------------------
    type if_state_t is (if_write, if_read, if_wait, if_stall);
    signal if_state: if_state_t;
    signal ME_busy_if: boolean;
    signal COtoME_data_if: CUtoME_IF;
    signal COtoME_notify_if: boolean;
    signal MEtoCO_data_if_reg: MEtoCU_IF;
    signal MEtoCO_data_if: MEtoCU_IF;
    signal MEtoCO_notify_if: boolean;
    signal if_stage_out_ready: boolean;

    -- DE stage signals -----------------------------------------------------------------------
    type de_state_t is (de_idle, de_run, de_stall);
    signal de_state: de_state_t;
    signal MEtoCO_data_de: MEtoCU_IF;
    signal de_stage_in_ready: boolean;
    signal de_stage_out_ready: boolean;

    -- EX stage signals -----------------------------------------------------------------------
    type ex_state_t is (ex_idle, ex_run, ex_stall);
    signal ex_state: ex_state_t;
    signal MEtoCO_data_ex: MEtoCU_IF;
    signal ex_stage_in_ready: boolean;
    signal ex_stage_out_ready: boolean;
    
    -- ME stage signals -----------------------------------------------------------------------   
    type me_state_t is (me_idle, me_bypass, me_wait, me_load_write, me_load_read, me_store_write);
    signal me_state: me_state_t;
    signal COtoME_data_me: CUtoME_IF;
    signal COtoME_notify_me: boolean;
    signal MEtoCO_data_me: MEtoCU_IF;
    signal MEtoCO_notify_me: boolean;
    signal ME_busy_me: boolean;
    signal COtoME_port_reserve_me: boolean;
    signal MEtoCO_port_reserve_me: boolean;
    signal me_stage_in_ready: boolean;
    signal me_stage_out_ready: boolean;   

    -- WB stage signals ----------------------------------------------------------------------- 
    --type wb_state_t is (wb_run, wb_wait);
    --signal wb_state: wb_state_t;
 
begin

    -- Assertions -----------------------------------------------------------------------
    -- Mutual exclusion for shared resources
    assert rst /= '0' or not(if_state = if_write and me_state = me_load_write) report "if_write and me_load_write" severity failure;
    assert rst /= '0' or not(if_state = if_write and me_state = me_load_read) report "if_write and me_load_read" severity failure;
    assert rst /= '0' or not(if_state = if_write and me_state = me_store_write) report "if_write and me_store_write" severity failure;
    assert rst /= '0' or not(if_state = if_read and me_state = me_load_write) report "if_read and me_load_write" severity failure;
    assert rst /= '0' or not(if_state = if_read and me_state = me_load_read) report "if_read and me_load_read" severity failure;
    assert rst /= '0' or not(if_state = if_read and me_state = me_store_write) report "if_read and me_store_write" severity failure;
    assert rst /= '0' or not(if_state = if_wait and me_state = me_wait) report "if_wait and me_wait" severity failure;
    
    -- Memory is the bottleneck and it should be allways used (at least in this particular architecture)
    assert rst /= '0' or COtoME_notify_if or MEtoCO_notify_if or COtoME_notify_me or MEtoCO_notify_me report "memory port not used" severity failure;
  
    -- Globals -----------------------------------------------------------------------
    COtoME_port_notify <= COtoME_notify_if or COtoME_notify_me;
    COtoME_port_sig <= COtoME_data_me when COtoME_notify_me else COtoME_data_if;

    MEtoCO_port_notify <= MEtoCO_notify_if or MEtoCO_notify_me;
    
    -- IF stage -----------------------------------------------------------------------
    if_stage_out_ready <= (if_state = if_read and MEtoCO_port_sync) or if_state = if_stall; 
    
    MEtoCO_data_if <= MEtoCO_port_sig when (if_state = if_read and MEtoCO_port_sync) else MEtoCO_data_if_reg; 
    
    COtoME_notify_if <= if_state = if_write;
    MEtoCO_notify_if <= if_state = if_read;

	-- Memory is beeing used by this stage
    ME_busy_if <= if_state = if_write or (if_state = if_read and not(MEtoCO_port_sync));

    process(clk)
	begin
        if (clk = '1' and clk'event) then
            if rst = '1' then
                -- memory port is acquired 
                if_state <= if_write;
                -- set write data
                COtoME_data_if.addrIn <= (others => '0');
                COtoME_data_if.dataIn <= (others => '0');
                COtoME_data_if.mask <= MT_W;
                COtoME_data_if.req <= ME_RD;
            else
                if (if_state = if_wait) then
                    if (not(COtoME_port_reserve_me) and not(MEtoCO_port_reserve_me) and not(ME_busy_me)) then
                        -- memory port is acquired
                        if_state <= if_write;
                        -- set write data
                        COtoME_data_if.addrIn <= COtoME_data_if.addrIn + 4;
                    end if;
                elsif (if_state = if_write) then
                    if (COtoME_port_sync) then
                        if_state <= if_read;
                    end if;
                elsif (if_state = if_read) then
                    if (MEtoCO_port_sync) then
                        -- read instruction from memory
                        MEtoCO_data_if_reg <= MEtoCO_port_sig;
                        
                        if (de_stage_in_ready) then
                            if (not(COtoME_port_reserve_me) and not(MEtoCO_port_reserve_me) and not(ME_busy_me)) then
                                -- memory port is acquired
                                if_state <= if_write;
                                -- set write data
                                COtoME_data_if.addrIn <= COtoME_data_if.addrIn + 4;
                            else 
                                if_state <= if_wait;
                            end if;
                        else
                            if_state <= if_stall;
                        end if;
                    end if;
                elsif (if_state = if_stall) then
                    if (de_stage_in_ready) then
                        if (not(COtoME_port_reserve_me) and not(MEtoCO_port_reserve_me) and not(ME_busy_me)) then
                            -- memory port is acquired
                            if_state <= if_write;
                            -- set write data
                            COtoME_data_if.addrIn <= COtoME_data_if.addrIn + 4;
                        else
                            if_state <= if_wait;
                        end if;
                    end if;
                end if;
			end if;
        end if;
	end process;
	
    -- DE stage -----------------------------------------------------------------------
	de_stage_in_ready <= ex_stage_in_ready or de_state = de_idle; 
    
    de_stage_out_ready <= de_state = de_run or de_state = de_stall; 
    
    process(clk)
    begin
        if (clk = '1' and clk'event) then
            if rst = '1' then
                de_state <= de_idle;
            else
                if (de_state = de_idle) then
                    if (if_stage_out_ready) then
                        de_state <= de_run;
                        -- execute stuff
                        MEtoCO_data_de <= MEtoCO_data_if;    
                    end if;
                elsif (de_state = de_run) then
                    if (if_stage_out_ready and ex_stage_in_ready) then
                        -- execute stuff
                        MEtoCO_data_de <= MEtoCO_data_if;
                    elsif (not(ex_stage_in_ready)) then
                        de_state <= de_stall;
                    elsif (not(if_stage_out_ready) and ex_stage_in_ready) then
                        de_state <= de_idle;
                    end if;
                elsif (de_state = de_stall) then
                    if (if_stage_out_ready and ex_stage_in_ready) then
                        de_state <= de_run;
                        -- execute stuff
                        MEtoCO_data_de <= MEtoCO_data_if;
                    elsif (not(if_stage_out_ready) and ex_stage_in_ready) then
                        de_state <= de_idle;
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    -- EX stage -----------------------------------------------------------------------
	ex_stage_in_ready <= me_stage_in_ready or ex_state = ex_idle; 

	ex_stage_out_ready <= ex_state = ex_run or ex_state = ex_stall; 
	
    process(clk)
    begin
        if (clk = '1' and clk'event) then
            if rst = '1' then
                ex_state <= ex_idle;
            else
                if (ex_state = ex_idle) then
                    if (de_stage_out_ready) then
                        ex_state <= ex_run;
                        -- execute stuff
                        MEtoCO_data_ex <= MEtoCO_data_de;
                    end if;
                elsif (ex_state = ex_run) then
                    if (de_stage_out_ready and me_stage_in_ready) then
                        -- execute stuff
                        MEtoCO_data_ex <= MEtoCO_data_de;
                    elsif (not(me_stage_in_ready)) then
                        ex_state <= ex_stall;
                    elsif (not(de_stage_out_ready) and me_stage_in_ready) then
                        ex_state <= ex_idle;
                    end if;
                elsif (ex_state = ex_stall) then
                    if (de_stage_out_ready and me_stage_in_ready) then
                        ex_state <= ex_run;
                        -- execute stuff
                        MEtoCO_data_ex <= MEtoCO_data_de;
                    elsif (not(de_stage_out_ready) and me_stage_in_ready) then
                        ex_state <= ex_idle;
                    end if;
                end if;
            end if;
        end if;
    end process;

    -- ME stage -----------------------------------------------------------------------
    me_stage_in_ready <= me_state = me_bypass or me_state = me_idle or
                        (me_state = me_load_read and MEtoCO_port_sync) or
                        (me_state = me_store_write and COtoME_port_sync);
                        
    me_stage_out_ready <= me_state = me_bypass or (me_state = me_load_read and MEtoCO_port_sync);
    
    COtoME_data_me.addrIn <= (others => '0');
    COtoME_data_me.dataIn <= (others => '0');
    COtoME_data_me.mask <= MT_W;
    
    COtoME_notify_me <= me_state = me_store_write or me_state = me_load_write;
    MEtoCO_notify_me <= me_state = me_load_read;

    -- Only memory access stage can reserve memory ports because it has the priority
    COtoME_port_reserve_me <= me_state = me_wait or -- waiting for resource already
                        (ex_stage_out_ready and -- EX stage contains new instruction
                        (is_load_instr(MEtoCO_data_ex) or is_store_instr(MEtoCO_data_ex)) and -- the new instruction is load or store and requires memory access
                        me_stage_in_ready); -- last instruction is finished                              
                        

    MEtoCO_port_reserve_me <= me_state = me_load_write and COtoME_port_sync; -- the reading part of the load instruction is going to be executed


    -- Memory is beeing used by this stage
    ME_busy_me <= (me_state = me_load_write) or (me_state = me_store_write and not(COtoME_port_sync)) or 
                        (me_state = me_load_read and not(MEtoCO_port_sync));

    COtoME_data_me.req <= ME_WR when (me_state = me_store_write) else ME_RD;
    
    process(clk)
	begin
		if (clk = '1' and clk'event) then
			if rst = '1' then
                me_state <= me_idle;
            else
                if (me_state = me_wait) then
                    if (not(ME_busy_if)) then
                        if is_store_instr(MEtoCO_data_ex) then
                            -- memory port is acquired
                            me_state <= me_store_write; -- store instruction
                        elsif is_load_instr(MEtoCO_data_ex) then
                            -- memory port is acquired
                            me_state <= me_load_write; -- load instruction (request data)
                        end if;
                    end if;
                elsif (me_state = me_load_write) then
                    if (COtoME_port_sync) then
                        me_state <= me_load_read; -- load instruction (receive data)
                    end if;
                elsif (me_stage_in_ready) then
                    MEtoCO_data_me <= MEtoCO_data_ex;
                    if (ex_stage_out_ready) then
                        if is_store_instr(MEtoCO_data_ex) then -- store instruction
                            if (not(ME_busy_if)) then
                                -- memory port is acquired
                                me_state <= me_store_write;
                            else 
                                me_state <= me_wait;
                                -- read data from previous stage to a reg
                            end if;
                        elsif is_load_instr(MEtoCO_data_ex) then -- load instruction (request data)
                            if (not(ME_busy_if)) then
                                -- memory port is acquired
                                me_state <= me_load_write;
                            else 
                                me_state <= me_wait;
                                -- read data from previous stage to a reg (not sure, if previous state is in stall then all ok)
                            end if;
                        else -- all other instructions
                            if (true) then -- depending on the instruction
                                -- need write back
                                me_state <= me_bypass;
                            else
                                -- no write back needed
                                me_state <= me_idle;
                            end if; 
                        end if;
                    else
                        -- not(ex_stage_out_ready)
                        me_state <= me_idle;
                    end if;
                end if;
			end if;
		end if;
	end process;

    -- WB stage -----------------------------------------------------------------------
    process(clk)
    begin
        if (clk = '1' and clk'event) then
            if me_stage_out_ready then
                -- store to register
            end if;
        end if;
    end process;
	
end core_alt_arch;
