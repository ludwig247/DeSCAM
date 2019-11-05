library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.SCAM_Model_types.all;
use work.core_functions.all;

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

	signal reg_01: unsigned(31 downto 0);
	signal reg_02: unsigned(31 downto 0);
	signal reg_03: unsigned(31 downto 0);

    -- IF stage signals -----------------------------------------------------------------------
    type IF_state_t is (IF_write, IF_read, IF_wait, IF_stall);
    signal IF_current_state, IF_next_state: IF_state_t;
    signal IF_memory_used: boolean;
    signal IF_COtoME_port_buffer: CUtoME_IF;
    signal IF_COtoME_notify: boolean;
    signal IF_MEtoCO_port_buffer: MEtoCU_IF;
    signal IF_MEtoCO_notify: boolean;
    signal IF_stage_out_ready: boolean;

    signal IF_PCReg: unsigned(31 downto 0);
	signal IF_encodedInstr: unsigned(31 downto 0);

    -- ID stage signals -----------------------------------------------------------------------
    type ID_state_t is (ID_idle, ID_run, ID_stall);
    signal ID_current_state, ID_next_state: ID_state_t;
    signal ID_stage_in_ready: boolean;
    signal ID_stage_out_ready: boolean;

    signal ID_RS1: unsigned(31 downto 0);
    signal ID_RS1Addr: unsigned(4 downto 0);
    signal ID_RS2: unsigned(31 downto 0);
    signal ID_RS2Addr: unsigned(4 downto 0);
    signal ID_RDAddr: unsigned(4 downto 0);
    signal ID_imm: unsigned(31 downto 0);
    signal ID_ALUSrc: ALUSrc_t;
    signal ID_ALUFunc: ALUFunc_t;
    signal ID_memAction: MemAction_t;
    signal ID_regSrc: RegSrc_t;
    signal ID_regWrite: boolean;

    -- EX stage signals -----------------------------------------------------------------------
    type EX_state_t is (EX_idle, EX_run, EX_stall);
    signal EX_current_state, EX_next_state: EX_state_t;
    signal EX_stage_in_ready: boolean;
    signal EX_stage_out_ready: boolean;

    signal EX_ALUResult: unsigned(31 downto 0);
    signal EX_memAction: MemAction_t;
    signal EX_regSrc: RegSrc_t;
    signal EX_regWrite: boolean;
    signal EX_RDAddr: unsigned(4 downto 0);
    signal EX_RS2: unsigned(31 downto 0);
    
    -- ME stage signals -----------------------------------------------------------------------   
    type ME_state_t is (ME_idle, ME_bypass, ME_wait, ME_load_write, ME_load_read, ME_store_write);
    signal ME_current_state, ME_next_state: ME_state_t;
    signal ME_COtoME_port_buffer: CUtoME_IF;
    signal ME_COtoME_notify: boolean;
    signal ME_MEtoCO_port_buffer: MEtoCU_IF;
    signal ME_MEtoCO_notify: boolean;
    signal ME_memory_used: boolean;
    signal ME_COtoME_port_reserve: boolean;
    signal ME_MEtoCO_port_reserve: boolean;
    signal ME_stage_in_ready: boolean;
    signal ME_stage_out_ready: boolean;

    signal ME_loadedData: unsigned(31 downto 0);
    signal ME_regSrc: RegSrc_t;
    signal ME_regWrite: boolean;
    signal ME_RDAddr: unsigned(4 downto 0);
    signal ME_ALUResult: unsigned(31 downto 0);

    -- WB stage signals ----------------------------------------------------------------------- 
    --type wb_state_t is (wb_run, wb_wait);
    --signal wb_state: wb_state_t;
 
begin

    -- Assertions -----------------------------------------------------------------------
    -- Mutual exclusion for shared resources
    assert rst /= '0' or not(IF_current_state = IF_write and ME_current_state = ME_load_write) report "IF_write and ME_load_write" severity failure;
    assert rst /= '0' or not(IF_current_state = IF_write and ME_current_state = ME_load_read) report "IF_write and ME_load_read" severity failure;
    assert rst /= '0' or not(IF_current_state = IF_write and ME_current_state = ME_store_write) report "IF_write and ME_store_write" severity failure;
    assert rst /= '0' or not(IF_current_state = IF_read and ME_current_state = ME_load_write) report "IF_read and ME_load_write" severity failure;
    assert rst /= '0' or not(IF_current_state = IF_read and ME_current_state = ME_load_read) report "IF_read and ME_load_read" severity failure;
    assert rst /= '0' or not(IF_current_state = IF_read and ME_current_state = ME_store_write) report "IF_read and ME_store_write" severity failure;
    assert rst /= '0' or not(IF_current_state = IF_wait and ME_current_state = ME_wait) report "IF_wait and ME_wait" severity failure;
    
    -- Memory is the bottleneck and it should be allways used (at least in this particular architecture)
    assert rst /= '0' or IF_COtoME_notify or IF_MEtoCO_notify or ME_COtoME_notify or ME_MEtoCO_notify report "memory port not used" severity failure;
  
    -- Globals -----------------------------------------------------------------------
    COtoME_port_notify <= IF_COtoME_notify or ME_COtoME_notify;
    COtoME_port_sig <= ME_COtoME_port_buffer when ME_COtoME_notify else IF_COtoME_port_buffer;

    MEtoCO_port_notify <= IF_MEtoCO_notify or ME_MEtoCO_notify;
    
    -- IF stage -----------------------------------------------------------------------
    IF_stage_out_ready <= (IF_current_state = IF_read and MEtoCO_port_sync) or IF_current_state = IF_stall; 
    
    IF_encodedInstr <= MEtoCO_port_sig.loadedData when (IF_current_state = IF_read and MEtoCO_port_sync) else IF_MEtoCO_port_buffer.loadedData; 
    
    IF_COtoME_notify <= IF_current_state = IF_write;
    IF_MEtoCO_notify <= IF_current_state = IF_read;

	-- Memory is beeing used by this stage
    IF_memory_used <= IF_current_state = IF_write or (IF_current_state = IF_read and not(MEtoCO_port_sync));

	-- Set write data
	IF_COtoME_port_buffer.addrIn <= IF_PCReg;
    IF_COtoME_port_buffer.dataIn <= (others => '0');
    IF_COtoME_port_buffer.mask <= MT_W;
    IF_COtoME_port_buffer.req <= ME_RD;

    -- Combinational process to update the next state
    process(all)
    begin
        IF_next_state <= IF_current_state;

        case IF_current_state is
            when IF_wait =>
                if not(ME_memory_used) then
                   -- memory port is acquired
                   IF_next_state <= IF_write;
                end if; 
            when IF_write =>
                if (COtoME_port_sync) then
                    IF_next_state <= IF_read;
                end if;
            when IF_read =>
                if (MEtoCO_port_sync) then
                    if (ID_stage_in_ready) then
                        if not(ME_memory_used) then
                            -- memory port is acquired
                            IF_next_state <= IF_write;
                        else 
                            IF_next_state <= IF_wait;
                        end if;
                    else
                        IF_next_state <= IF_stall;
                    end if;
                end if;
          when IF_stall =>
              if (ID_stage_in_ready) then
                  if not(ME_memory_used) then
                      -- memory port is acquired
                      IF_next_state <= IF_write;
                  else
                      IF_next_state <= IF_wait;
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
                IF_current_state <= IF_write;
                
                IF_PCReg <= (others => '0');
                IF_MEtoCO_port_buffer.loadedData <= (others => '0');
            else
                -- update the current state
                IF_current_state <= IF_next_state;
                
                if (not(IF_current_state = IF_write) and IF_next_state = IF_write) then
                    -- set write data
                    IF_PCReg <= IF_PCReg + 4;
                end if;
                
                if (IF_current_state = IF_read) then
                    if (MEtoCO_port_sync) then
                        -- read instruction from memory
                        IF_MEtoCO_port_buffer <= MEtoCO_port_sig;
                    end if;
                end if;
			end if;
        end if;
	end process;
	
	
    -- ID stage -----------------------------------------------------------------------
	ID_stage_in_ready <= (ID_stage_out_ready and EX_stage_in_ready) or ID_current_state = ID_idle; 
    
    ID_stage_out_ready <= ID_current_state = ID_run or ID_current_state = ID_stall; 

    ID_RS1Addr <= resize(getRS1Addr(IF_encodedInstr) and x"00000003", ID_RS1Addr'length); -- gets reduced address
    ID_RS2Addr <= resize(getRS2Addr(IF_encodedInstr) and x"00000003", ID_RS2Addr'length); -- gets reduced address
    
    -- Combinational process to update the next state
    process(all)
    begin
        ID_next_state <= ID_current_state;

        case ID_current_state is
            when ID_idle =>
                if (IF_stage_out_ready) then
                    ID_next_state <= ID_run;
                end if;
            when ID_run =>
                if (not(EX_stage_in_ready)) then
                    ID_next_state <= ID_stall;
                end if;    
                if (not(IF_stage_out_ready) and EX_stage_in_ready) then
                    ID_next_state <= ID_idle;
                end if;
            when ID_stall =>
                if (IF_stage_out_ready and EX_stage_in_ready) then
                    ID_next_state <= ID_run;
                end if;
                if (not(IF_stage_out_ready) and EX_stage_in_ready) then
                    ID_next_state <= ID_idle;
                end if;
            end case;
    end process;

    -- Process to update the current state and other registers
    process(clk)
    begin
        if (clk = '1' and clk'event) then
            if rst = '1' then
                -- set the initial state
                ID_current_state <= ID_idle;
            else
                -- update the current state
                ID_current_state <= ID_next_state;

                if (ID_next_state = ID_run) then
                    -- execute stuff

	                if ID_RS1Addr = 0 then
	                    ID_RS1 <= (others => '0');
	                elsif ID_RS1Addr = 1 then
	                    ID_RS1 <= reg_01;
	                elsif ID_RS1Addr = 2 then
	                    ID_RS1 <= reg_02;
	                elsif ID_RS1Addr = 3 then
	                    ID_RS1 <= reg_03;
                	end if;

	                if ID_RS2Addr = 0 then
	                    ID_RS2 <= (others => '0');
	                elsif ID_RS2Addr = 1 then
	                    ID_RS2 <= reg_01;
	                elsif ID_RS2Addr = 2 then
	                    ID_RS2 <= reg_02;
	                elsif ID_RS2Addr = 3 then
	                    ID_RS2 <= reg_03;
                	end if;

                    ID_imm <= getImmediate(IF_encodedInstr);
                	ID_RDAddr <= resize(getRDAddr(IF_encodedInstr) and x"00000003", ID_RDAddr'length);
                	ID_ALUFunc <= getALUFunc(getInstr(IF_encodedInstr));

	                if getOpcode(IF_encodedInstr) = OPCODE_R then
	                    ID_ALUSrc <= ALUS_RS2;
	                    ID_memAction <= MA_NONE;
	                    ID_regSrc <= RS_ALU;
	                    ID_regWrite <= true;
	                elsif getOpcode(IF_encodedInstr) = OPCODE_I_L then
	                    ID_ALUSrc <= ALUS_IMM;
	                    ID_memAction <= MA_READ;
	                    ID_regSrc <= RS_MEM;
	                    ID_regWrite <= true;
	                elsif getOpcode(IF_encodedInstr) = OPCODE_S then
	                    ID_ALUSrc <= ALUS_IMM;
	                    ID_memAction <= MA_WRITE;
	                    ID_regSrc <= RS_X;
	                    ID_regWrite <= false;
	                else
	                    ID_ALUSrc <= ALUS_X;
	                    ID_memAction <= MA_NONE;
	                    ID_regSrc <= RS_X;
	                    ID_regWrite <= false;
	                end if;
                end if;
            end if;
        end if;
    end process;
    
    -- EX stage -----------------------------------------------------------------------
	EX_stage_in_ready <= (EX_stage_out_ready and ME_stage_in_ready) or EX_current_state = EX_idle; 

	EX_stage_out_ready <= EX_current_state = EX_run or EX_current_state = EX_stall; 
	
    -- Combinational process to update the next state
    process(all)
    begin
        EX_next_state <= EX_current_state;

        case EX_current_state is
            when EX_idle =>
                if (ID_stage_out_ready) then
                    EX_next_state <= EX_run;
                end if;
            when EX_run =>
                if (not(ME_stage_in_ready)) then
                    EX_next_state <= EX_stall;
                end if;    
                if (not(ID_stage_out_ready) and ME_stage_in_ready) then
                    EX_next_state <= EX_idle;
                end if;
            when EX_stall =>
                if (ID_stage_out_ready and ME_stage_in_ready) then
                    EX_next_state <= EX_run;
                end if;
                if (not(ID_stage_out_ready) and ME_stage_in_ready) then
                    EX_next_state <= EX_idle;
                end if;
            end case;
    end process;

    -- Process to update the current state and other registers
    process(clk)
    begin
        if (clk = '1' and clk'event) then
            if rst = '1' then
                -- set the initial state
                EX_current_state <= EX_idle;
            else
                -- update the current state
                EX_current_state <= EX_next_state;

                if (EX_next_state = EX_run) then
                    -- execute stuff

                    if ID_ALUSrc = ALUS_RS2 then
	                    EX_ALUResult <= getALUResult(ID_ALUFunc, ID_RS1, ID_RS2);
	                elsif ID_ALUSrc = ALUS_IMM then
	                    EX_ALUResult <= getALUResult(ID_ALUFunc, ID_RS1, ID_imm);
	            	end if;

					EX_memAction <= ID_memAction;
					EX_regSrc <= ID_regSrc;
					EX_regWrite <= ID_regWrite;
					EX_RDAddr <= ID_RDAddr;
					EX_RS2 <= ID_RS2;	
                end if;
            end if;
        end if;
    end process;

    -- ME stage -----------------------------------------------------------------------
    ME_stage_in_ready <= ME_stage_out_ready or 
                        (ME_current_state = ME_store_write and COtoME_port_sync) or 
                        ME_current_state = ME_idle;
                        
    ME_stage_out_ready <= ME_current_state = ME_bypass or (ME_current_state = ME_load_read and MEtoCO_port_sync);
    
    ME_COtoME_port_buffer.req <= ME_WR when (ME_current_state = ME_store_write) else ME_RD;
    ME_COtoME_port_buffer.mask <= MT_W;
    
    ME_COtoME_notify <= ME_current_state = ME_store_write or ME_current_state = ME_load_write;
    ME_MEtoCO_notify <= ME_current_state = ME_load_read;

    -- Only memory access stage can reserve memory ports because it has the priority
    ME_COtoME_port_reserve <= ME_next_state = ME_store_write or ME_next_state = ME_load_write;
    ME_MEtoCO_port_reserve <= ME_next_state = ME_load_read;

    -- Memory is beeing used by this stage
    ME_memory_used <= ME_COtoME_port_reserve or ME_MEtoCO_port_reserve or (ME_current_state = ME_load_write) or 
                        (ME_current_state = ME_store_write and not(COtoME_port_sync)) or 
                        (ME_current_state = ME_load_read and not(MEtoCO_port_sync));

	ME_loadedData <= MEtoCO_port_sig.loadedData when (ME_current_state = ME_load_read and MEtoCO_port_sync) else ME_MEtoCO_port_buffer.loadedData;                    

    -- Combinational process to update the next state
    process(all)
    begin
        ME_next_state <= ME_current_state;

        case ME_current_state is
            when ME_wait =>
                if (not(IF_memory_used)) then
                    if EX_memAction = MA_WRITE then
                        -- memory port is acquired
                        ME_next_state <= ME_store_write; -- store instruction
                    elsif EX_memAction = MA_READ then
                        -- memory port is acquired
                        ME_next_state <= ME_load_write; -- load instruction (request data)
                    end if;
                end if;
            when ME_load_write =>
                if (COtoME_port_sync) then
                    ME_next_state <= ME_load_read; -- load instruction (receive data)
                end if;
            when ME_load_read | ME_store_write | ME_bypass | ME_idle =>
                if (ME_stage_in_ready) then -- enlists all of the conditions under wthich a new instruciton can be processed
                    if (EX_stage_out_ready) then
                        if EX_memAction = MA_WRITE then -- store instruction
                            if (not(IF_memory_used)) then
                                -- memory port is acquired
                                ME_next_state <= ME_store_write;
                            else 
                                ME_next_state <= ME_wait;
                            end if;
                        elsif EX_memAction = MA_READ then -- load instruction (request data)
                            if (not(IF_memory_used)) then
                                -- memory port is acquired
                                ME_next_state <= ME_load_write;
                            else 
                                ME_next_state <= ME_wait;
                            end if;
                        else -- all other instructions (TODO: think about possible optimization for idle and bypass states here)
                            if (EX_regWrite = true) then -- depending on the instruction
                                -- need write back
                                ME_next_state <= ME_bypass;
                            else
                                -- no write back needed
                                ME_next_state <= ME_idle;
                            end if; 
                        end if;
                    else
                        ME_next_state <= ME_idle;
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
                ME_current_state <= ME_idle;
            else
                -- update the current state
                ME_current_state <= ME_next_state;

                if (ME_stage_in_ready and EX_stage_out_ready) then  -- enlists all of the conditions under wthich a new token can be received
				    ME_regSrc <= EX_regSrc;
				    ME_regWrite <= EX_regWrite;
				    ME_RDAddr <= EX_RDAddr;
				    ME_ALUResult <= EX_ALUResult;

			        ME_COtoME_port_buffer.addrIn <= EX_ALUResult;
		            ME_COtoME_port_buffer.dataIn <= EX_RS2;
                end if;

                if (ME_current_state = ME_load_read) then
                    if (MEtoCO_port_sync) then
                        -- read data from memory
                        ME_MEtoCO_port_buffer <= MEtoCO_port_sig;
                    end if;
                end if;
            end if;
        end if;
    end process;

    -- WB stage -----------------------------------------------------------------------
    process(clk)
    begin
        if (clk = '1' and clk'event) then
            if ME_stage_out_ready then
                -- store to register
                if (ME_regWrite) then
                    if (ME_regSrc = RS_MEM) then
                        if (ME_RDAddr = 1) then
                            reg_01 <= ME_loadedData;
                        elsif (ME_RDAddr = 2) then
                            reg_02 <= ME_loadedData;
                        elsif (ME_RDAddr = 3) then
                            reg_03 <= ME_loadedData;
                        end if;
                    elsif (ME_regSrc = RS_ALU) then
                        if (ME_RDAddr = 1) then
                            reg_01 <= ME_ALUResult;
                        elsif (ME_RDAddr = 2) then
                            reg_02 <= ME_ALUResult;
                        elsif (ME_RDAddr = 3) then
                            reg_03 <= ME_ALUResult;
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;
	
end core_arch;
