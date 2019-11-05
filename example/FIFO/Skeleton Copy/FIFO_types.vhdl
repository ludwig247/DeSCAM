library ieee;
use IEEE.numeric_std.all;

package FIFO_types is
type FIFO_SECTIONS is (idle, read_write, read, write);
end package FIFO_types;
