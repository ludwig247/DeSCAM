

-- FUNCTIONS --
macro frame_check(trigg: boolean) : unsigned := 
	if ((trigg = true)) then unsigned(resize(0,32))
	else unsigned(resize(128,32))
end if;
end macro; 

macro parity_check(control: unsigned;counter: unsigned;trigg: boolean) : unsigned := 
	if ((((trigg = true) and ((counter mod resize(2,32))(31 downto 0) /= resize(0,32))) and (control = resize(2,32)))) then unsigned(resize(0,32))
	elsif (not((((trigg = true) and ((counter mod resize(2,32))(31 downto 0) /= resize(0,32))) and (control = resize(2,32)))) and (((trigg = false) and ((counter mod resize(2,32))(31 downto 0) = resize(0,32))) and (control = resize(2,32)))) then unsigned(resize(0,32))
	elsif (not((((trigg = true) and ((counter mod resize(2,32))(31 downto 0) /= resize(0,32))) and (control = resize(2,32)))) and not((((trigg = false) and ((counter mod resize(2,32))(31 downto 0) = resize(0,32))) and (control = resize(2,32)))) and (((trigg = false) and ((counter mod resize(2,32))(31 downto 0) /= resize(0,32))) and (control = resize(1,32)))) then unsigned(resize(0,32))
	elsif (not((((trigg = true) and ((counter mod resize(2,32))(31 downto 0) /= resize(0,32))) and (control = resize(2,32)))) and not((((trigg = false) and ((counter mod resize(2,32))(31 downto 0) = resize(0,32))) and (control = resize(2,32)))) and not((((trigg = false) and ((counter mod resize(2,32))(31 downto 0) /= resize(0,32))) and (control = resize(1,32)))) and (((trigg = true) and ((counter mod resize(2,32))(31 downto 0) = resize(0,32))) and (control = resize(1,32)))) then unsigned(resize(0,32))
	else unsigned(resize(64,32))
end if;
end macro; 

