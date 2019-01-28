library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.SCAM_Model_types.all;


package SCAM_Model_types is
subtype bool is Boolean;
subtype int is Integer;
type Example_SECTIONS is (frame_data,frame_start,idle);
type status_t is (in_frame,oof_frame);
type msg_t is record
	data: signed(31 downto 0);
	status: status_t;
end record;
end package SCAM_Model_types;


