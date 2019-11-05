

-- FUNCTIONS --
macro parity_bit(control: unsigned;counter: unsigned) : unsigned := 
	if ((((counter mod resize(2,32))(31 downto 0) /= resize(0,32)) and (control = resize(2,32)))) then unsigned(resize(1,32))
	elsif (not((((counter mod resize(2,32))(31 downto 0) /= resize(0,32)) and (control = resize(2,32)))) and (((counter mod resize(2,32))(31 downto 0) = resize(0,32)) and (control = resize(1,32)))) then unsigned(resize(1,32))
	else unsigned(resize(0,32))
end if;
end macro; 

