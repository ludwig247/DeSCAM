library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package SCAM_Model_types is
	type ME_MaskType is (MT_B, MT_BU, MT_H, MT_HU, MT_W, MT_X);
	type ME_AccessType is (ME_RD, ME_WR, ME_X);
	type CUtoME_IF is record
		addrIn: unsigned(31 downto 0);
		dataIn: unsigned(31 downto 0);
		mask: ME_MaskType;
		req: ME_AccessType;
	end record;
	type CUtoRF_IF is record
		dst: unsigned(31 downto 0);
		dstData: unsigned(31 downto 0);
	end record;
	type MEtoCU_IF is record
		loadedData: unsigned(31 downto 0);
	end record;
	type RFtoCU_IF is record
		reg_file_01: unsigned(31 downto 0);
		reg_file_02: unsigned(31 downto 0);
		reg_file_03: unsigned(31 downto 0);
		reg_file_04: unsigned(31 downto 0);
		reg_file_05: unsigned(31 downto 0);
		reg_file_06: unsigned(31 downto 0);
		reg_file_07: unsigned(31 downto 0);
		reg_file_08: unsigned(31 downto 0);
		reg_file_09: unsigned(31 downto 0);
		reg_file_10: unsigned(31 downto 0);
		reg_file_11: unsigned(31 downto 0);
		reg_file_12: unsigned(31 downto 0);
		reg_file_13: unsigned(31 downto 0);
		reg_file_14: unsigned(31 downto 0);
		reg_file_15: unsigned(31 downto 0);
		reg_file_16: unsigned(31 downto 0);
		reg_file_17: unsigned(31 downto 0);
		reg_file_18: unsigned(31 downto 0);
		reg_file_19: unsigned(31 downto 0);
		reg_file_20: unsigned(31 downto 0);
		reg_file_21: unsigned(31 downto 0);
		reg_file_22: unsigned(31 downto 0);
		reg_file_23: unsigned(31 downto 0);
		reg_file_24: unsigned(31 downto 0);
		reg_file_25: unsigned(31 downto 0);
		reg_file_26: unsigned(31 downto 0);
		reg_file_27: unsigned(31 downto 0);
		reg_file_28: unsigned(31 downto 0);
		reg_file_29: unsigned(31 downto 0);
		reg_file_30: unsigned(31 downto 0);
		reg_file_31: unsigned(31 downto 0);
	end record;
end package SCAM_Model_types;

library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.SCAM_Model_types.all;

entity Core is
port(
    clk                : in  std_logic;
    rst                : in  std_logic;
    CUtoME_port_sig    : out CUtoME_IF;
    CUtoME_port_sync   : in  boolean;
    CUtoME_port_notify : out boolean;
    MEtoCU_port_sig    : in  MEtoCU_IF;
    MEtoCU_port_sync   : in  boolean;
    MEtoCU_port_notify : out boolean
);
end Core;

architecture core_arch of core is


    signal CUtoME_data_if: CUtoME_IF;
    signal CUtoME_notify_if: boolean;
    signal CUtoME_data_ME: CUtoME_IF;
    signal CUtoME_notify_ME: boolean;
    
    
    signal MEtoCU_data: MEtoCU_IF;
    signal MEtoCU_notify_if: boolean;
    signal MEtoCU_notify_ME: boolean;
   
    
    type if_state_t is (if_write, if_read, if_stall);
    signal if_state: if_state_t;

    type de_state_t is (de_run, de_stall);
    signal de_state: de_state_t;
    
    type ex_state_t is (ex_run, ex_stall, ex_wait);
    signal ex_state: ex_state_t;
    
    type me_state_t is (me_bypass, me_wait, me_stall, me_load_write, me_load_read, me_store_write);
    signal me_state: me_state_t;
    
    type wb_state_t is (wb_run, wb_wait);
    signal wb_state: wb_state_t;

    signal CUtoME_port_busy: boolean;
    signal CUtoME_port_busy_if: boolean;
    signal CUtoME_port_busy_me: boolean;
    signal CUtoME_port_reserve: boolean;
    
    signal MEtoCU_port_busy: boolean;
    signal MEtoCU_port_busy_if: boolean;
    signal MEtoCU_port_busy_me: boolean;
    signal MEtoCU_port_reserve: boolean;

begin


    CUtoME_port_notify <= CUtoME_notify_if or CUtoME_notify_me;
    CUtoME_port_sig <= CUtoME_data_me when CUtoME_notify_me else CUtoME_data_if;


    MEtoCU_port_notify <= MEtoCU_notify_if or MEtoCU_notify_me;


    -- Process used to update global signals
    process(clk)
	begin
		if(clk='1' and clk'event) then
			if rst = '1' then
				CUtoME_port_busy <= false;
				MEtoCU_port_busy <= false;
			else
				MEtoCU_port_busy <= MEtoCU_port_busy_if or MEtoCU_port_busy_me;
				CUtoME_port_busy <= CUtoME_port_busy_if or CUtoME_port_busy_me;
			end if;
		end if;
	end process;

    
    -- IF stage
    CUtoME_notify_me <= if_state = if_write;
    MEtoCU_notify_me <= if_state = if_read;

	-- Port is beeing used by this stage
	CUtoME_port_busy_if <= if_state = if_write and not(CUtoME_port_sync);
	MEtoCU_port_busy_if <= if_state = if_read and not(MEtoCU_port_sync);

    process(clk)
	begin
		if(clk='1' and clk'event) then
			if rst = '1' then
                CUtoME_data_if.addrIn <= (others => '0');
                CUtoME_data_if.dataIn <= (others => '0');
                CUtoME_data_if.mask <= MT_W;
                CUtoME_data_if.req <= ME_RD;
                if_state <= if_write;
			else
                if (if_state = if_write) then
                    if (CUtoME_port_sync) then
                        if_state <= if_read;
                    end if;
                elsif (if_state = if_read) then
                    if (MEtoCU_port_sync) then
                        if_state <= if_write;
                    end if;
                end if;
			end if;
		end if;
	end process;
	
    -- DE stage
    process(clk)
    begin
        if(clk='1' and clk'event) then
            if rst = '1' then
                de_state <= de_stall;
            else
                if (de_state = de_stall) then
                    de_state <= de_run;
                end if;
            end if;
        end if;
    end process;
    
    -- EX stage
    process(clk)
    begin
        if(clk='1' and clk'event) then
            if rst = '1' then
                ex_state <= ex_stall;
            else
                if (ex_state = ex_stall) then
                    ex_state <= ex_run;
                end if;
            end if;
        end if;
    end process;



    -- ME stage
    CUtoME_notify_me <= me_state = me_store_write or me_state = me_load_write;
    MEtoCU_notify_me <= me_state = me_load_read;


	-- Only memory access stage can reserve memory ports because it has the priority
	CUtoME_port_reserve <= not(ex_state = ex_wait) and -- EX stage contains new instruction
                        (((MEtoCU_data.loadedData and x"0000007f") = x"00000003") or -- the new instruction is store and requires memory access
                        ((MEtoCU_data.loadedData and x"0000007f") = x"00000023")) and -- the new instruction is load and requires memory access
						(me_state = me_wait or me_state = me_bypass or -- ME stage in these states is ready for next instruction
                        (me_state = me_store_write and CUtoME_port_sync) or -- last instruction is finished
                        (me_state = me_load_read and MEtoCU_port_sync)); -- last instruction is finished
                    	
                    	
    CUtoME_port_reserve <= not(ex_state = ex_wait); -- the new instruction is load and requires memory access                	
                    	
                    	

	MEtoCU_port_reserve <= me_state = me_load_read and CUtoME_port_sync; -- reading part of the load instruction is going to be executed


	-- Port is beeing used by this stage
	CUtoME_port_busy_me <= (me_state = me_load_write and not(CUtoME_port_sync)) or
                        (me_state = me_store_write and not(CUtoME_port_sync)) or
                    	CUtoME_port_reserve;

	MEtoCU_port_busy_me <= (me_state = me_load_read and not(MEtoCU_port_sync)) or
						MEtoCU_port_reserve;

    process(clk)
	begin
		if(clk='1' and clk'event) then
			if rst = '1' then
                CUtoME_data_me.addrIn <= (others => '0');
                CUtoME_data_me.dataIn <= (others => '0');
                CUtoME_data_me.mask <= MT_W;
                CUtoME_data_me.req <= ME_RD;
                me_state <= me_wait;
			else
			
			    -- Determine next state regarding instruction type and EX stage (stage branch)
			    if (CUtoME_port_reserve) then -- TODO need to check if port is not occupied by IF
                    if ((MEtoCU_data.loadedData and x"0000007f") = x"00000003") then -- store instruction
                        me_state <= me_store_write;
                    elsif ((MEtoCU_data.loadedData and x"0000007f") = x"00000023") then -- load instruction
                        me_state <= me_load_write;
                    else -- all other instructions
                        me_state <= me_bypass;
                    end if;
                end if;
                
                -- Determine next branch state
                if (me_state = me_load_write and CUtoME_port_sync) then
                    me_state <= me_load_read;
                end if;
			end if;
		end if;
	end process;
	
    -- WB stage
    process(clk)
    begin
        if(clk='1' and clk'event) then
            if rst = '1' then
                wb_state <= wb_wait;
            else
                if me_state = me_bypass or me_state = me_load_read then
                    wb_state <= wb_run;
                else
                    wb_state <= wb_wait;
                end if;
            end if;
        end if;
    end process;
	
end core_arch;