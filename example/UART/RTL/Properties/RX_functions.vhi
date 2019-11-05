-- FUNCTIONS --
macro countones(reg: unsigned) : unsigned := 
	unsigned(((((((((reg and resize(1,32)) + ((shift_right(reg,resize(1,32))) and resize(1,32)))(31 downto 0) + ((shift_right(reg,resize(2,32))) and resize(1,32)))(31 downto 0) + ((shift_right(reg,resize(3,32))) and resize(1,32)))(31 downto 0) + ((shift_right(reg,resize(4,32))) and resize(1,32)))(31 downto 0) + ((shift_right(reg,resize(5,32))) and resize(1,32)))(31 downto 0) + ((shift_right(reg,resize(6,32))) and resize(1,32)))(31 downto 0) + ((shift_right(reg,resize(7,32))) and resize(1,32)))(31 downto 0));
end macro; 

macro frame_check(stopbit: unsigned) : unsigned := 
	if ((stopbit /= resize(0,32))) then unsigned(resize(0,32))
	else unsigned(resize(128,32))
end if;
end macro; 

macro parity_check(count: unsigned;parbit: unsigned) : unsigned := 
	if (((parbit /= resize(0,32)) and ((count mod resize(2,32))(31 downto 0) /= resize(0,32)))) then unsigned(resize(0,32))
	elsif (not(((parbit /= resize(0,32)) and ((count mod resize(2,32))(31 downto 0) /= resize(0,32)))) and ((parbit = resize(0,32)) and ((count mod resize(2,32))(31 downto 0) = resize(0,32)))) then unsigned(resize(0,32))
	else unsigned(resize(64,32))
end if;
end macro; 

