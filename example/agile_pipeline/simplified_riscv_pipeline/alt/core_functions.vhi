-- FUNCTIONS --
macro getOpCode(instr: unsigned) : opcode := 
	if (((instr and resize(127,32)) = resize(3,32))) then (LOAD)
	elsif (not(((instr and resize(127,32)) = resize(3,32))) and ((instr and resize(127,32)) = resize(35,32))) then (STORE)
	else (unknown)
end if;
end macro; 

