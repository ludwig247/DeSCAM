

-- FUNCTIONS --
macro manageBit(interruptStatus: bool;mip: unsigned;position: unsigned) : unsigned := 
	if (interruptStatus) then unsigned((mip or (shift_left(resize(1,32),position))))
	else unsigned((mip and ((shift_left((resize(1,32) * resize(4294967295,32))(31 downto 0),(position + resize(1,32))(31 downto 0))) or ((shift_left(resize(1,32),position)) - resize(1,32))(31 downto 0))))
end if;
end macro; 

