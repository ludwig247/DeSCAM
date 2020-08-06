--
-- Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 30.11.18
--

-- FUNCTIONS --
macro manageBit(interruptStatus: boolean;mip: unsigned;position: unsigned) : unsigned := 
	if (interruptStatus) then unsigned((mip or (shift_left(resize(1,32),position))))
	else unsigned((mip and ((shift_left(unsigned(resize(-1,32)),(position + resize(1,32))(31 downto 0))) or ((shift_left(resize(1,32),position)) - resize(1,32))(31 downto 0))))
end if;
end macro; 

