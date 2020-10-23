-- External data type definition package
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package SCAM_Model_types is
	type status_t is (in_frame, oof_frame);
	type msg_t is record
		data: signed(31 downto 0);
		status: status_t;
	end record;
end package SCAM_Model_types;

