
library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.ALL;
use work.monitor_pkg.ALL;
use work.SCAM_Model_types.all;

entity monitor is
	port(
		clk,rst: IN std_ulogic;
		config_in_sync:  in bool;
		config_in_sig :  in Config;
		frame_pulse_sync:  in bool;
		frame_pulse_sig :  in bool;
		lof_sync:  in bool;
		lof_sig :  in bool;
		oof_sync:  in bool;
		oof_sig :  in bool;
		cnt: in int;
		op_property   : out PROPERTY_T
);
end entity;

architecture FSM of monitor is

signal pre_op_property : PROPERTY_T;
signal op_property_s: property_t;
begin
	op_property <= op_property_s;

	process(clk,rst)
	begin
		if(rst='1') then
			pre_op_property<= op_9;
		elsif (clk='1' and clk'event) then
			pre_op_property <= op_property_s;
		end if;
	end process;

	process(rst,pre_op_property,cnt)
	begin
		if (rst = '1') then
			op_property_s <= op_9;
		else
			case ending_state(pre_op_property) is
			when LOF_0=>
				if(not(frame_pulse_sync)) then 
					op_property_s <=op_10;
				elsif(frame_pulse_sync and oof_sig and frame_pulse_sync) then 
					op_property_s <=op_11;
				elsif(frame_pulse_sync and not(oof_sig) and not((config_in_sig.LOFreset <= cnt)) and frame_pulse_sync) then 
					op_property_s <=op_12;
				elsif(frame_pulse_sync and not(oof_sig) and (config_in_sig.LOFreset <= cnt) and frame_pulse_sync) then 
					op_property_s <=op_13;
				end if;
			when N_LOF_1=>
				if(frame_pulse_sync and oof_sig and (config_in_sig.LOFset <= cnt) and frame_pulse_sync) then 
					op_property_s <=op_14;
				elsif(not(frame_pulse_sync)) then 
					op_property_s <=op_15;
				elsif(frame_pulse_sync and not(oof_sig) and frame_pulse_sync) then 
					op_property_s <=op_16;
				elsif(frame_pulse_sync and oof_sig and not((config_in_sig.LOFset <= cnt)) and frame_pulse_sync) then 
					op_property_s <=op_17;
				end if;
			when others=> op_property_s <= op_9;
		end case;
		end if;
	end process;
end architecture;