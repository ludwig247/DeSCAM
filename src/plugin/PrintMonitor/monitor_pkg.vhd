library ieee ;
use ieee.std_logic_1164.all;
package monitor_pkg is
	type PROPERTY_T is (op_9,op_10,op_11,op_12,op_13,op_14,op_15,op_16,op_17);
	type CSM_STATE is (init,LOF_0,N_LOF_1);
	function ending_state (op : PROPERTY_T) return CSM_STATE;
end monitor_pkg;

package body monitor_pkg is
	function ending_state (op : PROPERTY_T) return CSM_STATE is
	begin
		case op is
			when op_9=> return N_LOF_1;
			when op_10=> return LOF_0;
			when op_11=> return LOF_0;
			when op_12=> return LOF_0;
			when op_13=> return N_LOF_1;
			when op_14=> return LOF_0;
			when op_15=> return N_LOF_1;
			when op_16=> return N_LOF_1;
			when op_17=> return N_LOF_1;
		end case;
	end ending_state;
end monitor_pkg;

package SCAM_Model_types is
subtype bool is Boolean;
subtype int is Integer;
type Monitor_SECTIONS is (LOF,N_LOF);
type Config is record
	LOFreset: int;
	LOFset: int;
end record;
end package SCAM_Model_types;