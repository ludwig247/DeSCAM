library ieee;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

package SCAM_Model_types is
subtype bool is Boolean;
constant FIFO_SIZE : integer := 16;
constant FIFO_WIDTH : integer := integer(ceil(log2(real(FIFO_SIZE))));
type int_array is array(FIFO_SIZE-1 downto 0) of signed(31 downto 0);
type states is (EMPTY, FILLED, FULL);
end package SCAM_Model_types;
