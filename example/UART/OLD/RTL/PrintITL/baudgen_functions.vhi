

-- FUNCTIONS --
macro calc_prescaler(Clock: unsigned;baud_ctrl: unsigned) : unsigned := 
	if ((baud_ctrl = resize(0,32))) then unsigned((Clock div resize(9600,32))(31 downto 0))
	elsif (not((baud_ctrl = resize(0,32))) and (baud_ctrl = resize(1,32))) then unsigned((Clock div resize(57600,32))(31 downto 0))
	elsif (not((baud_ctrl = resize(0,32))) and not((baud_ctrl = resize(1,32))) and (baud_ctrl = resize(2,32))) then unsigned((Clock div resize(115200,32))(31 downto 0))
	else unsigned((Clock div resize(256000,32))(31 downto 0))
end if;
end macro; 

macro count(counter: unsigned;prescaler: unsigned) : unsigned := 
	if ((counter = prescaler)) then unsigned(resize(0,32))
	else unsigned((counter + resize(1,32))(31 downto 0))
end if;
end macro; 

macro trigging(counter: unsigned;prescaler: unsigned) : unsigned := 
	if ((counter = prescaler)) then unsigned(resize(1,32))
	else unsigned(resize(0,32))
end if;
end macro; 

