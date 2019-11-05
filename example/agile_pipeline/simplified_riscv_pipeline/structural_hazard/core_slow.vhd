library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.SCAM_Model_types.all;

entity core is
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
end core;


architecture core_arch of core is

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
    signal if_current_state, if_next_state: if_state_t;
    signal memory_used_by_if: boolean;
    signal COtoME_data_if: CUtoME_IF;
    signal COtoME_notify_if: boolean;
    signal MEtoCO_data_if_reg: MEtoCU_IF;
    signal MEtoCO_data_if: MEtoCU_IF;
    signal MEtoCO_notify_if: boolean;
    signal if_stage_out_ready: boolean;

    -- DE stage signals -----------------------------------------------------------------------
    type de_state_t is (de_idle, de_run, de_stall);
    signal de_current_state, de_next_state: de_state_t;
    signal MEtoCO_data_de: MEtoCU_IF;
    signal de_stage_in_ready: boolean;
    signal de_stage_out_ready: boolean;

    -- EX stage signals -----------------------------------------------------------------------
    type ex_state_t is (ex_idle, ex_run, ex_stall, ex_compute1, ex_compute2, ex_compute3, ex_compute4, ex_compute5, ex_compute6);
    signal ex_current_state, ex_next_state: ex_state_t;
    signal MEtoCO_data_ex: MEtoCU_IF;
    signal ex_stage_in_ready: boolean;
    signal ex_stage_out_ready: boolean;
    
    -- ME stage signals -----------------------------------------------------------------------   
    type me_state_t is (me_idle, me_bypass, me_wait, me_load_write, me_load_read, me_store_write);
    signal me_current_state, me_next_state: me_state_t;
    signal COtoME_data_me: CUtoME_IF;
    signal COtoME_notify_me: boolean;
    signal MEtoCO_data_me: MEtoCU_IF;
    signal MEtoCO_notify_me: boolean;
    signal memory_used_by_me: boolean;
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
    assert rst /= '0' or not(if_current_state = if_write and me_current_state = me_load_write) report "if_write and me_load_write" severity failure;
    assert rst /= '0' or not(if_current_state = if_write and me_current_state = me_load_read) report "if_write and me_load_read" severity failure;
    assert rst /= '0' or not(if_current_state = if_write and me_current_state = me_store_write) report "if_write and me_store_write" severity failure;
    assert rst /= '0' or not(if_current_state = if_read and me_current_state = me_load_write) report "if_read and me_load_write" severity failure;
    assert rst /= '0' or not(if_current_state = if_read and me_current_state = me_load_read) report "if_read and me_load_read" severity failure;
    assert rst /= '0' or not(if_current_state = if_read and me_current_state = me_store_write) report "if_read and me_store_write" severity failure;
    assert rst /= '0' or not(if_current_state = if_wait and me_current_state = me_wait) report "if_wait and me_wait" severity failure;
    
    -- Memory is the bottleneck and it should be allways used (at least in this particular architecture)
    --assert rst /= '0' or COtoME_notify_if or MEtoCO_notify_if or COtoME_notify_me or MEtoCO_notify_me report "memory port not used" severity failure;
  
    -- Globals -----------------------------------------------------------------------
    COtoME_port_notify <= COtoME_notify_if or COtoME_notify_me;
    COtoME_port_sig <= COtoME_data_me when COtoME_notify_me else COtoME_data_if;

    MEtoCO_port_notify <= MEtoCO_notify_if or MEtoCO_notify_me;
    
    -- IF stage -----------------------------------------------------------------------
    if_stage_out_ready <= (if_current_state = if_read and MEtoCO_port_sync) or if_current_state = if_stall; 
    
    MEtoCO_data_if <= MEtoCO_port_sig when (if_current_state = if_read and MEtoCO_port_sync) else MEtoCO_data_if_reg; 
    
    COtoME_notify_if <= if_current_state = if_write;
    MEtoCO_notify_if <= if_current_state = if_read;

	-- Memory is beeing used by this stage
    memory_used_by_if <= if_current_state = if_write or (if_current_state = if_read and not(MEtoCO_port_sync));

    -- Combinational process to update the next state
    process(all)
    begin
        if_next_state <= if_current_state;

        case if_current_state is
            when if_wait =>
                if not(memory_used_by_me) then
                   -- memory port is acquired
                   if_next_state <= if_write;
                end if; 
            when if_write =>
                if (COtoME_port_sync) then
                    if_next_state <= if_read;
                end if;
            when if_read =>
                if (MEtoCO_port_sync) then
                    if (de_stage_in_ready) then
                        if not(memory_used_by_me) then
                            -- memory port is acquired
                            if_next_state <= if_write;
                        else 
                            if_next_state <= if_wait;
                        end if;
                    else
                        if_next_state <= if_stall;
                    end if;
                end if;
          when if_stall =>
              if (de_stage_in_ready) then
                  if not(memory_used_by_me) then
                      -- memory port is acquired
                      if_next_state <= if_write;
                  else
                      if_next_state <= if_wait;
                  end if;
              end if;
         end case;
     end process;

    -- Process to update the current state and other registers
    process(clk)
	begin
        if (clk = '1' and clk'event) then
            if rst = '1' then
                -- set the initial state
                if_current_state <= if_write;
                
                -- set write data
                COtoME_data_if.addrIn <= (others => '0');
                COtoME_data_if.dataIn <= (others => '0');
                COtoME_data_if.mask <= MT_W;
                COtoME_data_if.req <= ME_RD;
                MEtoCO_data_if_reg.loadedData <= (others => '0');
            else
                -- update the current state
                if_current_state <= if_next_state;
                
                if (not(if_current_state = if_write) and if_next_state = if_write) then
                    -- set write data
                    COtoME_data_if.addrIn <= COtoME_data_if.addrIn + 4;
                end if;
                
                if (if_current_state = if_read) then
                    if (MEtoCO_port_sync) then
                        -- read instruction from memory
                        MEtoCO_data_if_reg <= MEtoCO_port_sig;
                    end if;
                end if;
			end if;
        end if;
	end process;
	
	
    -- DE stage -----------------------------------------------------------------------
    de_stage_in_ready <= (de_stage_out_ready and ex_stage_in_ready) or de_current_state = de_idle; 
    
    de_stage_out_ready <= de_current_state = de_run or de_current_state = de_stall; 
    
    -- Combinational process to update the next state
    process(all)
    begin
        de_next_state <= de_current_state;

        case de_current_state is
            when de_idle =>
                if (if_stage_out_ready) then
                    de_next_state <= de_run;
                end if;
            when de_run =>
                if (not(ex_stage_in_ready)) then
                    de_next_state <= de_stall;
                end if;    
                if (not(if_stage_out_ready) and ex_stage_in_ready) then
                    de_next_state <= de_idle;
                end if;
            when de_stall =>
                if (if_stage_out_ready and ex_stage_in_ready) then
                    de_next_state <= de_run;
                end if;
                if (not(if_stage_out_ready) and ex_stage_in_ready) then
                    de_next_state <= de_idle;
                end if;
            end case;
    end process;

    -- Process to update the current state and other registers
    process(clk)
    begin
        if (clk = '1' and clk'event) then
            if rst = '1' then
                -- set the initial state
                de_current_state <= de_idle;
            else
                -- update the current state
                de_current_state <= de_next_state;

                if (de_next_state = de_run) then
                    -- execute stuff
                    MEtoCO_data_de <= MEtoCO_data_if;    
                end if;
            end if;
        end if;
    end process;
    
    -- EX stage -----------------------------------------------------------------------
    ex_stage_in_ready <= (ex_stage_out_ready and me_stage_in_ready) or ex_current_state = ex_idle; 

    ex_stage_out_ready <= ex_current_state = ex_run or ex_current_state = ex_stall; 

    -- Combinational process to update the next state
    process(all)
    begin
        ex_next_state <= ex_current_state;

        case ex_current_state is
            when ex_idle =>
                if (de_stage_out_ready) then
                    ex_next_state <= ex_compute1;
                end if;
            when ex_run =>
                if (not(me_stage_in_ready)) then
                    ex_next_state <= ex_stall;
                end if;    
                if (not(de_stage_out_ready) and me_stage_in_ready) then
                    ex_next_state <= ex_idle;
                end if;
            when ex_stall =>
                if (de_stage_out_ready and me_stage_in_ready) then
                    ex_next_state <= ex_compute1;
                end if;
                if (not(de_stage_out_ready) and me_stage_in_ready) then
                    ex_next_state <= ex_idle;
                end if;
            when ex_compute1 =>
                ex_next_state <= ex_compute2;
            when ex_compute2 =>
                ex_next_state <= ex_compute3;
            when ex_compute3 =>
                ex_next_state <= ex_compute4;
            when ex_compute4 =>
                ex_next_state <= ex_compute5;
            when ex_compute5 =>
                ex_next_state <= ex_compute6;
            when ex_compute6 =>
                ex_next_state <= ex_run;
            end case;
    end process;

    -- Process to update the current state and other registers
    process(clk)
    begin
        if (clk = '1' and clk'event) then
            if rst = '1' then
                -- set the initial state
                ex_current_state <= ex_idle;
            else
                -- update the current state
                ex_current_state <= ex_next_state;

                if (ex_next_state = ex_compute1) then
                    -- execute stuff
                    MEtoCO_data_ex <= MEtoCO_data_de;    
                end if;
            end if;
        end if;
    end process;

    -- ME stage -----------------------------------------------------------------------
    me_stage_in_ready <= me_stage_out_ready or 
                        (me_current_state = me_store_write and COtoME_port_sync) or 
                        me_current_state = me_idle;
                        
    me_stage_out_ready <= me_current_state = me_bypass or (me_current_state = me_load_read and MEtoCO_port_sync);
    
    COtoME_data_me.addrIn <= (others => '0');
    COtoME_data_me.dataIn <= (others => '0');
    COtoME_data_me.mask <= MT_W;
    COtoME_data_me.req <= ME_WR when (me_current_state = me_store_write) else ME_RD;
    
    COtoME_notify_me <= me_current_state = me_store_write or me_current_state = me_load_write;
    MEtoCO_notify_me <= me_current_state = me_load_read;

    -- Only memory access stage can reserve memory ports because it has the priority
    COtoME_port_reserve_me <= me_next_state = me_store_write or me_next_state = me_load_write;
    MEtoCO_port_reserve_me <= me_next_state = me_load_read;

    -- Memory is beeing used by this stage
    memory_used_by_me <= COtoME_port_reserve_me or MEtoCO_port_reserve_me or (me_current_state = me_load_write) or 
                        (me_current_state = me_store_write and not(COtoME_port_sync)) or 
                        (me_current_state = me_load_read and not(MEtoCO_port_sync));

    -- Combinational process to update the next state
    process(all)
    begin
        me_next_state <= me_current_state;

        case me_current_state is
            when me_wait =>
                if (not(memory_used_by_if)) then
                    if is_store_instr(MEtoCO_data_ex) then
                        -- memory port is acquired
                        me_next_state <= me_store_write; -- store instruction
                    elsif is_load_instr(MEtoCO_data_ex) then
                        -- memory port is acquired
                        me_next_state <= me_load_write; -- load instruction (request data)
                    end if;
                end if;
            when me_load_write =>
                if (COtoME_port_sync) then
                    me_next_state <= me_load_read; -- load instruction (receive data)
                end if;
            when me_load_read | me_store_write | me_bypass | me_idle =>
                if (me_stage_in_ready) then -- enlists all of the conditions under wthich a new instruciton can be processed
                    if (ex_stage_out_ready) then
                        if is_store_instr(MEtoCO_data_ex) then -- store instruction
                            if (not(memory_used_by_if)) then
                                -- memory port is acquired
                                me_next_state <= me_store_write;
                            else 
                                me_next_state <= me_wait;
                            end if;
                        elsif is_load_instr(MEtoCO_data_ex) then -- load instruction (request data)
                            if (not(memory_used_by_if)) then
                                -- memory port is acquired
                                me_next_state <= me_load_write;
                            else 
                                me_next_state <= me_wait;
                            end if;
                        else -- all other instructions
                            if (true) then -- depending on the instruction
                                -- need write back
                                me_next_state <= me_bypass;
                            else
                                -- no write back needed
                                me_next_state <= me_idle;
                            end if; 
                        end if;
                    else
                        me_next_state <= me_idle;
                    end if;
                end if;
            end case;
    end process;

    -- Process to update the current state and other registers
    process(clk)
    begin
        if (clk = '1' and clk'event) then
            if rst = '1' then
                -- set the initial state
                me_current_state <= me_idle;
            else
                -- update the current state
                me_current_state <= me_next_state;

                if (me_stage_in_ready) then  -- enlists all of the conditions under wthich a new instruciton can be processed
                    MEtoCO_data_me <= MEtoCO_data_ex;  
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
	
end core_arch;
